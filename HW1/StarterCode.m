clear all; close all; clc;
load subdata.mat;
%% 
L  = 10; n = 64; 
x2 = linspace(-L, L, n + 1); x = x2(1:n); y = x; z = x;
ks = (2*pi/(2*L))*(-n/2: n/2 - 1); k = fftshift(ks);
% ks: lower freqnecies centered. 
% k: lower frequencies at both end. 

[X, Y, Z] = meshgrid(x, y, z); 
[Kx, Ky, Kz] = meshgrid(ks, ks, ks);
% a 3d meshgrid for the signal domain and the frequency domain. 

for j = 1: 1
    Un(:, :, :) = reshape(subdata(:, j), n, n, n);
    M = max(abs(Un), [], "all");
    close all, isosurface(X, Y, Z, abs(Un)/M, 0.5);
    axis([-10, 10, -10, 10, -10, 10]), grid on, drawnow; 
    pause(1)
end

%% Noise Cancellation, The Best Freqneicies locations

DATACUBE = reshape(subdata, [size(subdata, 2), 64, 64, 64]);
FreqDataAvg = reshape(mean(DATACUBE, 1), [64, 64, 64]);
FreqDataAvg = fftshift(FreqDataAvg, 3); % FreqDataAvg is shifted here. 
Max = max(max(max(FreqDataAvg)));
MaxPlace = find(FreqDataAvg == Max);
MaxPlaceKx = Kx(MaxPlace);
MaxPlaceKy = Ky(MaxPlace);
MaxPlaceKz = Kz(MaxPlace);
MaxFrequencies = [MaxPlaceKx, MaxPlaceKy, MaxPlaceKz];
close all; 
isosurface(Kx, Ky, Kz,abs(FreqDataAvg)/max(abs(FreqDataAvg), [], "all"), 0.5); hold on
plot3(Kx(MaxPlace), Ky(MaxPlace), Kz(MaxPlace), '-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
disp(strcat("The Frequencies locaiton of the Submarine is: ", num2str(MaxFrequencies)));

%% 
Gauss       = @(x, y, z) exp(-0.5*(x.^2 + y.^2 + z.^2));
GaussFilter = @(x, y, z) Gauss(x - MaxPlaceKx, y - MaxPlaceKy, z - MaxPlaceKz);

figure; 
KFilter = linspace(min(ks), max(ks), 64);
[FilterX, FilterY, FilterZ] = meshgrid(KFilter, KFilter, KFilter);
isosurface(FilterX, FilterY, FilterZ, GaussFilter(FilterX, FilterY, FilterZ), 0.5); 
title("Guass MaxFilter isoval 0.5");
%% 
for TimeFrame = 1: 49
    Realization = reshape(DATACUBE(TimeFrame, :, :, :), [64, 64, 64]);
    FilteredRealization = GaussFilter(Kx, Ky, Kz).*fftshift(Realization, 3);
    FilteredRealization = ifftshift(FilteredRealization , 3);

    figure;
    Signal = ifftn(FilteredRealization);
    isosurface(X, Y, Z,abs(Signal)/max(abs(Signal), [], "all"), 0.7);
end

%%
histogram(reshape(real(FFTCubeAvg), [1, 64^3]), 300);


