%% Plot the optimal load curve under the identified parameters and the results based on the original constraints given the electricity price.
% plot Fig. 2

% Select the steel powder factory
data_set_name = "steelpowder";

% Load data: price and electricity meter data for past time periods
load("../data_set/dataset_" + data_set_name + ".mat");

% Day July 23
idx_day = 23 - 21;

% Select the real energy consumption data in the test set (since there is no model selection part, we use cv as the test set)
e_true = E_primal_days_cv(:, idx_day);

% Results of the SAL trained model
load("../results/data_rc_" + data_set_name + "_SALs.mat", "E_reduced_constraints");
e_sal = E_reduced_constraints(:, idx_day);

% Results of the ALF-1 trained model
NOFMODELS = 1;
load("../results/data_rc_" + data_set_name + NOFMODELS + "ALs.mat", "E_reduced_constraints");
e_ALF_1 = E_reduced_constraints(:, idx_day);

% Results of the ALF-2 trained model
NOFMODELS = 2;
load("../results/data_rc_" + data_set_name + NOFMODELS + "ALs.mat", "E_reduced_constraints");
e_ALF_2 = E_reduced_constraints(:, idx_day);

%% Plot

linewidth = 1.5;
plot(1:24, e_true, "-black", 'linewidth', linewidth); hold on;
plot(1:24, e_sal, "--m", 'linewidth', linewidth); hold on;
plot(1:24, e_ALF_1, "--b", 'linewidth', linewidth); hold on;
plot(1:24, e_ALF_2, "--r", 'linewidth', linewidth); hold on;

legend('True value','SAL','D3R-1','D3R-2', ...
'fontsize',13.5, ...
    'Location','SouthWest', ...
'Orientation','vertical', ...
'FontName', 'Times New Roman'); 

% Set axis labels
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
y1 = ylabel('Energy Consumption (kWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');

% Figure size
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 1.6 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% Axis properties
ax = gca;
ax.XLim = [0, 25];     
ax.YLim = [0, 300];     
  
% Font size
ax.FontSize = 13.5;

% Set ticks
ax.XTick = [1:24];

% Adjust labels
ax.XTickLabel =  {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [18, 8]);

saveas(gcf,'typical_load_steelpowder.pdf');
