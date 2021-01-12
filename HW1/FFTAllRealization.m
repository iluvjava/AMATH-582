function [FFT, FFTShifted] = FFTAllRealization(dataTensor)
    % Given a tensor in that shape of [p, n, n, n] where it represents 
    % a cube data collected with p realization. 
    % 
    % This function performs FFT transform on the data, with/without shifts, on
    % each of the realization. 
    % params: 
    %   An instance of ProblemParameters
    % dataTensor: 
    %   The submarine Data for the Homework, should be in shape of [1, 64, 64, 64]
    
    n = size(dataTensor, 1);
    FFT = zeros(size(dataTensor)); FFTShifted = zeros(size(dataTensor));
    for II = 1:n
        FFT(II, :, :, :) = fftn(dataTensor(II, :, :, :));
        FFTShifted(II, :, :, :) = fftshift(FFT(II, :, :, :));
    end
end