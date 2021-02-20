clear all; close all; clc

A = imread('photo.jpeg');
Abw = rgb2gray(A); 
Abw = double(Abw);
B = Abw + 100*randn(600,800); 
Bt = fft2(B); 
Bts = fftshift(Bt);
subplot(2,2,1), imshow(uint8(B)), colormap(gray) 
subplot(2,2,2), pcolor((log(abs(Bts)))); 
shading interp 
colormap(gray), set(gca,'Xtick',[],'Ytick',[])

figure(6)
subplot(2,2,1), imshow(uint8(B)), colormap(gray) 
subplot(2,2,2), pcolor((log(abs(Bts)))); 
shading interp 
colormap(gray), set(gca,'Xtick',[],'Ytick',[])

% B: Grayscale Image addwith with noise. 
% Bt: FFT2 Transfoemd on the grayscale image with noise. 
% Bts: Bt shifted in 2d so the fourier domain is proper for filrering. 

%% FILTER

kx = 1:800; ky = 1:600; 
[Kx, Ky] = meshgrid(kx, ky); 
F = exp(-0.0001*(Kx - 401).^2 - 0.0001*(Ky - 301).^2); 
Btsf = Bts.*F;

subplot(2, 2, 3), pcolor(log(abs(Btsf))); 
shading interp 
colormap(gray), set(gca, 'Xtick', [], 'Ytick', [])

Btf = ifftshift(Btsf); 
Bf = ifft2(Btf); 
subplot(2, 2, 4), imshow(uint8(Bf)), colormap(gray)

% F: % Guassian filter centered at (401, 301)
% Btsf: The noisy grayscale image filtered with gaussian filter at the
% centered, fourier domain still shifted. 
% Btf: filtered noisy image in fourier domain, but unshifted. 
% bf: filtered noisy grayscale image in the spatial domain. 

%% GAUSSIAN FILTERS WITH DIFFERENT WIDTH
% Big filter: Noisy 
% Small filter: Blurry

% Gaussian filter 
fs = [0.01 0.001 0.0001 0]; 
for j = 1:4
  F = exp(-fs(j)*(Kx - 401).^2 - fs(j)*(Ky - 301).^2);
  Btsf = Bts.*F; 
  Btf = ifftshift(Btsf); 
  Bf = ifft2(Btf);
  figure(4), subplot(2,2,j), pcolor(log(abs(Btsf)))
  colormap(gray), shading interp
  set(gca,'Xtick',[],'Ytick',[])
  figure(5), subplot(2, 2, j), imshow(uint8(Bf)), colormap(gray)
end

%% STEP FILTERS
% Step Filter: Somehow better than Guasssian Filter.

figure(6)
width = 50;
Fs = zeros(600, 800); 
mask = ones(2*width + 1,2*width + 1);
Fs(301 - width:1:301 + width,401 - width:1:401 + width) = mask; 
Btsf = Bts.*Fs;
Btf = ifftshift(Btsf); 
Bf = ifft2(Btf);

subplot(2, 2, 3), pcolor(log(abs(Btsf))); 
shading interp
colormap(gray), set(gca,'Xtick',[],'Ytick',[])
subplot(2, 2, 4), imshow(uint8(Bf)), colormap(gray)
