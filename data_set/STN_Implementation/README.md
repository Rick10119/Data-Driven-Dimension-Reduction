### README (English)

This folder contains MATLAB code implementations for the State-Task Network (STN) model and code for simulating data generation. The model, including the industrial assembly line constraints modeled using STN, the objective function, and the solving code, can be found in `stn_model_milp`. The `stn_demo` provides a simple example, involving reading parameters of a steel powder plant from an Excel file, parameter processing, reading electricity prices, invoking the STN model, and visualizing the optimal energy usage results.

The `data_price` script is a reusable code for reading electricity prices. The folders `data_generate_cement` and `data_generate_steelpowder` generate optimal energy usage results (hourly total energy consumption) under the energy prices of the PJM system in July 2022 using models and parameters from existing literature for a cement plant and a steel powder plant, respectively. These results are used as our dataset.

### 自述文件 (中文)

这个文件夹包含了状态-任务网络（STN）模型的MATLAB代码实现以及用于仿真数据生成的代码。模型，包括使用STN建模的工业流水线约束、目标函数和求解代码，可以在 `stn_model_milp` 中找到。`stn_demo` 提供了一个简单的示例，包括从Excel文件中读取钢粉厂的参数、参数处理、读取电价、调用STN模型以及可视化最优能源使用结果。

`data_price` 脚本是用于读取电价的可重用代码。`data_generate_cement` 和 `data_generate_steelpowder` 文件夹分别使用现有文献中水泥厂和钢粉厂的模型和参数，在2022年7月PJM系统的能量价格下生成最优能源使用结果（逐小时总能耗）。这些结果被用作我们的数据集。