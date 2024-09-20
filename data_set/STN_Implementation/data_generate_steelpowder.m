%% Generate multi-day data for reverse optimization using an existing steel powder plant model and parameters from the literature.
% Assume internal parameters are the same for each day, but external electricity prices vary, resulting in different production schedules.

%% Refer to the paper: lu-2021-data-driven
% R. Lu, R. Bai, Y. Huang, Y. Li, J. Jiang, and Y. Ding, "Data-driven real-time price-based demand response for industrial facilities energy management,” Appl. Energy, vol. 283, p. 116291, Feb. 2021.

%% Load parameters related to the load

% Read parameters from Excel
filename = "load_parameters_Lu_milp.xlsx";
load_parameter = xlsread(filename);

% Energy consumption coefficients
e_np = load_parameter(:, [2, 4, 6]);

% Material production coefficients
g_np = load_parameter(:, [1, 3, 5]);

% Material maximum/minimum values (0), with raw materials having minimal restrictions
S_max = load_parameter(:, 7);
S_max(end) = 400;

% Initial material values
S_0 = 0.5 * S_max;
S_0(end) = 0;

% Material target values (variation)
S_tar = zeros(size(S_max));
S_tar(end) = 10 * 24; % The bottleneck stage needs to work for 24 hours.

%% Read prices
data_price;

%% Generate electricity usage data

E_primal_days = [];

for idx_day = 1 : length(Price_days)
    Price = Price_days(:, idx_day);

    load_primal_problem_milp;
    
    P_val = value(E_hn);
    % Record electricity usage
    E_primal = ones(1, NOFMACHINES) * P_val;
    E_primal = E_primal';
    
    E_primal_days = [E_primal_days, E_primal];
end

%% Differentiate between training and cross-validation sets

% First 21 days for training, last 10 days for cross-validation
E_primal_days_train = E_primal_days(:, 1 : 21);
E_primal_days_cv = E_primal_days(:, 22 : end);
Price_days_train = Price_days(:, 1 : 21);
Price_days_cv = Price_days(:, 22 : end);

%% Save the data

save("dataset_steelpowder.mat", "E_primal_days_train", "Price_days_train", ...
    "E_primal_days_cv", "Price_days_cv");
