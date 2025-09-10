% Load signal
data = load("signal502.mat","xn_test");
signal = data.xn_test;

Fs = 128;            % Sampling frequency (Hz)
Ntotal = length(signal);

% Construct subsets
S1 = signal(1:128);     
S2 = signal(1:256);     
S3 = signal(1:512);     
S4 = signal(1:1024);    
S5 = signal(1:1792);    

subsets = {S1, S2, S3, S4, S5};
names   = {'S1 (128)', 'S2 (256)', 'S3 (512)', 'S4 (1024)', 'S5 (1792)'};

% Plot FFTs
figure;
for k = 1:length(subsets)
    x = subsets{k};
    N = length(x);
    
    % FFT
    Y = fft(x);
    P2 = abs(Y/N);
    P1 = P2(1:N/2+1);
    
    % Frequency axis
    f = Fs*(0:(N/2))/N;
    
    % Plot
    subplot(3,2,k);
    stem(f, P1, 'Marker','none');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    title(['FFT of ' names{k}]);
    grid on;
end
