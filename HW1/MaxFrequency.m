 function [MaxFrequencies, Transformed] = MaxFrequency(params, Data, threshold)
    % Maxfreqencies: 
    %   Index that gives the frequencies with the strongest
    %   signal. 
    % Transformed: 
    %   The normalized matrix, denoised, 
    %   in fourier domain and shifted. 
    
    n  = params.n;
    Avg = zeros(n, n, n);
    for II = 1: size(Data, 2)
        Cube(:, :, :) = reshape(Data(:, II), [n, n, n]);
        Cube(:, :, :) = fftn(Cube);
        Avg = Avg + Cube;
    end
    Avg = fftshift(Avg);
    Avg = abs(Avg)/max(abs(Avg), [], "all");
    MaxFrequencies = find(Avg >= threshold);
    Transformed = Avg;
 end