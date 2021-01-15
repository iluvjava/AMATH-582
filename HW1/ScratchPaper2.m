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
histogram(Normalized); title("abs(Avg Frequencies Across Realization)");
subplot(2, 1, 2)
histogram(Normalized(Normalized >= Threshold)); 
title(strcat("frequencies abs larger than threshold: ", num2str(Threshold)));
disp(strcat("Index of the preaking frequencies: ", num2str(Freqs)));
disp(num2str(Freqs));
saveas(gcf, "freq-distribution", "png");

%% Where is the peak frequencies? 
figure(2);
for II = 1:length(Freqs) - 1
    Freq = IndexToFrequencies(params, Freqs(II));
    plot3(Freq(1), Freq(2), Freq(3), '-o', 'Color', 'b','MarkerSize', 10, 'MarkerFaceColor', '#D9FFFF'); 
    hold on;
end
 plot3(Freq(1), Freq(2), Freq(3), '-o', 'Color', 'b','MarkerSize', 10, 'MarkerFaceColor', '#FF0000'); 
title(strcat("Peaking Frequency in Fourier Space, Threshold: ", num2str(Threshold)));
xlabel("Frequency: kx"); ylabel("Frequency: ky"); zlabel("Frequency: kz");
disp("The spread of the peak frequencies are relatively compact inside of the region.");
saveas(gcf, "peaking-freq-position", "png");

%% Getting the Filter 
Filter = BestGaussianFilter(params, Freqs);
close gcf;
figure(3);
isosurface(params.Kx, params.Ky, params.Kz, Filter, 0.5); 
title(strcat("The Guassian Filter at Peaking Frequencies, isoval:", num2str(0.5)));
xlabel("Frequency: kx"); ylabel("Frequency: ky"); zlabel("Frequency: kz");
saveas(gcf, "gaussian-filter", "png"); 

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
t = linspace(0, 1, size(PeakingPoints, 2));
QueryPoints = linspace(0, 1, 100);
PathX = interpn(t, PeakingPoints(1, :), QueryPoints, "spline");
PathY = interpn(t, PeakingPoints(2, :), QueryPoints, "spline"); 
PathZ = interpn(t, PeakingPoints(3, :), QueryPoints, "spline");
hold on;
plot3(PathX(end), PathY(end), PathZ(end), "*r");
xlabel("X axis"); ylabel("Y axis"); zlabel("Z axis");
saveas(gcf, "submarine-path", "png");




