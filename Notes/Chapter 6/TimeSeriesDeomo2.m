clc; close all; clear all;
L = 10; n = 2048;                             % ten seconds of realization 
t2 = linspace(0, L, n + 1); t = t2(1: n);     % Discretiations of the signal time domain
S = (3*sin(2*t) + 0.5*tanh(0.5*(t - 3)) + ... % a bunch of fancy functions 
     0.2*exp(-(t - 4).^2) + 1.5*sin(5*t)+ 4*cos(3*(t - 6).^2))/10 + ...
    (t/20).^3;


%% Fourier 
k = (2*pi/L)*[0: n/2 - 1, -n/2: -1]; ks= fftshift(k);
St = fft(S);

figure(1)
plot(t, S)

figure(2)
plot(ks, abs(fftshift(St)));

%% Gabor
close all; 
g = exp(-(t - 5).^2);

