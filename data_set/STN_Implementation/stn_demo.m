%% Visualize the price, energy consumption, and energy consumption at various stages for a specific day.

%% Refer to the paper lu-2021-data-driven
filename = "load_parameters_Lu_milp.xlsx";

% Validate using Lu-2021 data
load_parameter = xlsread(filename);

% Energy consumption coefficients
e_np =  load_parameter(:, [2, 4, 6]);

% Material production coefficients
g_np =  load_parameter(:, [1, 3, 5]);

% Material maximum/minimum values (0), raw materials are not restricted
S_max = load_parameter(:, 7);
S_max(end) = 400;

% Initial material values
S_0 = 0.5 * S_max;
S_0(end) = 0;

% Material target values (variation)
S_tar = zeros(size(S_max));
S_tar(end) = 10 * 24; % The bottleneck stage needs to work for 24 hours.

% Read prices
data_price;

% Day July 24
idx_day = 23;

% Read the price
Price = Price_days(:, idx_day);

% Solve the optimal production scheduling problem based on STN
stn_model_milp;

%% Plot
linewidth = 2;

% Actual energy consumption
bar(P_val', 0.4,'stacked','DisplayName','P_val');hold on;

y1 = ylabel('Energy Consumption (kWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');

% Plot prices (right axis)
yyaxis right

plot(1:24, 1e3 * Price, "-.g", 'linewidth', linewidth);

ax = gca;
ax.YLim = [0, 300];
ax.YColor = 'black';

legend('Blender','Classifier','Crusher', ...
    'Classifier', ...
    'Crusher', ...
    'Separator', ...
    'Dryer', ...
    'Dehydrator', ...
    'Atomizer', ...
    'Reduction', ...
    'Price', ...
    'fontsize',13.5, ...
    'Location','EastOutside', ...
    'Orientation','vertical', ...
    'FontName', 'Times New Roman');

% Set figure parameters
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
y1 = ylabel('Electricity Price ($/MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');

% Figure size
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 1.6 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% Axis properties
ax = gca;
ax.XLim = [0, 25];

% Font size
ax.FontSize = 13.5;

% Set ticks
ax.XTick = [1:24];

% Adjust labels
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19.4, 7.9]);

saveas(gcf,'typical_load_stn.pdf');




