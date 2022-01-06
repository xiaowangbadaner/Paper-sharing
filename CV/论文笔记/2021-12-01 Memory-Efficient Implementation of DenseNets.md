# Memory-Efficient Implementation of DenseNets

## Abstract

因为特性重用（feature reuse），densenet的计算效率很高，但会受到GPU内存的限制。

本文介绍了训练过程中减少内存消耗的策略，使用共享内存分配。

## introduction

从前面所有层显式的接受feature，而不是只从前一层接受。

网络深度呈现二次增长，也有二次内存依赖。

![dense](/pic/dense.jpg)

二次内存依赖的特征映射来源于每层生成的中间特征映射，是BN层和concatenation操作的输出。前向（计算下一级特征图）和反向运算（计算梯度）中都会用到。

我们观察到产生大部分内存消耗的中间特征映射的计算成本相对较低。所以引入共享内存分配，所有层都使用它来存储中间结果。后续层覆盖前一层的中间结果，但是在向后传递过程中可以以最小的代价重新填充它们的值。这样做可以将特征映射的内存消耗从二次减少到线性，而只增加了15 - 20%的额外训练时间。

## The DenseNet Architecture

Pre-activation batch normalization：在卷积前使用BN和non-linearities。

Contiguous concatenation：非连续的内存块会增加30 - 50%的计算时间开销。所以每一层必须将所有先前的特性复制到一个连续的内存块中。**在一个连续块中分配相邻的两个特性将沿着小批量维度连接，而不是预期的特性映射维度。**

## Naïve Implementation

![计算图](/pic/计算图.jpg)

-----------------------------------



# **发现目前自己看不懂这个玩意，所以告辞了**

这篇技术报告旨在改进DenseNet模型占用显存较大的问题。DenseNet是一个全新的模型，对于特征的极致利用可以提高模型的表现能力，同时由于生成大量的intermediate feature（中间特征），因此存储这些intermediate feature会占用大量的显存。为了能在GPU下跑更深的DenseNet网络，这篇文章通过对intermediate feature采用共享存储空间的方式降低了模型显存，使得在GPU显存限制下（比如单GPU的12GB显存）可以训练更深的DenseNet网络。当然这种共享部分存储的方式也引入了额外的计算时间，因为在反向传播的时候需要重新计算一些层的输出，实现表明差不多增加15%到20%的训练时间。
因为concate和normalization操作生成的特征都重新开辟了存储空间。另外在有些深度学习框架中，比如Torch，反向传播过程中生成的特征也会开辟新的存储空间。在figure3右边图中，通过提前分配的shared memory storage和指针将这些intermediate feature（concate和BN操作生成的特征）存储在temporary storage buffers中，可大大减少存储量。



简单来说：通过共享intermediate feature的存储空间减少了显存占用，但是一定程度上增加了计算时间。
