clc; clear all; close all;

%% READ VIDEO AND VIDEO PROCESSING: SKINGS
vidObj = VideoReader("data\ski_drop_low.mp4"); 
AllFrames = read(vidObj);
AllFrames = 255 - AllFrames(100: end - 100, 300: end - 400, :, :);  % Video Inversion
VidName = "ski";
KeyFrame = 200;
whos AllFrames
%% READ VIDEO AND VIDEO PROCESSING: RACING
% vidObj = VideoReader("data\monte_carlo_low.mp4"); 
% AllFrames = read(vidObj); 
% AllFrames = AllFrames(:, :, :, 1:200);
% VidName = "carlo";
% KeyFrame = 50;
% whos AllFrames

%% PACK VID INTO GRAY SCALE AND COLUMN DATA MATRIX
AllFramesGray = zeros(size(AllFrames, [1, 2, 4]));
[m, n, k] = size(AllFrames, [1, 2, 4]);
VidPack = zeros([m*n, k]);
for II = 1: size(AllFrames, 4)
    AllFramesGray(:, :, II) = rgb2gray(AllFrames(: , :, :, II));
    Temp = rgb2gray(AllFrames(: , :, :, II));
    VidPack(:, II) = double(Temp(:))/255;   
    % [0, 1] range for gray scale
end
clearvars AllFrames

%% PLAY AND VIEW THE VIDEO
figure; 
for II = 1% 1: size(AllFramesGray, 3)
    imshow(reshape(VidPack(:, II), [m, n]));
    drawnow;
end

%% SVD ON THE VID FIGURE OUT THE RANK
[U, S, V] = svd(VidPack, "econ"); 
SingularCumSum = cumsum(diag(S).^2);
SingularCumSum = SingularCumSum/max(SingularCumSum);
Rank = find(SingularCumSum > 0.99, 1);

%%
figure;
subplot(2, 1, 1); 
bar(diag(S(1:30, 1:30))); 
xlabel("Singular Val Rank");
ylabel("Singular Val Magnitude");
subplot(2, 1, 2);
bar(SingularCumSum(1:30), "y");
xlabel("Singular Val Rank");
ylabel("Culmulative Energy"); 
xline(Rank, "-","95%", "fontsize", 12);
sgtitle(strcat("DMD Modes for Vid: ", VidName));
saveas(gcf, strcat("dmd-modes-", VidName), "png");

%% FOR OUT OF MEMORY
clearvars -except VidPack m n Rank k VidName KeyFrame

%% CHECK THE CONTINUOUS EIGENVALUES.
[Lambda, Phi] = RunDMD(VidPack, Rank); % DMD

%% DMD RECONSTRUCTION
u0 = VidPack(:, 1);
DeltaT = 1;
Moments = size(VidPack, 2);
[Reconstructed, OmegaBestIdx] = DMDReconstruct(Phi, Lambda, u0, 1, 1:k);

%%
Omegas = log(diag(Lambda));
figure;
scatter(real(Omegas), imag(Omegas)); hold on;
title("Omages, Continous Eigenvalues for DMD Modes"); 
scatter(real(Omegas(OmegaBestIdx)), imag(Omegas(OmegaBestIdx)), "x");
legend("Modes", "Background Modes")
saveas(gcf, strcat("dmd-omega-", VidName), "png");

%% PLAY RECONSTRUCTED
figure;
for II = 1 %  size(Reconstructed, 2)
    imshow(abs(reshape(Reconstructed(:, II), [m, n])));
    drawnow;
end

figure;
imshow(reshape(Reconstructed(:, KeyFrame), [m, n])); 
saveas(gcf, strcat("static-background-", VidName), "png")
title(strcat("Background of: ", VidName));

%% BACKGROUND SUBTRACTION
XDMDSparse = VidPack - abs(Reconstructed);
R = (XDMDSparse < 0).*XDMDSparse;
XDMDLowRank = R + abs(Reconstructed);
XDMDSparse = XDMDSparse - R;

%% VIEWING THE FILTER VIDEO
figure;
for II = 1% 1: Moments
    imshow(reshape(XDMDSparse(:, II), [m, n]));
    drawnow;
end

%% SAVING KEY FRAMES
figure("name", "figure 4","position", [0 0 900 500]);
subplot(1, 2, 1)
imshow(reshape(XDMDSparse(:, KeyFrame), [m, n]));
subplot(1, 2, 2)
imshow(reshape(VidPack(:, KeyFrame), [m, n]));
sgtitle(strcat("Foreground/Original: ", VidName));
saveas(gcf, strcat("dmd-foreground-original-", VidName), "png");