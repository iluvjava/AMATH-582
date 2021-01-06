clear all; close all;
n = 512;
whiteNoise = (randn(1, n) + i*randn(1, n)); 
DemoDifferenFilters(-15, whiteNoise);
DemoDifferenFilters(15, whiteNoise);
DemoDifferenFilters(0, whiteNoise);


function normalized = ArrayNormalized(arr)
    normalized = arr./max(abs(arr));
end

function argout = DemoDifferenFilters(frequenciesOffset, whiteNoise) 
    L  = 30;         % The total mount of signal. 
    n  = 512;        % These are the Fourier nodes. 
    Noise = 15;      % The amount of noise.
    t2 = linspace(-L, L, n + 1); t = t2(1:n); 
    k  = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1];   % Already shifted. 
    u  = sech(t);
    FreqFilter = exp(-0.2*(k - frequenciesOffset).^2);  % Note that the filter is in the frequencies domain.  

    uFourier = fft(u); % Fourier Domain
    uFourierNoisy = uFourier + Noise*whiteNoise;    % domain
    uFourierNoisyFiltered = uFourierNoisy.*FreqFilter;

    figure; 
    subplot(3, 1, 1)
    plot(fftshift(k), fftshift(abs(ArrayNormalized(uFourier))))        % The strengh of the freqiencies
    title("The Expected Response Signal without Noise")
    subplot(3, 1, 2)
    plot(fftshift(k), fftshift(abs(ArrayNormalized(uFourierNoisy))))
    title("Original Signal in Frequency domain")
    subplot(3, 1, 3)
    plot(t, real(ifft(uFourierNoisyFiltered)))
    ylim([-1, 1]);
    title(strcat("Reconstructed with Frequencies Filter Offset: ", num2str(frequenciesOffset)));
    
end