%% program for training ALF models
% clc;clear;
% Choose a dataset
% data_set_name = "cement";
% data_set_name = "steelpowder";
% data_set_name = "steelmaking";

% Load data: prices and electricity meter data for past time periods
load("data_set/dataset_" + data_set_name + ".mat");
% Size of the training set
data_set.NOFTRAIN = 21;
% Solution settings
TimeLimit = 120; % Maximum solving time per iteration
% Maximum number of iterations
max_itr = 100;
% Length of time interval
delta_t = 1;

% Differentiate models based on the number of transferable loads in the surrogate model
for NOFMODELS = 1:3

    % Variable naming and initialization
    add_varDef_and_initVal;

    % Inverse optimization iterations
    for idx_itr = 0:max_itr
        % Solve the inverse problem, randomly using data from day d
        idx_day = randi([1, data_set.NOFTRAIN], 1, 1);

        % Read price information and electricity meter data (MW) for this day
        price_e = Price_days_train(:, idx_day);
        e_true = E_primal_days_train(:, idx_day);

        % Solve the inverse problem to update val
        inverse_optimization;

        % Learning rate, adaptively updated when the number of iterations is greater than 40
        alpha = 0.9;
        if idx_itr > 40
            alpha = 1 / (idx_itr - 40)^0.5;
        end

        % Update surrogate model parameters and initial values
        P_max_i_val = (1 - alpha) * P_max_i_val + alpha * value(P_max_i);
        assign(P_max_i, P_max_i_val);
        P_min_i_val = (1 - alpha) * P_min_i_val + alpha * value(P_min_i);
        assign(P_min_i, P_min_i_val);
        E_max_i_val = (1 - alpha) * E_max_i_val + alpha * value(E_max_i);
        assign(E_max_i, E_max_i_val);
        E_min_i_val = (1 - alpha) * E_min_i_val + alpha * value(E_min_i);
        assign(E_min_i, E_min_i_val);

        % Record the iteration process
        result.J_theta = [result.J_theta; value(J_theta)];
        result.P_max_i = [result.P_max_i; P_max_i_val];
        result.P_min_i = [result.P_min_i; P_min_i_val];
        result.E_max_i = [result.E_max_i; E_max_i_val];
        result.E_min_i = [result.E_min_i; E_min_i_val];

        % Convergence criterion: change in the loss function over the past NOFDAYS period
        err = 1e-3;
        if idx_itr > data_set.NOFTRAIN && ...
                mean(abs(result.J_theta(end - data_set.NOFTRAIN + 1:end))) < err
            break;
        end
    end

    save("results/data_" + data_set_name + NOFMODELS + "ALs.mat", "result");

    yalmip('clear');

end
