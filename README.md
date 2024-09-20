### README

Welcome to the Data-Driven-Dimension-Reduction code repository!

#### Data Set (data_set)

In this folder, we provide simulation data of cement plants and steel powder plants modeled using State Task Networks (STN), as well as simulation data of steel plants modeled using Resource Task Networks (RTN). Each model comes with detailed explanations. These datasets are used to train the ALF model.

#### Results (results)

This folder contains relevant data results obtained using the data from the data_set folder using my method.

#### Visualization (visualization)

In this folder, we analyze and visualize the results.

#### Main Folder Codes

1. **main_training**: Train the ALF model on three different datasets.
2. **model_training**: A program based on iterative algorithms for training ALF models.
3. **add_varDef_and_initVal**: Setting up variables for inverse optimization, this program needs to be separated from constraint construction, so that different constraints can be built repeatedly.
4. **inverse_optimization**: Fitting ALF model parameters on the grid side based on electricity meter data.
5. **primal_problem**: Solve the original problem to find the optimal energy consumption based on ALF.
6. **test_reduced_constraints_ALF**: Calculate the optimal energy consumption results on the test set using the identified parameters for the ALF model.
7. **test_reduced_constraints_SLF**: Calculate the optimal energy consumption results on the test set using a simple model (SAL).

Thank you for visiting our code repository! Feel free to reach out to us with any questions or suggestions.

### README (中文版)

欢迎来到 Data-Driven-Dimension-Reduction 代码库！

#### 数据集 (data_set)

在这个文件夹中，我们提供了使用状态任务网络（STN）建模的水泥厂和钢粉厂，以及使用资源任务网络（RTN）建模的钢铁厂的仿真数据。每个模型都有详细的说明。这些数据集被用来训练ALF模型。

#### 结果 (results)

这个文件夹包含了利用 data_set 数据集，通过我的方法得出的相关数据结果。

#### 可视化 (visualization)

在这个文件夹中，我们对结果进行了分析和可视化。

#### 主文件夹代码

1. **main_training**：在三个不同数据集上训练ALF模型。
2. **model_training**：一个基于迭代算法的程序，用于训练ALF模型。
3. **add_varDef_and_initVal**：设置逆向优化的变量，这个程序需要和约束的构建分开，以便可以重复构建不同的约束。
4. **inverse_optimization**：根据电表数据拟合ALF模型参数。
5. **primal_problem**：解决原始问题，以找到基于ALF的最优能耗。
6. **test_reduced_constraints_ALF**：使用识别出的ALF模型参数计算测试集上的最优能耗结果。
7. **test_reduced_constraints_SLF**：使用简单模型（SAL）计算测试集上的最优能耗结果。

感谢您访问我们的代码库！如有任何疑问或建议，请随时联系我们。

---

