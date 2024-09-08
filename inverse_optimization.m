%% Fitting ALF model parameters on the grid side based on electricity meter data
% Solve for optimal parameters using inverse optimization

%% Constraints
Constraints = [];

%% KKT Conditions
% Stationarity
Constraints = [Constraints, repmat(price_e, 1, NOFMODELS) - mu_p_min_ti + mu_p_max_ti ...
    - repmat(mu_e_min_i, NOFINTERVALS, 1) + repmat(mu_e_max_i, NOFINTERVALS, 1) == 0];

% Constraints of the original problem
% Power upper and lower limits (MW). NOFMODELS * NOFINTERVALS
Constraints = [Constraints, p_ti <= repmat(P_max_i, NOFINTERVALS, 1)];
Constraints = [Constraints, repmat(P_min_i, NOFINTERVALS, 1) <= p_ti];

% Energy in the last time period is between the maximum and minimum values. NOFMODELS
Constraints = [Constraints, sum(p_ti, 1) <= E_max_i];
Constraints = [Constraints, E_min_i <= sum(p_ti, 1)];

% Dual feasibility
Constraints = [Constraints, mu_e_min_i >= 0];
Constraints = [Constraints, mu_e_max_i >= 0];
Constraints = [Constraints, mu_p_min_ti >= 0];
Constraints = [Constraints, mu_p_max_ti >= 0];

% Complementary slackness (Fortuny-Amat transformation)
M = 1e4;
% P_max
Constraints = [Constraints, -p_ti + repmat(P_max_i, NOFINTERVALS, 1) <= M * z_p_max_ti];
Constraints = [Constraints, mu_p_max_ti <= M * (1 - z_p_max_ti)];
% P_min
Constraints = [Constraints, p_ti - repmat(P_min_i, NOFINTERVALS, 1) <= M * z_p_min_ti];
Constraints = [Constraints, mu_p_min_ti <= M * (1 - z_p_min_ti)];
% E_max
Constraints = [Constraints, -sum(p_ti, 1) + E_max_i <= M * z_e_max_i];
Constraints = [Constraints, mu_e_max_i <= M * (1 - z_e_max_i)];
% E_min
Constraints = [Constraints, sum(p_ti, 1) - E_min_i <= M * z_e_min_i];
Constraints = [Constraints, mu_e_min_i <= M * (1 - z_e_min_i)];

%% Prior Assumptions

% Limit variable sizes
% Basic parameter constraints (not necessary to limit non-negativity in the presence of original problem constraints)
Constraints = [Constraints, P_max_i <= M];
Constraints = [Constraints, P_min_i >= 0];
Constraints = [Constraints, E_max_i / NOFINTERVALS <= M];
Constraints = [Constraints, E_min_i >= 0];

% Order constraints
for idx = 1:NOFMODELS - 1
    Constraints = [Constraints, P_max_i(1, idx) <= P_max_i(1, idx + 1)];
end

% Dual variable constraints
Constraints = [Constraints, mu_p_min_ti <= M];
Constraints = [Constraints, mu_p_max_ti <= M];
Constraints = [Constraints, mu_e_min_i <= M];
Constraints = [Constraints, mu_e_max_i <= M];

%% Inverse Problem Objective Function
% Loss function: fitting degree of historical energy consumption data
J_theta = norm(sum(p_ti, 2) - e_true)^2;

%% Solve

objective = J_theta;
ops = sdpsettings('debug', 1, 'solver', 'gurobi', ...
    'verbose', 0, ...
    'gurobi.NonConvex', 2, ...
    'allownonconvex', 1, ...
    'gurobi.TimeLimit', TimeLimit, 'usex0', 1); % 'gurobi.NonConvex', 2, ..., 'usex0', 1
ops.gurobi.TuneTimeLimit = TimeLimit;
sol = optimize(Constraints, objective, ops);

%% Display the training process
disp("Number of iterations: " + idx_itr)
disp("Training loss function J_theta: " + value(J_theta))
