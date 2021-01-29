clear all; close all; clc

%% GRAYSCALE ADD NOISE
A = imread('espresso.jpg');
Abw = rgb2gray(A);
Abw = double(Abw);
[nx ,ny] = size(Abw);
u2 = uint8(Abw + 20*randn(nx, ny));
subplot(2, 2, 1), imshow(A)
subplot(2, 2, 2), imshow(u2)

%%
x = linspace(0, 1, nx);
y = linspace(0, 1, ny);
dx = x(2) - x(1); dy = y(2) - y(1);
onex = ones(nx, 1); oney=ones(ny, 1);
Dx = (spdiags([onex -2*onex onex], [-1 0 1], nx, nx))/dx^2;
Ix = eye(nx);
Dy = (spdiags([oney -2*oney oney], [-1 0 1], ny, ny))/dy^2;
Iy = eye(ny);
L = kron(Iy, Dx) + kron(Dy, Ix);

tspan = [0 0.005 0.02 0.04]; D = 0.0005;
u3 = Abw + 20*randn(nx, ny);
u3_2 = reshape(u3, nx*ny, 1);
[t, usol] = ode113('image_rhs', tspan, u3_2, [], L, D);

for j = 1:length(t)
    Abw_clean = uint8(reshape(usol(j,:), nx, ny));
    subplot(2, 2, j), imshow(Abw_clean);
end
