# cnnCNV: A Sensitive and Efficient Method for Detecting Copy Number Variation based on Convolutional Neural Networks（CnnCNV：一种基于卷积神经网络的灵敏高效的拷贝数V变异检测方法）
## Abstract

提高下一代测序分析技术(NGS)数据中发现拷贝数变异(CNV)的效率成为一种需求。单个方法不足以发现所有潜在的CNV。

首先，cnnCNV合并现有CNV调用工具的输出作为候选；其次，基于多个检测理论对齐的读数生成每个候选区域的图像；最后，使用训练好的模型对候选区域进行真假分类。

## introduction

拷贝数变异(CNV)是人类基因组中一种复杂的结构变异现象，也是一种重要的结构变异类型。CNV指的是一种拷贝数异常变化的结构变异，涉及较长的DNA片段，并导致基因组的获得、丢失或其他重排。

有四种检测结构变异(SV)的指导策略：

（1）成对末端(paired-end，PE)映射：插入大小异常的读取对可能指的是序列增减。

（2） 拆分读取（split-read，SR）映射：当映射到参考基因组时，读取跨越SV get split的断点。SR分析可以找到SV的精确断点。

（3） 读取深度（read-depth，RD）分析：覆盖深度异常的区域意味着SV不平衡。

（4）本地组件（local assembly）：汇编读取以形成较长的一致序列，然后将它们重新映射到参考基因组。

## method

