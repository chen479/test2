# FFT 示例
import numpy as np
import matplotlib.pyplot as plt

# 采样频率
fs = 1000
# 时间向量
n = np.arange(0, 1, 1/fs)
# 信号频率
f1 = 50
f2 = 120
# 生成信号
x = np.sin(2 * np.pi * f1 * n) + 0.5 * np.sin(2 * np.pi * f2 * n)
# 计算FFT
X = np.fft.fft(x)
# 频率向量
freq = np.fft.fftfreq(len(x), 1/fs)
# 取绝对值和前半部分（因为FFT结果是对称的）
X_abs = np.abs(X)[:len(X)//2]
freq = freq[:len(freq)//2]

# 绘制频谱
plt.figure(figsize=(10, 6))
plt.plot(freq, X_abs)
plt.title('FFT 频谱')
plt.xlabel('频率 (Hz)')
plt.ylabel('幅度')
plt.grid(True)
plt.show()
