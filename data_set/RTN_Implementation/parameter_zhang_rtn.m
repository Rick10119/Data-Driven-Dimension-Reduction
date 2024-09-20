%% parameter settings borrowed from zhang-2017-cost

% for io
param = {};

%% prcessing parameters
% excel file for the original parameters
filename = "load_parameters_zhang_rtn.xlsx";

% nominal_power
param.nominal_power = xlsread(filename, 'nominal_power');

% processing_time
param.processing_time = xlsread(filename, 'processing_time');

% production target
% param.production_target = 12;

%% market parameters

delta_t = 1;
hour_init = 1;
NOFSLOTS = 24 / delta_t;

% July 2022 rt system energy price from PJM
price_days = [];
for day_price = 1 : 31

start_row = (day_price-1) * 24 + hour_init + 1;
filename = 'rt_hrl_lmps.xlsx';
sheet = 'rt_hrl_lmps'; 
xlRange = "I" + start_row + ":I" + (start_row + NOFSLOTS - 1); 
price = xlsread(filename, sheet, xlRange);
price_days = [price_days, price];% $/MWh

end

param.price_days = price_days;
clear price filename sheet xlRange start_row hour_init day_price NOFSLOTS delta_t

save("param_zhang_2017.mat", "param")




