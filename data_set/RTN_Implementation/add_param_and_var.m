% This code segment pertains to the setting of parameters and the definition of variables for the RTN model. It includes setting various parameters and variables within the model, as well as defining resource consumption and task start times.
% 
% In this code snippet, the parameters of the RTN model are first set, including the time interval, the number of hours data is used for, and the price. The original parameters are then loaded, and based on these parameters, information such as the number of tasks and resources is set. Subsequently, the resource consumption change matrix μ is defined, representing the consumption and restoration of resources during task execution.
% 
% Finally, variables within the model are defined. Among them, RT represents the values of resources at different time points, and NIT indicates whether task i starts execution at time point t.
% 
% This code segment lays the foundation for modeling the RTN model, defining the necessary parameters and variables within the model, and providing a basis for subsequent model solving and optimization.

%% Parameters of the RTN model
clc;yalmip("clear"); % clear;
% Binding time interval, hour - 5 min = 5/60 hour
delta = 60 / 60;%Generally speaking, the time interval is roughly 5-15min
NOFHOUR = 31;
% We use 31 hours of data instead of 24 hours because production in an iron plant is uninterrupted,
% and follows a specific sequence. For example, after task 1 is completed, task 2 may take 4 hours to complete the batch.
% Therefore, to complete production tasks within 24 hours, task 1 needs to be completed by 19:00, which would prevent nighttime production.
% In reality, production in an iron plant spans across days, so task 1 should be allowed to run at hour 24. A method that minimally changes the code framework
% is to extend the day to 31 hours, and then consider production from hours 25-31 as part of hours 1-6. This is the approach we have adopted.
NOF_INTERVAL = NOFHOUR / delta;

% Load the original parameters
load("param_zhang_2017.mat");

% Energy price of day_index
temp = param.price_days(:, day_index); % The price for each time interval
price = [temp; temp(1 : NOFHOUR-24)];

% Number of processes
NOF_PROCESS = length(param.nominal_power);

% Processing time slots
param.processing_slot = ceil(param.processing_time / delta / 60);

% Maximum waiting time of final product: NOF_INTERVAL (relaxed)
param.processing_slot(end) = NOF_INTERVAL;

%% Number/index of tasks (processing, transfer) for each heat
NOF_TASK = NOF_PROCESS * (NOF_HEAT * 2);
index_task_processing = 1 : (NOF_HEAT * 2) : NOF_TASK;
index_task_transfer = 2 : (NOF_HEAT * 2) : NOF_TASK;

%% Number/index of resources (device, mat_s, mat_d)
NOF_RESOURCE = NOF_PROCESS * (1 + NOF_HEAT * 2);
index_resource_device = 1 : (1 + NOF_HEAT * 2) : NOF_RESOURCE;
index_resource_mat_s = 2 : (1 + NOF_HEAT * 2) : NOF_RESOURCE; % Index of the first heat
index_resource_mat_d = 3 : (1 + NOF_HEAT * 2) : NOF_RESOURCE; % Index of the first heat

% Index of resource_mat_s_heat
temp = 1 : NOF_RESOURCE - 1;
for process_index = 1 : NOF_PROCESS
    % Reduce the device indices
    temp(index_resource_device(process_index)) = 2; % 2 is the first index for mat_s
    % Reduce the mat_d indices
    for heat_index = 1 : NOF_HEAT
        temp(index_resource_mat_d(process_index) + (heat_index - 1) * 2) = 2;
    end
end
% Reduce the redundant elements
index_resource_mat_s_heat = unique(temp);

% Index of resource_mat_d_heat
temp = 1 : NOF_RESOURCE;
for process_index = 1 : NOF_PROCESS
    % Reduce the device indices
    temp(index_resource_device(process_index)) = 3; % 3 is the first index for mat_d
    % Reduce the mat_s indices
    for heat_index = 1 : NOF_HEAT
        temp(index_resource_mat_s(process_index) + (heat_index - 1) * 2) = 3;
    end
end
% Reduce the redundant elements
index_resource_mat_d_heat = unique(temp);

%% mu(r, i, theta): Change of resource r by task i after theta time slots
% Largest duration of the tasks
max_tau = max(param.processing_slot(1, :));

% Initialize the mu matrix
MU_RIT = zeros(NOF_RESOURCE, NOF_TASK, 1 + max_tau);

for process_index = 1 : NOF_PROCESS
    for heat_index = 1 : NOF_HEAT
        %% Processing task
        % Processing task -> resource_device, t consumes r at once, and
        % recovers r after tau
        % Reduce
        MU_RIT(index_resource_device(process_index), ...
            index_task_processing(process_index) + (heat_index - 1) * 2, 1) = -1;
        % Recover
        MU_RIT(index_resource_device(process_index), ...
            index_task_processing(process_index) + (heat_index - 1) * 2, ...
            1 + param.processing_slot(1, process_index)) = 1; % Tau slots after t
        
        % Processing task -> resource_mat_d, t consumes r-1 after tau
        if process_index > 1 % The first process only consumes raw material
            MU_RIT(index_resource_mat_d(process_index - 1) + (heat_index - 1) * 2, ...
                index_task_processing(process_index) + (heat_index - 1) * 2, 1) = -1;
        end
        % Processing task -> resource_mat_s, t produces r after tau
        MU_RIT(index_resource_mat_s(process_index) + (heat_index - 1) * 2, ...
            index_task_processing(process_index) + (heat_index - 1) * 2, ...
            1 + param.processing_slot(1, process_index)) = 1;
        
        %% Transfer task
        % Transfer task -> resource_mat_s, t consumes r at once
        MU_RIT(index_resource_mat_s(process_index) + (heat_index - 1) * 2, ...
            index_task_transfer(process_index) + (heat_index - 1) * 2, 1) = -1;
        
        % Transfer task -> resource_mat_d, t produces r after tau
        MU_RIT(index_resource_mat_d(process_index) + (heat_index - 1) * 2, ...
            index_task_transfer(process_index) + (heat_index - 1) * 2, ...
            1 + param.processing_slot(2, process_index)) = 1;
    end
end

%% Variables

% Value of resource i at time t
R_RT = binvar(NOF_RESOURCE, NOF_INTERVAL + 1, 'full');

% Starting time flag of task i: 1 for starting at t
N_IT = binvar(NOF_TASK, NOF_INTERVAL, 'full');
