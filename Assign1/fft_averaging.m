% Load signal
data = load("signal502.mat","xn_test");
signal = data.xn_test;
Fs = 128;         % Sampling frequency
K  = 256;         % Subset length
L  = 7;          % Number of subsets
Ntotal = length(signal);

% Reshape into matrix: each column = one subset of length K
x_matrix = reshape(signal(1:K*L), K, L);

% Initialize averaged spectrum
Pxx_avg = zeros(K/2+1,1);

for i = 1:L
    x = x_matrix(:,i);       % i-th subset
    Y = fft(x);              % DFT
    P2 = (Y/K);        % Periodogram (power spectrum estimate)
    P1 = P2(1:K/2+1);        % One-sided
    
    % Accumulate
    Pxx_avg = Pxx_avg + P1;
end

% Average across subsets
Pxx_avg = abs(Pxx_avg) / L;

% Frequency axis
f = Fs*(0:(K/2))/K;

% Plot averaged spectrum
figure;
stem(f, Pxx_avg, 'Marker','none');
xlabel('Frequency (Hz)');
ylabel('Power');
title('DFT Averaging Method (K=128, L=14)');
grid on;
