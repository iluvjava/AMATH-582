clear all; close all; clc

clear all; close all; clc;
A = imread('photo.jpeg'); % load image 
Abw = rgb2gray(A);        % make image black-and-white 
subplot(2, 2, 1), image(A); 
set(gca,'Xtick',[],'Ytick',[]) 
subplot(2, 2, 3), imshow(Abw);
A2 = double(A); % change form unit8 to double 
Abw = double(Abw);

noise = randn(600, 800, 3); % add noise to RGB image 
noise2 = randn(600, 800);   % add noise to black-and-white
u = uint8(A2 + 50*noise);   % change from double to uint8 
u2 = uint8(Abw+50*noise2);
subplot(2, 2, 2), image(u); 
set(gca, 'Xtick', [], 'Ytick', []) 
subplot(2, 2, 4), image(u2);
set(gca, 'Xtick', [], 'Ytick', [])

%% FFT IMAGES

Abw2 = Abw(600: -1: 1, :);  % Pcolor plot stuff upside down. 
figure(2)
subplot(2,2,1), pcolor(Abw2), shading interp, colormap(hot), set(gca,'Xtick',[],'Ytick',[])
Abwt=abs(fftshift(fft2(Abw2)));
subplot(2,2,2), pcolor(log(Abwt)), shading interp, colormap(hot), set(gca,'Xtick',[],'Ytick',[])



