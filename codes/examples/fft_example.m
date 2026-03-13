% FFT 示例
fs = 1000;
t = 0:1/fs:1-1/fs;
f1 = 50; f2 = 120;
x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);
X = fft(x);
freq = (0:length(X)-1)*fs/length(X);
plot(freq, abs(X))
title('FFT 频谱')
xlabel('频率 (Hz)')