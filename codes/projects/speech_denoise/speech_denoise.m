% 语音降噪系统
% 项目：设计并实现一个基于谱减法的语音降噪系统

clear all;
close all;
clc;

%% 1. 生成带噪声的语音信号
fprintf('生成带噪声的语音信号...\n');

% 生成语音信号（模拟语音）
fs = 16000;        % 采样频率 (Hz)
duration = 2;      % 信号持续时间 (s)
t = 0:1/fs:duration-1/fs;

% 生成模拟语音信号（使用多个正弦波叠加）
freqs = [200, 400, 800, 1600];  % 语音频率成分
amplitudes = [0.8, 0.6, 0.4, 0.2];  % 各频率成分的幅度

clean_speech = zeros(size(t));
for i = 1:length(freqs)
    clean_speech = clean_speech + amplitudes(i) * sin(2*pi*freqs(i)*t);
end

% 生成噪声信号（高斯白噪声）
snr = 5;  % 信噪比 (dB)
signal_power = var(clean_speech);
noise_power = signal_power / (10^(snr/10));
noise = sqrt(noise_power) * randn(size(t));

% 带噪声的语音信号
noisy_speech = clean_speech + noise;

%% 2. 谱减法降噪
fprintf('\n使用谱减法进行降噪...\n');

% 设置帧长和帧移
frame_len = 256;      % 帧长
frame_shift = 128;    % 帧移（50%重叠）
window = hann(frame_len);  % 汉宁窗

% 计算帧数
num_frames = floor((length(noisy_speech) - frame_len) / frame_shift) + 1;

% 初始化输出信号
denoised_speech = zeros(size(noisy_speech));
out_frame = zeros(frame_len, 1);

% 估计噪声谱（使用前几帧）
noise_frames = 5;  % 用于噪声估计的帧数
noise_est = zeros(frame_len/2 + 1, 1);

for i = 1:noise_frames
    frame = noisy_speech((i-1)*frame_shift+1:(i-1)*frame_shift+frame_len) .* window;
    frame_fft = fft(frame);
    noise_est = noise_est + abs(frame_fft(1:frame_len/2+1)).^2;
end
noise_est = noise_est / noise_frames;

% 谱减参数
alpha = 1.0;  % 谱减因子
beta = 0.001;  % 谱减下限（避免静音段过度降噪）

% 逐帧处理
for i = 1:num_frames
    % 提取当前帧
    frame = noisy_speech((i-1)*frame_shift+1:(i-1)*frame_shift+frame_len) .* window;
    
    % 计算FFT
    frame_fft = fft(frame);
    mag = abs(frame_fft);
    phase = angle(frame_fft);
    
    % 计算功率谱
    power_spec = mag.^2;
    
    % 谱减法
    denoised_power = max(power_spec(1:frame_len/2+1) - alpha*noise_est, beta*noise_est);
    
    % 重建信号
    denoised_mag = [sqrt(denoised_power); sqrt(denoised_power(end-1:-1:2))];
    denoised_fft = denoised_mag .* exp(1i*phase);
    
    % 逆FFT
    out_frame = real(ifft(denoised_fft));
    
    % 重叠相加
    denoised_speech((i-1)*frame_shift+1:(i-1)*frame_shift+frame_len) = ...
        denoised_speech((i-1)*frame_shift+1:(i-1)*frame_shift+frame_len) + out_frame;
end

%% 3. 维纳滤波器降噪
fprintf('\n使用维纳滤波器进行降噪...\n');

% 初始化维纳滤波输出
wiener_denoised = zeros(size(noisy_speech));

% 维纳滤波器参数
gamma = 1e-6;  % 正则化参数

% 逐帧处理
for i = 1:num_frames
    % 提取当前帧
    frame = noisy_speech((i-1)*frame_shift+1:(i-1)*frame_shift+frame_len) .* window;
    
    % 计算FFT
    frame_fft = fft(frame);
    mag = abs(frame_fft);
    phase = angle(frame_fft);
    
    % 计算功率谱
    power_spec = mag.^2;
    
    % 维纳滤波器
    wiener_filter = max(1 - noise_est ./ (power_spec(1:frame_len/2+1) + gamma), 0);
    
    % 应用滤波器
    denoised_mag = [sqrt(power_spec(1:frame_len/2+1) .* wiener_filter); ...
                   sqrt(power_spec(frame_len/2+2:end) .* wiener_filter(end-1:-1:2))];
    denoised_fft = denoised_mag .* exp(1i*phase);
    
    % 逆FFT
    out_frame = real(ifft(denoised_fft));
    
    % 重叠相加
    wiener_denoised((i-1)*frame_shift+1:(i-1)*frame_shift+frame_len) = ...
        wiener_denoised((i-1)*frame_shift+1:(i-1)*frame_shift+frame_len) + out_frame;
end

%% 4. 计算信噪比
fprintf('\n计算降噪效果...\n');

% 计算原始信噪比
original_snr = 10*log10(var(clean_speech)/var(noise));

% 计算谱减法降噪后的信噪比
spectral_subtraction_snr = 10*log10(var(clean_speech)/var(clean_speech - denoised_speech));

% 计算维纳滤波器降噪后的信噪比
wiener_snr = 10*log10(var(clean_speech)/var(clean_speech - wiener_denoised));

fprintf('原始信噪比: %.2f dB\n', original_snr);
fprintf('谱减法降噪后信噪比: %.2f dB\n', spectral_subtraction_snr);
fprintf('维纳滤波器降噪后信噪比: %.2f dB\n', wiener_snr);

%% 5. 绘制结果
fprintf('\n绘制结果...\n');

% 时域信号
figure('Name', '语音降噪效果 - 时域');
subplot(3, 1, 1);
plot(t, clean_speech, 'LineWidth', 1.5);
grid on;
xlabel('时间 (s)');
ylabel('幅度');
title('原始语音信号');
axis([0 0.1 -2 2]);  % 只显示前0.1秒

subplot(3, 1, 2);
plot(t, noisy_speech, 'LineWidth', 1.5);
grid on;
xlabel('时间 (s)');
ylabel('幅度');
title('带噪声的语音信号');
axis([0 0.1 -2 2]);  % 只显示前0.1秒

subplot(3, 1, 3);
plot(t, denoised_speech, 'b', 'LineWidth', 1.5, 'DisplayName', '谱减法');
hold on;
plot(t, wiener_denoised, 'r--', 'LineWidth', 1.5, 'DisplayName', '维纳滤波');
hold off;
grid on;
xlabel('时间 (s)');
ylabel('幅度');
title('降噪后的语音信号');
legend('Location', 'best');
axis([0 0.1 -2 2]);  % 只显示前0.1秒

% 频域分析
nfft = 1024;
clean_fft = fft(clean_speech, nfft);
noisy_fft = fft(noisy_speech, nfft);
denoised_fft = fft(denoised_speech, nfft);
wiener_fft = fft(wiener_denoised, nfft);

freq = (0:nfft/2-1)*fs/nfft;

figure('Name', '语音降噪效果 - 频域');
subplot(3, 1, 1);
plot(freq, 20*log10(abs(clean_fft(1:nfft/2))), 'LineWidth', 1.5);
grid on;
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
title('原始语音信号频谱');
axis([0 4000 -60 40]);

subplot(3, 1, 2);
plot(freq, 20*log10(abs(noisy_fft(1:nfft/2))), 'LineWidth', 1.5);
grid on;
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
title('带噪声的语音信号频谱');
axis([0 4000 -60 40]);

subplot(3, 1, 3);
plot(freq, 20*log10(abs(denoised_fft(1:nfft/2))), 'b', 'LineWidth', 1.5, 'DisplayName', '谱减法');
hold on;
plot(freq, 20*log10(abs(wiener_fft(1:nfft/2))), 'r--', 'LineWidth', 1.5, 'DisplayName', '维纳滤波');
hold off;
grid on;
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
title('降噪后的语音信号频谱');
legend('Location', 'best');
axis([0 4000 -60 40]);

%% 6. 保存结果
fprintf('\n保存结果...\n');
save('speech_denoise_results.mat', 'clean_speech', 'noisy_speech', 'denoised_speech', 'wiener_denoised', 'fs');
fprintf('结果已保存到 speech_denoise_results.mat\n');

fprintf('\n语音降噪系统设计完成！\n');