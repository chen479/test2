import numpy as np
import matplotlib.pyplot as plt

# 生成正弦波
fs = 1000          # 采样频率
t = np.arange(0, 1, 1/fs)
f = 5              # 信号频率 5Hz
x = np.sin(2 * np.pi * f * t)

plt.plot(t, x)
plt.title('5Hz 正弦波')
plt.xlabel('时间 (s)')
plt.grid()
plt.show()