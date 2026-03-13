% ztransform_properties.m
% 实验2：使用MATLAB符号工具箱验证Z变换的线性、时移和微分性质

clear; clc; close all;

syms n z
assume(n, 'integer');
assumeAlso(n >= 0);   % 因果序列

% 定义两个因果序列
x = 0.5^n;            % x[n] = (0.5)^n
y = (-0.8)^n;         % y[n] = (-0.8)^n

% 计算Z变换
X = ztrans(x, n, z);
Y = ztrans(y, n, z);
disp('X(z) ='); disp(simplify(X));
disp('Y(z) ='); disp(simplify(Y));

%% 1. 线性性质验证
a = 2; b = 3;
lin_manual = a*X + b*Y;
lin_ztrans = ztrans(a*x + b*y, n, z);
lin_ztrans = simplify(lin_ztrans);

disp('=== 线性性质 ===');
disp('aX + bY ='); disp(lin_manual);
disp('Z{a x + b y} ='); disp(lin_ztrans);
if isequal(lin_manual, lin_ztrans)
    disp('✅ 线性性质成立');
else
    disp('❌ 线性性质不成立');
end

%% 2. 时移性质验证（右移1）
x_shift = subs(x, n, n-1) * heaviside(n-1);  % 确保 n<0 时为0
shift_manual = z^(-1) * X;
shift_ztrans = ztrans(x_shift, n, z);
shift_ztrans = simplify(shift_ztrans);

disp('=== 时移性质 ===');
disp('z^{-1}X(z) ='); disp(shift_manual);
disp('Z{x[n-1]} ='); disp(shift_ztrans);
if isequal(shift_manual, shift_ztrans)
    disp('✅ 时移性质成立');
else
    disp('❌ 时移性质不成立');
end

%% 3. 微分性质验证（n * x[n]）
% 微分性质：Z{n x[n]} = -z * d/dz X(z)
diff_manual = -z * diff(X, z);
diff_seq = n * x;
diff_ztrans = ztrans(diff_seq, n, z);
diff_ztrans = simplify(diff_ztrans);
diff_manual = simplify(diff_manual);

disp('=== 微分性质 ===');
disp('-z * dX/dz ='); disp(diff_manual);
disp('Z{n x[n]} ='); disp(diff_ztrans);
if isequal(diff_manual, diff_ztrans)
    disp('✅ 微分性质成立');
else
    disp('❌ 微分性质不成立');
end

%% 4. 逆Z变换示例
disp('=== 逆Z变换示例 ===');
Xz = (z^2 + z) / (z^2 - 0.5*z + 0.06);  % 定义一个有理函数
x_n = iztrans(Xz, z, n);
disp('X(z) ='); disp(Xz);
disp('对应的 x[n] ='); disp(x_n);