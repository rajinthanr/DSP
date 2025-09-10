fs = 40;
T = 1/fs;
N = 40;
t = (0:N-1)*T;

signal = sin(2*pi * 3 *t);

plot(t, signal, '.-');
y = fft(signal);

K = (0:N-1);
freq = K*fs/N;
stem(freq,abs(y));

m = ifft(y);
plot(m, '.');