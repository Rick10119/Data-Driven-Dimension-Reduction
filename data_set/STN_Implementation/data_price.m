%% Read the PJM electricity prices corresponding to the training set (including the CV set).

%% Market prices and other parameters
% Read system energy price data
% Time slot length, 1 hour
delta_t = 1;
day_price = 1; % Selected number of days
hour_init = 1; % Start from the first time slot of this day
NOFSLOTS = 24 / delta_t;

% Read prices for all days of this month (July)
Price_days = [];
for day_price = 1 : 31
    start_row = (day_price - 1) * 24 + hour_init + 1; % Start row
    filename = 'rt_hrl_lmps.xlsx';
    sheet = 'rt_hrl_lmps'; % Sheet name
    xlRange = "I" + start_row + ":I" + (start_row + NOFSLOTS - 1); % Range
    Price = xlsread(filename, sheet, xlRange); % Read prices
    Price_days = [Price_days, Price];
end

% Clear variables
clear Price filename sheet xlRange start_row hour_init day_price NOFSLOTS delta_t

% Convert prices to $/kWh
Price_days = Price_days * 1e-3;
