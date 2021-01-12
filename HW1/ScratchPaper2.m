% Files involved: 
% 1. MaxFrequencies.m
% 2. IndexToFrequencies.m
% 3. ProblemParameters.m
% 4. FFTAllRealization.m
% 5. BestGuassianFilter.m
% 6. ReconstructAllRealization.m
% 7. IndexToFrequencies.m

close all; clear all; clc;
load subdata;
%% Setting up things
params = ProblemParameters(); 
Cubes  = zeros([size(subdata, 2), params.n, params.n, params.n]);
for II = 1: size(Cubes, 1)
    Cubes(II, :, :, :) = reshape(subdata(:, II), [params.n, params.n, params.n]);
end

%% Visualizing Peaking Frequencies
params = ProblemParameters(); 
Threshold = 0.7;
[Freqs, Transformed] = MaxFrequency(params, subdata, Threshold);
% How does the freqiencies magnitude distribute? 

Normalized = abs(Transformed)/max(abs(Transformed), [], "all");
figure(1);
subplot(2, 1, 1)
histogram(Normalized); title("abs(ave realization frequencies)");
subplot(2, 1, 2)
histogram(Normalized(Normalized >= Threshold)); title("frequencies abs larger than threshold");

disp(strcat("Index of the preaking frequencies: ", num2str(Freqs)));
disp(num2str(Freqs));


%% Where is the peak frequencies? 
figure(2);
for II = 1:length(Freqs)
    Freq = IndexToFrequencies(params, Freqs(II));
    plot3(Freq(1), Freq(2), Freq(3), '-o', 'Color', 'b','MarkerSize', 10, 'MarkerFaceColor', '#D9FFFF'); 
    hold on;
end
disp("The spread of the peak frequencies are relatively compact inside of the region.");

%% Getting the Filter 
Filter = BestGaussianFilter(params, Freqs);
close gcf;
figure(3);
isosurface(params.Kx, params.Ky, params.Kz,... 
           Filter, 0.5);
title("Guassian Filter"); 

%% Applying the Filter
FilterTensor = Filter;
FilterTensor = reshape(FilterTensor, [1, params.n, params.n, params.n]);
[InFourier, ToFilter] = FFTAllRealization(Cubes);
Filtered = FilterTensor.*ToFilter; 
Reconstructed = ReconstructAllRealization(Filtered);

[~, PeakingPoints] = GetPeakingSignal(params, Reconstructed);

%% Visualizing the Paths. 
figure(5);
plot3(PeakingPoints(1, :), PeakingPoints(2, :), PeakingPoints(3, :), "ko-");
title("Path of the submarine");

%%
function IsoPlot(cube, threshold)
    cube = abs(cube)/max(abs(cube), [], "all");
    figure; 
    isosurface(cube, threshold);
end





