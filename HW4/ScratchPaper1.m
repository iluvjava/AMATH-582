clear all; clc;
[images, labels] = mnist_parse... 
    ('data\train-images.idx3-ubyte', 'data\train-labels.idx1-ubyte');
[images_test, labels_test] = mnist_parse... 
    ('data\t10k-images.idx3-ubyte', 'data\t10k-labels.idx1-ubyte');

FlattendImagesStd = ImageNormalize(images);
FlattendImagesStd_Test = ImageNormalize(images_test);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SVD ANALYSIS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[U, Sigma, V] = svd(FlattendImagesStd, "econ");

%% SVD VISUALIZATION ======================================================
figure(1);
CulmulativeSigma = cumsum(diag(Sigma))./sum(Sigma, "all");
SingularValues = diag(Sigma)./max(diag(Sigma));

subplot(2, 1, 2);
bar(CulmulativeSigma);
Energy98 = find(CulmulativeSigma > 0.98, 1);
Energy95 = find(CulmulativeSigma > 0.95, 1);
Energy90 = find(CulmulativeSigma > 0.90, 1);
xline(Energy98, '-', strcat("98%: r=", num2str(Energy98)),... 
    "linewidth", 2, "fontsize", 12);
xline(Energy95, '-', strcat("95%: r=", num2str(Energy95)),...
    "linewidth", 2, "fontsize", 12);
xline(Energy90, '-', strcat("90%: r=", num2str(Energy90)),...
    "linewidth", 2, "fontsize", 12);
title("Culmulative Energy");
xlabel("Ranks");
ylabel("Energy");

subplot(2, 1, 1);
bar(SingularValues(1:Energy98)); 
title("Singular Values Spectrum");
xlabel("Ranks");
ylabel("Relative Size to max");

%% SVD PROJECTION =========================================================
ModesIdx = [1, 5, 8];
Projection = Sigma*V.';
Projection = Projection(ModesIdx, :);
figure(2);
for Label = 0:9
    disp(Label)
    PointsWithLabel = Projection(:, labels == Label);
    X = PointsWithLabel(1, :); 
    Y = PointsWithLabel(2, :);
    Z = PointsWithLabel(3, :);
    Color = rand(1, 3);
    scatter3(X, Y, Z, 6,"MarkerFaceColor", Color, "MarkerEdgeColor", Color);
    hold on;
end
legend(["0", "1", "2", "3", "4", "5", "6", "7", "8","9"]);
title("Principal Compoenent Projection Onto: 1, 5, 8");

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LDA BASIC BINARY CLASSIFICATION
% Relavent Links:
% Visulization: 
% "https://www.mathworks.com/help/stats/create-and-visualize-discriminant-analysis-classifier.html"
% The Classification Discriminant Class: 
% "https://www.mathworks.com/help/stats/classificationdiscriminant-class.html"
% Predict, Confusion Matrix 
% "https://www.mathworks.com/help/stats/compactclassificationdiscriminant.predict.html"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LDAData = FlattendImagesStd.';
LDALabels = labels;

DigitsToSeparate = (LDALabels == 1) + (LDALabels == 2);

LDAData = LDAData(boolean(DigitsToSeparate), :);
LDALabels = LDALabels(boolean(DigitsToSeparate), :);

Model = fitcdiscr(LDAData, LDALabels);

SeperationSubspace = Model.Coeffs(2, 1).Linear; 
Projection = SeperationSubspace.'*LDAData.';

figure(3);
hist(Projection); title("LDA Separation");

%% ========================================================================
%  MULTI-CLASS FITTING AND CONFUSION MATRIX
% 1. 
% =========================================================================
LDAData = FlattendImagesStd.';
LDALabels = labels;
LDADataTest = FlattendImagesStd_Test.';
Model = fitcdiscr(LDAData, LDALabels, "Delta", 0.0083855, "Gamma", 0.38628);
% Model = fitcdiscr(LDAData, LDALabels, "DiscrimType", "quadratic");
%%
PredictedLabels = predict(Model, LDADataTest);

%% 
figure(4)
title("10 Digits Confustion Matrix");
confusionchart(labels_test, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA Confusion");


%% ========================================================================
% SVM
% Command fitcecoc: 
% https://www.mathworks.com/help/stats/fitcecoc.html
% https://www.mathworks.com/help/stats/classificationecoc.html
% =========================================================================
SVMMode = fitcecoc(FlattendImagesStd.', labels);






%% ========================================================================
% Decision Tree 
% =========================================================================



