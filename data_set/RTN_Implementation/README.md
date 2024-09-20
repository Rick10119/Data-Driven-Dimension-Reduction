# Dataset Generation Method using RTN Model

## Introduction
This repository contains MATLAB code implementation of the Resource-Task Network (RTN). Variable definitions can be found in `add_param_and_var`, while the main program, including RTN modeling of industrial pipeline constraints, objective functions, and solving codes, is in `main_basic_rtn`. The dataset is generated using the existing literature's model and parameters for a steelmaking plant, optimizing energy consumption under the PJM system energy prices in July 2022 (hourly total energy consumption). This optimized energy consumption result is used as the dataset.

## Details
The RTN model and parameters for the steel plant are primarily derived from the paper by Zhang et al. ("Cost-Effective Scheduling of Steel Plants With Flexible EAFs," IEEE Trans. Smart Grid, vol. 8, no. 1, pp. 239–249, Jan. 2017). However, if you attempt to reproduce it, you will find that the original model has many omissions, including handling constraints corresponding to ending time slots. During my replication process, I encountered numerous challenges, some of which took a considerable amount of time to resolve.

If you have any questions or would like to contribute to improving the code, feel free to raise issues or submit PRs. Thank you for your interest and support!

# 使用RTN模型生成数据集方法

## 简介
该项目包含资源-任务网络（RTN）的MATLAB代码实现。变量定义在 `add_param_and_var` 中，主程序（包括RTN建模的工业流水线约束、目标函数、求解代码）在 `main_basic_rtn` 中，`generate_steelmaking_data` 用现有文献中造铁厂的模型和参数生成在2022年7月的PJM系统能量价格下最优用能结果（逐小时总用能）。这个优化后的用能结果被用作数据集。

## 详情
RTN模型和铁厂的参数主要来自于张等人的论文（X. Zhang, G. Hug, and I. Harjunkoski, “Cost-Effective Scheduling of Steel Plants With Flexible EAFs,” IEEE Trans. Smart Grid, vol. 8, no. 1, pp. 239–249, Jan. 2017）。然而，如果你尝试自己复现，就会发现原文中的模型有很多省略，包括对于ending time slot对应约束的处理等。在我复现的过程中，遇到了许多问题，有些花了不少时间才解决。

如果您有任何问题或想要为改进代码做出贡献，请随时提出问题或提交PR。感谢您的关注和支持！