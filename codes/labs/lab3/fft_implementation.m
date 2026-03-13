% fft_implementation.m
% 实验3：手动实现基-2 FFT算法（蝶形运算），并与MATLAB内置fft对比

clear; clc; close all;

%% 生成测试信号
N = 8;                      % 点数（必须为2的幂）
fs = 100;                   % 采样频率
t = (0:N-1)/fs;
f1 = 10; f2 = 25;
x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);  % 两个频率分量

disp('原始信号 x =');
disp(x);

%% 手动实现基-2 DIT-FFT（按时间抽取）
X_manual = my_fft(x);
disp('手动FFT结果 =');
disp(X_manual);

%% MATLAB内置FFT验证
X_builtin = fft(x);
disp('MATLAB fft 结果 =');
disp(X_builtin);

%% 计算误差
error = max(abs(X_manual - X_builtin));
fprintf('最大误差 = %e\n', error);
if error < 1e-10
    disp('✅ 结果一致，FFT实现正确！');
else
    disp('❌ 误差较大，请检查代码。');
end

%% 绘制频谱
freq = (0:N-1)*fs/N;
figure;
subplot(2,1,1);
stem(freq, abs(X_manual), 'filled');
title('手动FFT幅度谱');
xlabel('频率 (Hz)'); ylabel('|X|');
subplot(2,1,2);
stem(freq, abs(X_builtin), 'filled');
title('MATLAB FFT幅度谱');
xlabel('频率 (Hz)'); ylabel('|X|');

%% 自定义FFT函数（蝶形算法）
function X = my_fft(x)
    N = length(x);
    if N == 1
        X = x;
        return;
    end
    % 奇偶分离
    x_even = x(1:2:end);
    x_odd  = x(2:2:end);
    % 递归计算
    X_even = my_fft(x_even);
    X_odd  = my_fft(x_odd);
    % 蝶形合并
    X = zeros(1, N);
    for k = 0:(N/2 - 1)
        twiddle = exp(-2j * pi * k / N);
        X(k+1)        = X_even(k+1) + twiddle * X_odd(k+1);
        X(k+1 + N/2)  = X_even(k+1) - twiddle * X_odd(k+1);
    end
end