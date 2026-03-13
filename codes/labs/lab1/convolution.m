% convolution.m
% 实验1：离散时间卷积的计算
% 功能：手动实现卷积运算，并与MATLAB内置conv函数对比验证

clear; clc; close all;

% 定义两个有限长序列
x = [1, 2, 3, 4];      % 输入序列 x[n]
h = [1, 1, 1];         % 单位脉冲响应 h[n]

% 手动实现卷积 y[n] = sum_{k} x[k] * h[n-k]
Nx = length(x);
Nh = length(h);
Ny = Nx + Nh - 1;       % 卷积结果长度
y_manual = zeros(1, Ny);

for n = 1:Ny
    sum = 0;
    for k = 1:Nx
        % 检查 h[n-k] 是否在有效范围内
        if (n-k+1 >= 1) && (n-k+1 <= Nh)
            sum = sum + x(k) * h(n-k+1);
        end
    end
    y_manual(n) = sum;
end

% 使用MATLAB内置conv函数验证
y_builtin = conv(x, h);

% 显示结果
disp('手动计算卷积结果:');
disp(y_manual);
disp('MATLAB conv 结果:');
disp(y_builtin);

% 绘图对比
figure;
subplot(3,1,1);
stem(0:Nx-1, x, 'filled');
title('输入序列 x[n]');
xlabel('n'); ylabel('x[n]');

subplot(3,1,2);
stem(0:Nh-1, h, 'filled');
title('单位脉冲响应 h[n]');
xlabel('n'); ylabel('h[n]');

subplot(3,1,3);
stem(0:Ny-1, y_manual, 'filled');
hold on;
stem(0:Ny-1, y_builtin, 'rx', 'LineWidth', 1.5);
title('卷积结果 y[n]');
xlabel('n'); ylabel('y[n]');
legend('手动实现', 'conv函数');

% 验证一致性
if isequal(y_manual, y_builtin)
    disp('✅ 结果一致，卷积实现正确！');
else
    disp('❌ 结果不一致，请检查代码。');
end