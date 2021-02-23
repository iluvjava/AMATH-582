%% PCA ANALYSIS
clc; close all;

TEST_INSTANCE = 3;   % <== Tweak test instances here! 

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
figure(1); 
sgtitle(strcat("Observed Data; Test Instance: ", num2str(TEST_INSTANCE)));
for II = 1: 3
    RowXIdx = (II - 1)*2 + 1;
    RowYIdx = RowXIdx + 1;
    
    subplot(3, 2, RowXIdx);
    plot(RowDataMatrix(RowXIdx, :), "k");
    ylabel("Pixels");
    xlabel("Frames");
    title(strcat("Cam", num2str(II), " vertical motion"));
    
    subplot(3, 2, RowYIdx);
    plot(RowDataMatrix(RowYIdx, :), "k");
    ylabel("Pixels");
    xlabel("Frames");
    title(strcat("Cam", num2str(II), " horizontal motion"));
end
saveas(gcf, strcat("observed-data-test-instance", num2str(TEST_INSTANCE)), "png");

%% PCA NORMALIZATION OVER THE WHOLE MATRIX

% Normalize motion wrt to the screen size capture by camera. 
% Normalize the notion by subtracting the averae of each row. 
ScreenSize = [480; 640; 480; 640; 480; 640];
StdDataMatrix = RowDataMatrix - mean(RowDataMatrix, 2);
StdDataMatrix = StdDataMatrix./ScreenSize;

figure(2);
title("Covariance on Std Data Matrix");
imagesc(cov(StdDataMatrix.')); 
colorbar;
saveas(gcf, strcat("cov-std-matrix", num2str(TEST_INSTANCE)), "png");

[U, Sigma, V] = svd(StdDataMatrix, "econ");

figure('name', "PCA", 'Position', [0, 0, 900 600]);
sgtitle(strcat("PCA for Case: ", num2str(TEST_INSTANCE)))
for II = 1: 6
    subplot(6, 2, 2*(II - 1) + 1)
    plot(V(:, II), "k")
    title(strcat("Mode: ", num2str(II)))
end

subplot(6, 2, 2:2:6);
bar(1:6, diag(Sigma));
xlabel("Ranks of Singular Value");
ylabel("Singular Value");

subplot(6, 2, 8:2:12);
plot(cumsum(diag(Sigma))/sum(diag(Sigma)), "ko-");
ylabel("Cumulative Energy")
saveas(gcf, strcat("pca-analysis", num2str(TEST_INSTANCE)), "png");


