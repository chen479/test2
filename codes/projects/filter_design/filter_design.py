#!/usr/bin/env python3
# 数字滤波器设计与实现
# 项目：设计一个低通滤波器，满足给定技术指标

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# 设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

# 技术指标
fs = 8000        # 采样频率 (Hz)
fpass = 1000     # 通带截止频率 (Hz)
fstop = 2000     # 阻带截止频率 (Hz)
Rp = 1           # 通带最大衰减 (dB)
Rs = 40          # 阻带最小衰减 (dB)

print('设计IIR巴特沃斯滤波器...')
# 计算归一化频率
Wp = fpass / (fs/2)
Ws = fstop / (fs/2)

# 计算滤波器阶数和截止频率
n, Wn = signal.buttord(Wp, Ws, Rp, Rs)
print(f'巴特沃斯滤波器阶数: {n}')

# 设计滤波器
b, a = signal.butter(n, Wn, 'low')

# 计算频率响应
w, H = signal.freqz(b, a, worN=1024, fs=fs)
mag = 20 * np.log10(np.abs(H))
phase = np.angle(H)

print('\n设计FIR滤波器（窗函数法）...')
# 计算过渡带宽
DeltaF = fstop - fpass
# 估计FIR滤波器阶数（基于汉宁窗）
n_fir = int(np.ceil(6.2 * fs / DeltaF))
print(f'FIR滤波器阶数: {n_fir}')

# 设计FIR滤波器
b_fir = signal.firwin(n_fir + 1, Wp, window='hann')

# 计算频率响应
w_fir, H_fir = signal.freqz(b_fir, 1, worN=1024, fs=fs)
mag_fir = 20 * np.log10(np.abs(H_fir))
phase_fir = np.angle(H_fir)

# 绘制频率响应
plt.figure(figsize=(12, 10), dpi=100)

# 幅度响应
plt.subplot(2, 2, 1)
plt.plot(w, mag, 'b', linewidth=2, label='IIR巴特沃斯')
plt.plot(w_fir, mag_fir, 'r--', linewidth=2, label='FIR窗函数')
plt.grid(True)
plt.axis([0, fs/2, -60, 5])
plt.xlabel('频率 (Hz)')
plt.ylabel('幅度 (dB)')
plt.title('幅度响应')
plt.legend()

# 相位响应
plt.subplot(2, 2, 2)
plt.plot(w, np.unwrap(phase), 'b', linewidth=2, label='IIR巴特沃斯')
plt.plot(w_fir, np.unwrap(phase_fir), 'r--', linewidth=2, label='FIR窗函数')
plt.grid(True)
plt.xlabel('频率 (Hz)')
plt.ylabel('相位 (rad)')
plt.title('相位响应')
plt.legend()

# 生成测试信号并滤波
print('\n生成测试信号并滤波...')
# 生成包含高频噪声的信号
t = np.arange(0, 1, 1/fs)  # 1秒信号
f1 = 500           # 低频信号 (500Hz)
f2 = 3000          # 高频噪声 (3000Hz)
x = 0.7 * np.sin(2 * np.pi * f1 * t) + 0.3 * np.sin(2 * np.pi * f2 * t)

# 用IIR滤波器滤波
y_iir = signal.lfilter(b, a, x)

# 用FIR滤波器滤波
y_fir = signal.lfilter(b_fir, 1, x)

# 绘制时域信号
plt.subplot(2, 2, 3)
plt.plot(t, x, 'k', linewidth=1.5)
plt.grid(True)
plt.xlabel('时间 (s)')
plt.ylabel('幅度')
plt.title('原始信号')
plt.axis([0, 0.1, -1.5, 1.5])  # 只显示前0.1秒

plt.subplot(2, 2, 4)
plt.plot(t, y_iir, 'b', linewidth=1.5, label='IIR滤波')
plt.plot(t, y_fir, 'r--', linewidth=1.5, label='FIR滤波')
plt.grid(True)
plt.xlabel('时间 (s)')
plt.ylabel('幅度')
plt.title('滤波后信号')
plt.legend()
plt.axis([0, 0.1, -1.5, 1.5])  # 只显示前0.1秒

# 分析滤波效果
# 计算信噪比
noise_power = np.sum((x - 0.7 * np.sin(2 * np.pi * f1 * t)) ** 2)
signal_power = np.sum((0.7 * np.sin(2 * np.pi * f1 * t)) ** 2)
original_snr = 10 * np.log10(signal_power / noise_power)

noise_power_iir = np.sum((y_iir - 0.7 * np.sin(2 * np.pi * f1 * t)) ** 2)
snr_iir = 10 * np.log10(signal_power / noise_power_iir)

noise_power_fir = np.sum((y_fir - 0.7 * np.sin(2 * np.pi * f1 * t)) ** 2)
snr_fir = 10 * np.log10(signal_power / noise_power_fir)

print('\n滤波效果分析:')
print(f'原始信号信噪比: {original_snr:.2f} dB')
print(f'IIR滤波后信噪比: {snr_iir:.2f} dB')
print(f'FIR滤波后信噪比: {snr_fir:.2f} dB')

# 保存滤波器系数
print('\n保存滤波器系数...')
np.savez('filter_coefficients.npz', b=b, a=a, b_fir=b_fir)
print('滤波器系数已保存到 filter_coefficients.npz')

plt.tight_layout()
plt.savefig('filter_response.png', dpi=150, bbox_inches='tight')
print('\n滤波器响应图已保存到 filter_response.png')

print('\n滤波器设计与实现完成！')
plt.show()