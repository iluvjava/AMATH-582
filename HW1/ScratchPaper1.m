load subdata.mat;
DATACUBE = zeros([49, n, n, n]);
L  = 10; n = 64; 
x2 = linspace(-L, L, n + 1); x = x2(1:n); y = x; z = x;
ks = (2*pi/(2*L))*(-n/2: n/2 - 1); k = fftshift(ks);

for TimeFrame = 1: 49
   DATACUBE(TimeFrame, :, :, :) = reshape(subdata(:, TimeFrame), [n, n, n]);
end

AveragedOut1D = mean(DATACUBE,[1, 3, 4]);
AveragedOut1D  = fftshift(AveragedOut1D);
Avg1DNrom = AveragedOut1D/max(AveragedOut1D, [], "all");
figure(1);
plot(ks, real(Avg1DNrom)); title("Only Looking at X, averaged out");

AveragedOut1D = reshape(mean(DATACUBE,[1, 2, 4]), [1, 64]);
AveragedOut1D  = fftshift(AveragedOut1D);
Avg1DNrom = AveragedOut1D/max(AveragedOut1D, [], "all");
figure(2);
plot(ks, real(Avg1DNrom)); title("Only Looking at y, averaged out");

AveragedOut1D = reshape(mean(DATACUBE, [1, 2, 3]), [1, 64]);
AveragedOut1D  = fftshift(AveragedOut1D);
Avg1DNrom = AveragedOut1D/max(AveragedOut1D, [], "all");
figure(3);
plot(ks, real(Avg1DNrom)); title("Only Looking at z, averaged out");


