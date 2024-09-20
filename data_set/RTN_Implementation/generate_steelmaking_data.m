%% Generate data using the RTN model for 3DR
E_primal_days = [];

for day_index = 1:31

    NOF_HEAT = 20;
    disp("day_index" + day_index);
    disp("NOF_HEAT" + NOF_HEAT);
    main_basic_rtn;

    % Record electricity consumption
    E_primal = value(E_T)';
    E_primal(1 : NOFHOUR-24) = E_primal(1 : NOFHOUR-24) + E_primal(25 : end);

    % We use 31 hours of data instead of 24 hours because production in an iron plant is uninterrupted,
    % and follows a specific sequence. For example, after task 1 is completed, task 2 may take 4 hours to complete the batch.
    % Therefore, to complete production tasks within 24 hours, task 1 needs to be completed by 19:00, which would prevent nighttime production.
    % In reality, production in an iron plant spans across days, so task 1 should be allowed to run at hour 24. A method that minimally changes the code framework
    % is to extend the day to 31 hours, and then consider production from hours 25-31 as part of hours 1-6. This is the approach we have adopted.

    E_primal_days = [E_primal_days, E_primal(1 : 24)];

end

%% Differentiate between training and testing sets

Price_days = param.price_days;

% First 21 days for training, last 10 days for CV
E_primal_days_train = E_primal_days(:, 1 : 21);
E_primal_days_cv = E_primal_days(:, 22 : end);
Price_days_train = Price_days(:, 1 : 21);
Price_days_cv = Price_days(:, 22 : end);

save("dataset_steelmaking.mat", "E_primal_days_train", "Price_days_train", ...
    "E_primal_days_cv", "Price_days_cv");
