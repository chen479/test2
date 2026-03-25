% 数字滤波器设计与实现
% 项目：设计一个低通滤波器，满足给定技术指标

clear all;
close all;
clc;

%% 技术指标
fs = 8000;        % 采样频率 (Hz)
fpass = 1000;     % 通带截止频率 (Hz)
fstop = 2000;     % 阻带截止频率 (Hz)
Rp = 1;           % 通带最大衰减 (dB)
Rs = 40;          % 阻带最小衰减 (dB)

%% 1. 设计IIR滤波器（巴特沃斯）
fprintf('设计IIR巴特沃斯滤波器...\n');
% 计算归一化频率
Wp = fpass / (fs/2);
Ws = fstop / (fs/2);

% 计算滤波器阶数和截止频率
[n, Wn] = buttord(Wp, Ws, Rp, Rs);
fprintf('巴特沃斯滤波器阶数: %d\n', n);

% 设计滤波器
[b, a] = butter(n, Wn, 'low');

% 计算频率响应
[H, w] = freqz(b, a, 1024, fs);
mag = 20*log10(abs(H));
phase = angle(H);

%% 2. 设计FIR滤波器（窗函数法）
fprintf('\n设计FIR滤波器（窗函数法）...\n');
% 计算过渡带宽
DeltaF = fstop - fpass;
% 估计FIR滤波器阶数（基于汉宁窗）
n_fir = ceil(6.2*fs/DeltaF);
fprintf('FIR滤波器阶数: %d\n', n_fir);

% 设计FIR滤波器
b_fir = fir1(n_fir, Wp, 'low', hann(n_fir+1));

% 计算频率响应
[H_fir, w_fir] = freqz(b_fir, 1, 1024, fs);
mag_fir = 20*log10(abs(H_fir));
phase_fir = angle(H_fir);

%% 3. 绘制频率响应
figure('Name', '滤波器频率响应');

% 幅度响应
subplot(2, 2, 1);
plot(w, mag, 'b', 'LineWidth', 2);
hold on;
plot(w_fir, mag_fir, 'r--', 'LineWidth', 2);
hold off;
grid on;
axis([0 fs/2 -60 5]);
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
title('幅度响应');
legend('IIR巴特沃斯', 'FIR窗函数');

% 相位响应
subplot(2, 2, 2);
plot(w, unwrap(phase), 'b', 'LineWidth', 2);
hold on;
plot(w_fir, unwrap(phase_fir), 'r--', 'LineWidth', 2);
hold off;
grid on;
xlabel('频率 (Hz)');
ylabel('相位 (rad)');
title('相位响应');
legend('IIR巴特沃斯', 'FIR窗函数');

%% 4. 生成测试信号并滤波
fprintf('\n生成测试信号并滤波...\n');
% 生成包含高频噪声的信号
t = 0:1/fs:1-1/fs;  % 1秒信号
f1 = 500;           % 低频信号 (500Hz)
f2 = 3000;          % 高频噪声 (3000Hz)
x = 0.7*sin(2*pi*f1*t) + 0.3*sin(2*pi*f2*t);

% 用IIR滤波器滤波
y_iir = filter(b, a, x);

% 用FIR滤波器滤波
y_fir = filter(b_fir, 1, x);

%% 5. 绘制时域信号
subplot(2, 2, 3);
plot(t, x, 'k', 'LineWidth', 1.5);
grid on;
xlabel('时间 (s)');
ylabel('幅度');
title('原始信号');
axis([0 0.1 -1.5 1.5]);  % 只显示前0.1秒

subplot(2, 2, 4);
plot(t, y_iir, 'b', 'LineWidth', 1.5);
hold on;
plot(t, y_fir, 'r--', 'LineWidth', 1.5);
hold off;
grid on;
xlabel('时间 (s)');
ylabel('幅度');
title('滤波后信号');
legend('IIR滤波', 'FIR滤波');
axis([0 0.1 -1.5 1.5]);  % 只显示前0.1秒

%% 6. 分析滤波效果
% 计算信噪比
noise_power = sum((x - 0.7*sin(2*pi*f1*t)).^2);
signal_power = sum((0.7*sin(2*pi*f1*t)).^2);
original_snr = 10*log10(signal_power/noise_power);

noise_power_iir = sum((y_iir - 0.7*sin(2*pi*f1*t)).^2);
snr_iir = 10*log10(signal_power/noise_power_iir);

noise_power_fir = sum((y_fir - 0.7*sin(2*pi*f1*t)).^2);
snr_fir = 10*log10(signal_power/noise_power_fir);

fprintf('\n滤波效果分析:\n');
fprintf('原始信号信噪比: %.2f dB\n', original_snr);
fprintf('IIR滤波后信噪比: %.2f dB\n', snr_iir);
fprintf('FIR滤波后信噪比: %.2f dB\n', snr_fir);

%% 7. 保存滤波器系数
fprintf('\n保存滤波器系数...\n');
save('filter_coefficients.mat', 'b', 'a', 'b_fir');
fprintf('滤波器系数已保存到 filter_coefficients.mat\n');

fprintf('\n滤波器设计与实现完成！\n');