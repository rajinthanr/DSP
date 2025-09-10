load handel;
y = y(1:5000);
%sound(y,Fs);
%plot(y);

N = 5000;
x = y(1 : N);
x2 = x(1 : 2 : N);
x3 = x(1 : 3 : N);
x4 = x(1 : 4 : N);

x2_up = zeros(1, 2*length(x2));  % preallocate
x2_up(1:2:end) = x2;             % put samples at odd indices



f2 = abs(fft(x2_up));
stem(f2);

function up = upsample(xi , K)

f2 = fft(xi);
N=length(xi);
fup = zeros(N+K*N);
fup(1:N/2) =  f2(1:N/2);
fup(end-N/2+2:end) =  f2(end-N/2+2:end);

if(mod(N,2)==1)
    fup(N/2+1)=f2(N/2+1);
    fup(end-N/2+1) = f2(end-N/2+1);

else
    fup(N/2+1)=f2(N/2+1)/2;
    fup(end-N/2+1) = f2(end-N/2+1)/2;

end

up = ifft(fup);
end


x2_up = upsample(x2, 1);

plot(x2_up);
