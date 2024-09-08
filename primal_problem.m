%% Solve the original problem to find the optimal energy consumption based on ALF

% Input: electricity prices, problem parameters (to be provided in the upper-level code)
% Output: optimal energy consumption

% Problem parameters
P_max_i = P_max_i_val; % Aggregated power upper limit
P_min_i = P_min_i_val;
E_min_i = E_min_i_val;
E_max_i = E_max_i_val;

% Variables of the original problem: energy (kW)
p_ti = sdpvar(NOFINTERVALS, NOFMODELS, 'full'); % Energy consumption per hour (MWh)

% Constraints of the original problem
Constraints = [];
% Power upper and lower limits (MW). NOFMODELS * NOFINTERVALS
Constraints = [Constraints, p_ti <= repmat(P_max_i, NOFINTERVALS, 1)];
Constraints = [Constraints, repmat(P_min_i, NOFINTERVALS, 1) <= p_ti];

% Energy in the last time period is between the maximum and minimum values. NOFMODELS
Constraints = [Constraints, sum(p_ti, 1) <= E_max_i];
Constraints = [Constraints, E_min_i <= sum(p_ti, 1)];

% Objective function: minimize energy cost
objective = sum(price_e' * p_ti);

% Call GUROBI for optimization
TimeLimit = 120;
ops = sdpsettings('debug', 1, 'solver', 'gurobi', ...
    'verbose', 0, ...
    'gurobi.NonConvex', 2, ...
    'allownonconvex', 1, ...
    'gurobi.TimeLimit', TimeLimit, 'usex0', 1); % 'gurobi.NonConvex', 2, ..., 'usex0', 1
ops.gurobi.TuneTimeLimit = TimeLimit;
sol = optimize(Constraints, objective, ops);

% Record the optimal energy consumption results (for each ALF)
p_val = value(p_ti);
