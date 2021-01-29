L = 4; 
N = 2^16;
x2 = linspace(-L/2, L/2, N + 1);
x  = x2(1:N);  
k = (2*pi/L)*(-N/2: N/2 - 1);
signal = sin(440*2*pi*x);
signalFFTShifted = fftshift(fft(signal));

figure(1)
plot(x, signal)
figure(2)
plot(k/(2*pi), abs(signalFFTShifted));

xfft = fftshift(x)