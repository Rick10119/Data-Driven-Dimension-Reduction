%% Calculate the error between the optimal load curve under the identified parameters 
% and the results based on the original constraints given the electricity price.
% The results of Table I

% table: Four methods: SAL, 3DR-1, 3DR-2, 3DR-3. OVB is compared separately.
total_table = ones(4, 3);
data_set_names = ["cement", "steelpowder", "steelmaking"];

%% SAL
for name_idx = 1 : 3

    data_set_name = data_set_names(name_idx);

    % Load data: price and electricity meter data for past time periods
    load("../data_set/dataset_" + data_set_name + ".mat");

        % Results of the trained model
        load("../results/data_rc_" + data_set_name + "_SALs.mat", "E_reduced_constraints");

        % Calculate error (mse)
        mse = mean(mean(abs(E_reduced_constraints - E_primal_days_cv).^2));

        % Calculate error (nrmse)
        nrmse =  sqrt(mse) / max(E_primal_days_cv(:, 1));
        % Record error
        total_table(1, name_idx) = nrmse;

end

%% ALF

for name_idx = 1 : 3

    data_set_name = data_set_names(name_idx);

    % Load data: price and electricity meter data for past time periods
    load("../data_set/dataset_" + data_set_name + ".mat");

    for NOFMODELS = 1 : 3

        % Results of the trained model
        load("../results/data_rc_" + data_set_name + NOFMODELS + "ALs.mat", "E_reduced_constraints");

        % Calculate error (mse)
        mse = mean(mean(abs(E_reduced_constraints - E_primal_days_cv).^2));

        % Calculate error (nrmse)
        nrmse =  sqrt(mse) / max(E_primal_days_cv(:, 1));
        % Record error
        total_table(NOFMODELS + 1, name_idx) = nrmse;

    end

end
