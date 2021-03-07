
MnistTrain = MNISTPCA(1); 
MnistTest = MNISTPCA(2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCA ON TEST SET. 

MnistTrain.beautifulEnergyPlot();
MnistTrain.figurePlotProj3D();

% LDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LDA WITH PCA REDUCTION FOR ALL DIGITS
[DataTrain, LabelsTrain, Projector, ~] = MnistTrain.principalProj(0.5); 
TestaData = Projector*MnistTest.DataStd;
TestLabels = MnistTest.Labels;

Model = fitcdiscr(DataTrain.', LabelsTrain.');
PredictedLabels = predict(Model, TestaData.');
CVModel = crossval(Model);
L = kfoldLoss(CVModel);
disp(strcat("10 digits cross val loss: ", num2str(L)));

figure;
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA Confusion Matx Linear");

%% QUADRATIC LDA WITH PCA REDUCTION FOR ALL DIGITS
[DataTrain, LabelsTrain, Projector, ~] = MnistTrain.principalProj(0.5); 
TestaData = Projector*MnistTest.DataStd;
TestLabels = MnistTest.Labels;

Model = fitcdiscr(DataTrain.', LabelsTrain.', "DiscrimType", "Quadratic");
PredictedLabels = predict(Model, TestaData.');
CVModel = crossval(Model);
L = kfoldLoss(CVModel);
disp(strcat("10 digits cross val loss: ", num2str(L)));

figure;
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA Confusion Matx Quadratic");


%% 4, 5 Binary Separation
DIGIT1 = 4; 
DIGIT2 = 5;

[DataTrain, LabelsTrain, Projector, ~] = MnistTrain.principalProj(0.5, [DIGIT1, DIGIT2]); 
TestData = Projector*MnistTest.DataStd;
TestLabels = MnistTest.Labels;
[TestData, TestLabels] = SplitByLabels(TestData, TestLabels, [DIGIT1, DIGIT2]);

Model = fitcdiscr(DataTrain.', LabelsTrain.', "DiscrimType", "linear", "delta", 0.00091834, "gamma", 0.00533);
PredictedLabels = predict(Model, TestData.');

figure;
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA Confusion Mtx Linear");


%% 4, 9 LDA BINARY SEPARATIONS
DIGIT1 = 9; 
DIGIT2 = 4;

[DataTrain, LabelsTrain, Projector, ~] = MnistTrain.principalProj(0.5, [DIGIT1, DIGIT2]); 
TestData = Projector*MnistTest.DataStd;
TestLabels = MnistTest.Labels;
[TestData, TestLabels] = SplitByLabels(TestData, TestLabels, [DIGIT1, DIGIT2]);

Model = fitcdiscr(DataTrain.', LabelsTrain.');
PredictedLabels = predict(Model, TestData.');

figure;
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA Confusion");

%% 0, 1 Binary Separation 
DIGIT1 = 0; 
DIGIT2 = 1;

[DataTrain, LabelsTrain, Projector, ~] = MnistTrain.principalProj(0.5, [DIGIT1, DIGIT2]); 
TestData = Projector*MnistTest.DataStd;
TestLabels = MnistTest.Labels;
[TestData, TestLabels] = SplitByLabels(TestData, TestLabels, [DIGIT1, DIGIT2]);

Model = fitcdiscr(DataTrain.', LabelsTrain.');
PredictedLabels = predict(Model, TestData.');

figure;
title("Confustion Matrix");
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA Confusion");

%% 4, 9, 7, Separation
DIGIT1 = 4; 
DIGIT2 = 9;
DIGIT3 = 7;

[DataTrain, LabelsTrain, Projector, ~] = MnistTrain.principalProj(0.5, [DIGIT1, DIGIT2, DIGIT3]); 
TestData = Projector*MnistTest.DataStd;
TestLabels = MnistTest.Labels;
[TestData, TestLabels] = SplitByLabels(TestData, TestLabels, [DIGIT1, DIGIT2, DIGIT3]);

Model = fitcdiscr(DataTrain.', LabelsTrain.');
PredictedLabels = predict(Model, TestData.');

figure;
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA Confusion");

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SVM FAIED 
clc;
RawImages = double(MnistTrain.Data);
LabelsTrain = MnistTrain.Labels;
DataTrain = reshape(RawImages, [28^2, size(RawImages, 3)]); 
DataTrain = DataTrain/255; % Standardization in discguise 
DataTrain = DataTrain(:, :);
LabelsTrain = LabelsTrain(:);

DataTest = double(MnistTest.Data); 
DataTest = reshape(DataTest, [28^2, size(DataTest, 3)]);
LabelsTest = MnistTest.Labels; 

ModelTemplate = templateSVM("KernelFunction", "poly", "PolynomialOrder", 2);
Model = fitcecoc(DataTrain.', LabelsTrain, "Learners", ModelTemplate);

%% 
PredictedLabels = predict(Model, DataTest.');
confusionchart(LabelsTest, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("SVM Quadratic Kernel");

%% SVM With Functions
clc;
[TrainX, TrainY, Projector, ~] = MnistTrain.principalProj(0.5); 
TestX = Projector*MnistTest.DataStd;
TestY = MnistTest.Labels; 
TestX = MinMaxStd(TestX); 
[SVMModel, Loss] = GetSVMModel(TrainX, TrainY);
TestPredictedLabels = predict(SVMModel, TestX.'); 
%% 
confusionchart(TestY, TestPredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("PCA With SVM"); 


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DECISION TREE ENSEMBLE











