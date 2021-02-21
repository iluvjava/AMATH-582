%% PCA ANALYSIS
clc; clear all; close all;

TEST_INSTANCE = 4;

% Row data matrix format: 
% cam 1, x, y coords on the 1, 2 row
% cam 2, x, y coords on the 3, 4 row 
% cam 3, x, y coords on the 5, 6 row

RowDataMatrix = zeros(6, 1); 
MinLength = inf;
for II = 0: 2
    tracer = TracerSettings(II + 1, TEST_INSTANCE);
    coords = tracer.traceRoute();
    RowDataMatrix(2*II + 1: 2*II + 2, 1: size(coords, 2)) = coords;
    MinLength = min(MinLength, size(coords, 2));
end
RowDataMatrix = RowDataMatrix(:, 1: MinLength);

%% DATA MATRIX VISUALIZE
figure; 
sgtitle(strcat("Test Instance: ", num2str(TEST_INSTANCE)));
for II = 1: 3
    RowXIdx = (II - 1)*2 + 1;
    RowYIdx = RowXIdx + 1;
    
    subplot(3, 2, RowXIdx);
    plot(RowDataMatrix(RowXIdx, :), "k");
    ylabel("Pixels");
    xlabel("Frames");
    title(strcat("Cam", num2str(II), " x motion"));
    
    subplot(3, 2, RowYIdx);
    plot(RowDataMatrix(RowYIdx, :), "k");
    ylabel("Pixels");
    xlabel("Frames");
    title(strcat("Cam", num2str(II), " y motion"));
end


%% PCA NORMALIZATION OVER THE WHOLE MATRIX

screen = [480; 640; 480; 640; 480; 640];
StdDataMatrix = RowDataMatrix./screen;

figure;
title("Signal Original Covariance")
imagesc(cov(StdDataMatrix.')); 
colorbar; 

figure;
[U, Sigma, V] = svd(StdDataMatrix, "econ");

figure('Position', [0, 0, 900 600]);
sgtitle(strcat("Principal Components for Case: ", num2str(TEST_INSTANCE)))
for II = 1: 6
    subplot(6, 2, 2*(II - 1) + 1)
    plot(V(:, II), "k")
    title(strcat("Mode: ", num2str(II)))
end
subplot(6, 2, 2:2:12)
plot(1:6, diag(Sigma), "kx-")
title("Principal Value Distribution")

