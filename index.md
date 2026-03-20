---
title: Home
layout: home
nav_order: 0
---

# 数字信号处理教材知识体系

欢迎访问本教材网站！这里提供了系统化的 DSP 学习资源，涵盖从基础理论到工程应用的完整知识体系。

---

## 📚 教材章节

全套教材共分为12章，可按顺序学习，也可根据需求跳转。

| 章节 | 标题 | 内容简介 |
|:----:|:-----|:---------|
| 第1章 | [绪论](docs/chapter1-intro) | 数字信号处理的基本概念、系统组成、应用领域 |
| 第2章 | [离散时间信号与系统](docs/chapter2-discrete-signals) | 序列、基本信号、LTI系统、卷积和、差分方程 |
| 第3章 | [z变换与离散时间傅里叶变换](docs/chapter3-ztransform) | z变换、收敛域、性质、逆z变换、DTFT、频率响应 |
| 第4章 | [信号的采样与重建](docs/chapter4-sampling) | 采样定理、混叠、重建、量化误差 |
| 第5章 | [离散傅里叶变换（DFT）](docs/chapter5-dft) | DFT定义、性质、圆周卷积、频域采样、线性卷积实现 |
| 第6章 | [快速傅里叶变换（FFT）](docs/chapter6-fft) | 基-2 FFT算法（DIT/DIF）、IFFT、实序列优化 |
| 第7章 | [数字滤波器的结构](docs/chapter7-filter-structures) | 滤波器分类、IIR/FIR基本结构、流图表示 |
| 第8章 | [IIR滤波器设计](docs/chapter8-iir-filter) | 模拟原型、冲激响应不变法、双线性变换、频率转换 |
| 第9章 | [FIR滤波器设计](docs/chapter9-fir-filter) | 线性相位条件、窗函数法、频率采样法、IIR与FIR比较 |
| 第10章 | [有限字长效应](docs/chapter10-finite-word) | 数的表示、量化误差、系数量化、运算舍入误差 |
| 第11章 | [多速率信号处理](docs/chapter11-multirate) | 抽取、插值、多相结构、采样率转换、应用 |
| 第12章 | [典型应用](docs/chapter12-applications) | 语音处理、音频均衡、生物医学、雷达、与机器学习 |

> 每章末尾配有习题和实验指导，代码和实验资源可在下方链接中获取。

---

## 💻 代码示例与实验

所有代码按用途分类存放，可直接下载运行：

- [`examples/`](codes/examples/) – 课堂演示的小型代码片段（Python/MATLAB）
- [`labs/`](codes/labs/) – 各章配套实验的完整代码（含详细注释）
- [`projects/`](codes/projects/) – 综合性课程设计项目（如滤波器设计、语音降噪系统）

---

## 📎 补充资源

- [`resources/`](resources/external_resources/) – 存放参考文献、讲义PDF、外部链接等补充材料（正在完善中）

---

## 📖 如何使用本网站

- 左侧导航栏可直接跳转到任意章节，**当前章节始终高亮显示**。
- 右上角搜索框支持全文检索，输入关键词即可快速定位。
- 所有代码均可点击链接直接下载，或复制代码片段。
- 建议按顺序学习，也可根据兴趣跳转。

祝学习愉快，探索数字信号处理的精彩世界！

---

*本平台为基于 GitHub Pages + Jekyll 构建的开源教材，欢迎通过 [GitHub 仓库](https://github.com/chen479/test2) 参与贡献或反馈问题。*