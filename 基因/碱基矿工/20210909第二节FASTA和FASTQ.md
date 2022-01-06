# 第二节 FASTA和FASTQ

这是我们存储核苷酸序列信息（就是DNA序列）或者蛋白质序列信息最常使用的两种**文本文件**，虽然看起来名字有些古怪，但它们完全是纯文本文件。

## FASTA

FASTA作为存储**有顺序的**序列数据的文件后缀，也常用.fa或者.fa.gz（gz压缩）。

FASTA文件主要由两个部分构成：**序列头信息（有时包括一些其它的描述信息）和具体的序列数据**。**头信息独占一行，以大于号（>）开头作为识别标记**，其中除了记录该条序列的名字之外，有时候还会接上其它的信息。紧接的下一行是具体的序列内容，直到另一行碰到另一个大于号（>）开头的新序列或者文件末尾。
```
>ENSMUSG00000020122|ENSMUST00000138518
CCCTCCTATCATGCTGTCAGTGTATCTCTAAATAGCACTCTCAACCCCCGTGAACTTGGT
TATTAAAAACATGCCCAAAGTCTGGGAGCCAGGGCTGCAGGGAAATACCACAGCCTCAGT
TCATCAAAACAGTTCATTGCCCAAAATGTTCTCAGCTGCAGCTTTCATGAGGTAACTCCA
GGGCCCACCTGTTCTCTGGT
>ENSMUSG00000020122|ENSMUST00000125984
GAGTCAGGTTGAAGCTGCCCTGAACACTACAGAGAAGAGAGGCCTTGGTGTCCTGTTGTC
TCCAGAACCCCAATATGTCTTGTGAAGGGCACACAACCCCTCAAAGGGGTGTCACTTCTT
CTGATCACTTTTGTTACTGTTTACTAACTGATCCTATGAATCACTGTGTCTTCTCAGAGG
CCGTGAACCACGTCTGCAAT
```

**第一，除了序列内容之外，FASTA的头信息并没有被严格地限制**。

**用一个空格把头信息分为两个部分：第一部分是序列名字，它和大于号（>）紧接在一起；第二部分是注释信息，这个可以没有，就看具体需要，**比如下面这个序列例子，除了前面gene_00284728这个名字之外，注释信息（length=231;type=dna）给出这段序列的长度和它所属的序列类型。

```
>gene_00284728 length=231;type=dna
GAGAACTGATTCTGTTACCGCAGGGCATTCGGATGTGCTAAGGTAGTAATCCATTATAAGTAACATG
CGCGGAATATCCGGGAGGTCATAGTCGTAATGCATAATTATTCCCTCCCTCAGAAGGACTCCCTTGC
GAGACGCCAATACCAAAGACTTTCGTAAGCTGGAACGATTGGACGGCCCAACCGGGGGGAGTCGGCT
ATACGTCTGATTGCTACGCCTGGACTTCTCTT
```

**第二，FASTA由于是文本文件，它里面的内容是否有重复是无法自检的，在使用之前需要我们进行额外的检查。**

## FASTQ

FASTA文件，所存的都是已经排列好的序列（如参考序列），FASTQ存的则是产生自测序仪的原始测序数据，它由测序的图像数据转换过来，也是文本文件。文件后缀通常都是.fastq，.fq或者.fq.gz（gz压缩）。

```
@DJB775P1:248:D0MDGACXX:7:1202:12362:49613
TGCTTACTCTGCGTTGATACCACTGCTTAGATCGGAAGAGCACACGTCTGAA
+
JJJJJIIJJJJJJHIHHHGHFFFFFFCEEEEEDBD?DDDDDDBDDDABDDCA
@DJB775P1:248:D0MDGACXX:7:1202:12782:49716
CTCTGCGTTGATACCACTGCTTACTCTGCGTTGATACCACTGCTTAGATCGG
+
IIIIIIIIIIIIIIIHHHHHHFFFFFFEECCCCBCECCCCCCCCCCCCCCCC
```

**每四行成为一个独立的单元，我们称之为read**。

- 第一行：以‘@’开头，是这一条read的名字，这个字符串是根据测序时的状态信息转换过来的，中间不会有空格，它是**每一条read的唯一标识符**，同一份FASTQ文件中不会重复出现，甚至不同的FASTQ文件里也不会有重复； 

- 第二行：测序read的序列，由A，C，G，T和N这五种字母构成，这也是我们真正关心的DNA序列，N代表的是测序时那些无法被识别出来的碱基；

- 第三行：以‘+’开头，在旧版的FASTQ文件中会直接重复第一行的信息，但现在一般什么也不加（节省存储空间）；

- 第四行：测序read的质量值，这个和第二行的碱基信息一样重要，它描述的是每个测序碱基的可靠程度，用ASCII码表示。

  这里我们假定碱基的测序错误率为p_error，质量值为Q，它们之间的关系如下：

  ``` 
  Q = -10log(p_error)
  ```

  p_error的值和测序时的多个因素有关，体现为测序图像数据点的清晰程度，并由测序过程中的base calling 算法计算出来。

  Q我们称之为Phred quality score，就是用它来描述测序碱基的靠谱程度。

  红线代表错误率，蓝线代表质量值，这便是我们希望达到的效果：

  ![a71be6ee0a154de85831b987e8d3840](pic\a71be6ee0a154de85831b987e8d3840.png)

  质量值高低的含义：

  ![a71be6ee0a154de85831b987e8d3840](pic\9fec3052f77a81c14840eed26629f68.png)

  **为了能够让碱基的质量值表达出来，必须避开所有这些不可见字符**。最简单的做法就是加上一个固定的整数

![c8c5e18d8afd4294e714dba63208f08](\pic\c8c5e18d8afd4294e714dba63208f08.png)







