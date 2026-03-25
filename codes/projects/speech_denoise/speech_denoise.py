#!/usr/bin/env python3
# 语音降噪系统
# 项目：设计并实现一个基于谱减法的语音降噪系统

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# 设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

print('生成带噪声的语音信号...')

# 生成语音信号（模拟语音）
fs = 16000        # 采样频率 (Hz)
duration = 2      # 信号持续时间 (s)
t = np.arange(0, duration, 1/fs)

# 生成模拟语音信号（使用多个正弦波叠加）
freqs = [200, 400, 800, 1600]  # 语音频率成分
amplitudes = [0.8, 0.6, 0.4, 0.2]  # 各频率成分的幅度

clean_speech = np.zeros_like(t)
for i in range(len(freqs)):
    clean_speech += amplitudes[i] * np.sin(2 * np.pi * freqs[i] * t)

# 生成噪声信号（高斯白噪声）
snr = 5  # 信噪比 (dB)
signal_power = np.var(clean_speech)
noise_power = signal_power / (10 ** (snr / 10))
noise = np.sqrt(noise_power) * np.random.randn(len(t))

# 带噪声的语音信号
noisy_speech = clean_speech + noise

print('\n使用谱减法进行降噪...')

# 设置帧长和帧移
frame_len = 256      # 帧长
frame_shift = 128    # 帧移（50%重叠）
window = np.hanning(frame_len)  # 汉宁窗

# 计算帧数
num_frames = int(np.floor((len(noisy_speech) - frame_len) / frame_shift)) + 1

# 初始化输出信号
denoised_speech = np.zeros_like(noisy_speech)

# 估计噪声谱（使用前几帧）
noise_frames = 5  # 用于噪声估计的帧数
noise_est = np.zeros(frame_len // 2 + 1)

for i in range(noise_frames):
    frame = noisy_speech[i*frame_shift:i*frame_shift+frame_len] * window
    frame_fft = np.fft.fft(frame)
    noise_est += np.abs(frame_fft[:frame_len//2+1]) ** 2
noise_est /= noise_frames

# 谱减参数
alpha = 1.0  # 谱减因子
beta = 0.001  # 谱减下限（避免静音段过度降噪）

# 逐帧处理
for i in range(num_frames):
    # 提取当前帧
    start = i * frame_shift
    end = start + frame_len
    frame = noisy_speech[start:end] * window
    
    # 计算FFT
    frame_fft = np.fft.fft(frame)
    mag = np.abs(frame_fft)
    phase = np.angle(frame_fft)
    
    # 计算功率谱
    power_spec = mag ** 2
    
    # 谱减法
    denoised_power = np.maximum(power_spec[:frame_len//2+1] - alpha*noise_est, beta*noise_est)
    
    # 重建信号
    denoised_mag = np.concatenate([np.sqrt(denoised_power), np.sqrt(denoised_power[-2:0:-1])])
    denoised_fft = denoised_mag * np.exp(1j * phase)
    
    # 逆FFT
    out_frame = np.real(np.fft.ifft(denoised_fft))
    
    # 重叠相加
    denoised_speech[start:end] += out_frame

print('\n使用维纳滤波器进行降噪...')

# 初始化维纳滤波输出
wiener_denoised = np.zeros_like(noisy_speech)

# 维纳滤波器参数
gamma = 1e-6  # 正则化参数

# 逐帧处理
for i in range(num_frames):
    # 提取当前帧
    start = i * frame_shift
    end = start + frame_len
    frame = noisy_speech[start:end] * window
    
    # 计算FFT
    frame_fft = np.fft.fft(frame)
    mag = np.abs(frame_fft)
    phase = np.angle(frame_fft)
    
    # 计算功率谱
    power_spec = mag ** 2
    
    # 维纳滤波器
    wiener_filter = np.maximum(1 - noise_est / (power_spec[:frame_len//2+1] + gamma), 0)
    
    # 应用滤波器
    denoised_mag = np.sqrt(power_spec[:frame_len//2+1] * wiener_filter)
    denoised_mag = np.concatenate([denoised_mag, denoised_mag[-2:0:-1]])
    denoised_fft = denoised_mag * np.exp(1j * phase)
    
    # 逆FFT
    out_frame = np.real(np.fft.ifft(denoised_fft))
    
    # 重叠相加
    wiener_denoised[start:end] += out_frame

print('\n计算降噪效果...')

# 计算原始信噪比
original_snr = 10 * np.log10(np.var(clean_speech) / np.var(noise))

# 计算谱减法降噪后的信噪比
spectral_subtraction_snr = 10 * np.log10(np.var(clean_speech) / np.var(clean_speech - denoised_speech))

# 计算维纳滤波器降噪后的信噪比
wiener_snr = 10 * np.log10(np.var(clean_speech) / np.var(clean_speech - wiener_denoised))

print(f'原始信噪比: {original_snr:.2f} dB')
print(f'谱减法降噪后信噪比: {spectral_subtraction_snr:.2f} dB')
print(f'维纳滤波器降噪后信噪比: {wiener_snr:.2f} dB')

print('\n绘制结果...')

# 时域信号
plt.figure(figsize=(12, 10), dpi=100)
plt.subplot(3, 1, 1)
plt.plot(t, clean_speech, linewidth=1.5)
plt.grid(True)
plt.xlabel('时间 (s)')
plt.ylabel('幅度')
plt.title('原始语音信号')
plt.axis([0, 0.1, -2, 2])  # 只显示前0.1秒

plt.subplot(3, 1, 2)
plt.plot(t, noisy_speech, linewidth=1.5)
plt.grid(True)
plt.xlabel('时间 (s)')
plt.ylabel('幅度')
plt.title('带噪声的语音信号')
plt.axis([0, 0.1, -2, 2])  # 只显示前0.1秒

plt.subplot(3, 1, 3)
plt.plot(t, denoised_speech, 'b', linewidth=1.5, label='谱减法')
plt.plot(t, wiener_denoised, 'r--', linewidth=1.5, label='维纳滤波')
plt.grid(True)
plt.xlabel('时间 (s)')
plt.ylabel('幅度')
plt.title('降噪后的语音信号')
plt.legend(loc='best')
plt.axis([0, 0.1, -2, 2])  # 只显示前0.1秒

# 频域分析
nfft = 1024
clean_fft = np.fft.fft(clean_speech, nfft)
noisy_fft = np.fft.fft(noisy_speech, nfft)
denoised_fft = np.fft.fft(denoised_speech, nfft)
wiener_fft = np.fft.fft(wiener_denoised, nfft)

freq = np.arange(0, nfft//2) * fs / nfft

plt.figure(figsize=(12, 10), dpi=100)
plt.subplot(3, 1, 1)
plt.plot(freq, 20 * np.log10(np.abs(clean_fft[:nfft//2])), linewidth=1.5)
plt.grid(True)
plt.xlabel('频率 (Hz)')
plt.ylabel('幅度 (dB)')
plt.title('原始语音信号频谱')
plt.axis([0, 4000, -60, 40])

plt.subplot(3, 1, 2)
plt.plot(freq, 20 * np.log10(np.abs(noisy_fft[:nfft//2])), linewidth=1.5)
plt.grid(True)
plt.xlabel('频率 (Hz)')
plt.ylabel('幅度 (dB)')
plt.title('带噪声的语音信号频谱')
plt.axis([0, 4000, -60, 40])

plt.subplot(3, 1, 3)
plt.plot(freq, 20 * np.log10(np.abs(denoised_fft[:nfft//2])), 'b', linewidth=1.5, label='谱减法')
plt.plot(freq, 20 * np.log10(np.abs(wiener_fft[:nfft//2])), 'r--', linewidth=1.5, label='维纳滤波')
plt.grid(True)
plt.xlabel('频率 (Hz)')
plt.ylabel('幅度 (dB)')
plt.title('降噪后的语音信号频谱')
plt.legend(loc='best')
plt.axis([0, 4000, -60, 40])

# 保存结果
print('\n保存结果...')
np.savez('speech_denoise_results.npz', 
         clean_speech=clean_speech, 
         noisy_speech=noisy_speech, 
         denoised_speech=denoised_speech, 
         wiener_denoised=wiener_denoised, 
         fs=fs)
print('结果已保存到 speech_denoise_results.npz')

plt.tight_layout()
plt.savefig('speech_denoise_results.png', dpi=150, bbox_inches='tight')
print('\n结果图已保存到 speech_denoise_results.png')

print('\n语音降噪系统设计完成！')
plt.show()