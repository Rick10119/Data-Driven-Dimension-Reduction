%% basic rtn model

%% read parameters & define variables
add_param_and_var;

%% The original rtn model
cons_basic_rtn = [];

%% initial resources (0)
% device resources: 1
cons_basic_rtn = [cons_basic_rtn, R_RT(index_resource_device, 1) == 1];
% resource_mat_s/d resources: 0
cons_basic_rtn = [cons_basic_rtn, R_RT(index_resource_mat_s_heat, 1) == 0];
cons_basic_rtn = [cons_basic_rtn, R_RT(index_resource_mat_d_heat, 1) == 0];


%% resource balance (1)
temp = reshape(N_IT, 1, NOF_TASK, NOF_INTERVAL);% temp: temporary variable; reshape to 3 dimensions
temp = repmat(temp, NOF_RESOURCE, 1, 1);% repmat the first dimension for dot product
% for t <= max_tau, sum from t = 1 to time_index
for time_index = 1 : max_tau
    temp1 = MU_RIT(:, :, 1 : time_index) .* temp(:, :, time_index : -1 : 1);% dot product
    % to prevent matrix reduction
    if time_index > 1
        temp1 = sum(temp1, 3);% sum together
    end
    temp1 = sum(temp1, 2);% sum together
    cons_basic_rtn = [cons_basic_rtn, R_RT(:, time_index + 1) == R_RT(:, time_index) + temp1];
end

% for t > max_tau, sum from t = (time_index - max_tau) to time_index
for time_index = (max_tau + 1) : NOF_INTERVAL
    temp1 = MU_RIT .* temp(:, :, time_index : -1 : time_index - max_tau);% dot product
    temp1 = sum(temp1, 2);temp1 = sum(temp1, 3);% sum together
    cons_basic_rtn = [cons_basic_rtn, R_RT(:, time_index + 1) == R_RT(:, time_index) + temp1];
end

%% to be added in other parts: electricity consumption (2)

%% Task execution
% tasks are executed the proper number of times (3, 4, 5)
cons_basic_rtn = [cons_basic_rtn, sum(N_IT, 2) == 1];% sum the second dimension

%% Transfer time
% immediate transfer (6)
cons_basic_rtn = [cons_basic_rtn, R_RT(index_resource_mat_s_heat, :) == 0];

% waiting time limit (7) in number of time slots: NOF_PROCESS*NOF_HEAT x 1
temp1 = repmat(param.processing_slot(2, :), NOF_HEAT, 1);% for the transfer time
temp1 = reshape(temp1, size(index_resource_mat_d_heat'));
temp2 = repmat(param.processing_slot(3, :), NOF_HEAT, 1);% for the max waiting time
temp2 = reshape(temp2, size(index_resource_mat_d_heat'));
cons_basic_rtn = [cons_basic_rtn, sum(R_RT(index_resource_mat_d_heat, 2 : end), 2) + temp1 <= temp2];

%% Product Delivery (8)
% final products by the end of the time horizon
cons_basic_rtn = [cons_basic_rtn, R_RT(index_resource_mat_d_heat(end - NOF_HEAT + 1 : end), end) == 1];


%% hourly electricity consumption (2)
temp = repmat(param.nominal_power', 1, NOF_INTERVAL);% form a matrix for nonimal power
E_T = sum((1 - R_RT(index_resource_device, 2 : end)) .* temp) * delta;

%% Objective
% minimize the total energy cost
cost = E_T * price;

%% solve
% TimeLimit = 30;
% ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 1, ...
%     'gurobi.TimeLimit', TimeLimit);
ops = sdpsettings('debug',1,'solver','GUROBI', 'verbose', 1);

sol = optimize(cons_basic_rtn, cost, ops);

%% save
result = {};
result.E_T = value(E_T);
result.N_IT = value(N_IT);
result.R_RT = value(R_RT);

