%% Generate multi-day data for reverse optimization using an existing cement plant model and parameters from the literature.
% Assume internal parameters are the same for each day, but external electricity prices vary, resulting in different production schedules.

% Refer to the paper: Golmohamadi-2020-robust
% H. Golmohamadi, R. Keypour, B. Bak-Jensen, J. R. Pillai, and M. H. Khooban, “Robust Self-Scheduling of Operational Processes for Industrial Demand Response Aggregators,” IEEE Trans. Ind. Electron., vol. 67, no. 2, 2020.

%% Load parameters related to the load, see details on iPad.

% Read parameters from Excel
filename = "load_parameters_Golmo_milp.xlsx";
load_parameter = xlsread(filename);

% Energy consumption coefficients in MWh/h
e_np = 1e-3 * load_parameter(:, 2 : 2 : end);

% Material production coefficients in kton/h
g_np = 1e-3 * load_parameter(:, 1 : 2 : end - 1);

% Material maximum/minimum values (0), with raw materials having minimal restrictions in kton
S_max = 1e-3 * load_parameter(:, end);
S_max(end) = 4 * 48;

% Initial material values
S_0 = 0.5 * S_max;
S_0(end) = 0;

% Material target values (variation)
S_tar = zeros(size(S_max));
S_tar(end) = 1e-3 * 250 * 23; % The bottleneck stage needs to work for 23 hours.

% Read prices
data_price;

%% Generate electricity usage data

E_primal_days = [];

for idx_day = 1 : length(Price_days)
    Price = Price_days(:, idx_day);

    stn_model_milp;
    
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

save("dataset_cement.mat", "E_primal_days_train", "Price_days_train", ...
    "E_primal_days_cv", "Price_days_cv");
