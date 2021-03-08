
MnistTrain = MNISTPCA(1); 
MnistTest = MNISTPCA(2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCA ON TEST SET. 

MnistTrain.beautifulEnergyPlot();
MnistTrain.figurePlotProj3D();

% LDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LDA WITH PCA REDUCTION FOR ALL DIGITS
% 

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


%% LINEAR DIS ON ALL DATA WITH PCA

[~, ~, TestLabels, PredictedLabels] = GetLDAModels(MnistTrain, MnistTest);
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');
title("LDA All Digits Test Sets with PCA");


%% LINEAR DIS ON DIGIT 4, 5, 7 WITH PCA
[~, ~, TestLabels, PredictedLabels] = GetLDAModels(MnistTrain, MnistTest, [4, 9, 7]);
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');


%% LINEAR DIS ON DIGIT 4, 9 WITH PCA
[~, ~, TestLabels, PredictedLabels] = GetLDAModels(MnistTrain, MnistTest, [4, 9]);
figure; 
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');



%% LINEAR DIS ON DIGIT 0, 1 WITH PCA
[~, ~, TestLabels, PredictedLabels] = GetLDAModels(MnistTrain, MnistTest, [0, 1]);
figure; 
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');



%% QDA ON ALL DIGITS WITH PCA 
[~, ~, TestLabels, PredictedLabels] = GetLDAModels(MnistTrain, MnistTest, [], "Quadratic");
figure; 
confusionchart(TestLabels, PredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized');



%% SVM WITH PCA WITH GAUSSIAN KERNEL 
clc;
[TrainX, TrainY, Projector, ~] = MnistTrain.principalProj(0.5); 
TestX = Projector*MnistTest.DataStd;
TestY = MnistTest.Labels; 
TestX = MinMaxStd(TestX); 
[SVMModel, Loss] = GetSVMModel(TrainX, TrainY);
disp(strcat("SVM Loss ", num2str(Loss))); 
TestPredictedLabels = predict(SVMModel, TestX.'); 

confusionchart(TestY, TestPredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("PCA With SVM"); 


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DECISION TREE SINGLE
% Reference: 
% https://www.mathworks.com/help/stats/select-predictors-for-random-forests.html#d122e72743
clc;
[TrainX, TrainY, Projector, ~] = MnistTrain.principalProj(0.5); 
TrainX = TrainX(:, 1: end);
TrainY = TrainY(1: end);
TestX = Projector*MnistTest.DataStd;
TestY = MnistTest.Labels; 
Tree = fitctree(TrainX.', TrainY);
% view(Tree.Trained{1}, 'Mode', 'graph'); 
% classError = kfoldLoss(Tree); 
% disp(classError); 

TestPredictedLabels = predict(Tree, TestX.'); 

confusionchart(TestY, TestPredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("PCA TREE"); 

%% DECISION FOREST 
clc;
[TrainX, TrainY, Projector, Idx] = MnistTrain.principalProj(0.5); 
TrainX = TrainX(:, 1:end);
TrainY = TrainY(1:end);
TestX = Projector*MnistTest.DataStd;
TestY = MnistTest.Labels; 
Tree = fitctree(TrainX.', TrainY);

t = templateTree("MinLeafSize", 3);
Dtree = fitrensemble(TrainX.', TrainY, 'Method', 'LSBOost', 'NumLearningCycles', 260, ...
    'Learners', t, "LearnRate", 0.075036);

PredictedTestLabels = predict(Dtree, TestX.');
figure;
confusionchart(TestY, PredictedTestLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("Random Forest with PCA"); 

%% SVM, DTREE, LDA, HARDEST PAIR: 4, 9

% SVM ----------------------------------------------------------------------------------------------------------------------------
clc;
[TrainX, TrainY, Projector, ~] = MnistTrain.principalProj(0.5, [4, 9]); 
TestX = Projector*MnistTest.DataStd;
TestY = MnistTest.Labels; 
TestX = MinMaxStd(TestX); 
[TestX, TestY] = SplitByLabels(TestX, TestY, [4, 9]); 

[SVMModel, Loss] = GetSVMModel(TrainX, TrainY);
disp(strcat("SVM Loss ", num2str(Loss))); 
TestPredictedLabels = predict(SVMModel, TestX.'); 

figure; 
confusionchart(TestY, TestPredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("PCA With SVM on [4, 9]"); 

% D Tree
 
t = templateTree();
% Dtree = fitrensemble(TrainX.', TrainY, 'Method', 'LSBOost', 'NumLearningCycles', 260, ...
%      'Learners', t);

Dtree = fitctree(TrainX.', TrainY, "crossval", "on"); 

figure
subplot(2, 1, 1); 
PredictedTestLabels = predict(Dtree.Trained{2}, TestX.');
confusionchart(TestY, PredictedTestLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("D Tree with PCA, Test Set"); 
subplot(2, 1, 2); 
PredictedTestLabels = predict(Dtree.Trained{2}, TrainX.');
confusionchart(TrainY, PredictedTestLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("D Tree with PCA, Traning Set"); 


%% SVM, DTREE, LDA, 0, 1

% SVM ----------------------------------------------------------------------------------------------------------------------------
clc;
[TrainX, TrainY, Projector, ~] = MnistTrain.principalProj(0.5, [1, 0]); 
TestX = Projector*MnistTest.DataStd;
TestY = MnistTest.Labels; 
TestX = MinMaxStd(TestX); 
[TestX, TestY] = SplitByLabels(TestX, TestY, [1, 0]); 

[SVMModel, Loss] = GetSVMModel(TrainX, TrainY);
disp(strcat("SVM Loss ", num2str(Loss))); 
TestPredictedLabels = predict(SVMModel, TestX.'); 

figure; 
confusionchart(TestY, TestPredictedLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("PCA With SVM on [1, 0]"); 

% D Tree
 
t = templateTree();
% Dtree = fitrensemble(TrainX.', TrainY, 'Method', 'LSBOost', 'NumLearningCycles', 260, ...
%      'Learners', t);

Dtree = fitctree(TrainX.', TrainY, "crossval", "on", "MaxNumSplits", 20);

view(Dtree.Trained{1},'Mode','graph');

figure
subplot(2, 1, 1); 
PredictedTestLabels = predict(Dtree.Trained{1}, TestX.');
confusionchart(TestY, PredictedTestLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("D Tree with PCA, Test Set"); 

subplot(2, 1, 2); 
PredictedTestLabels = predict(Dtree.Trained{1}, TrainX.');
confusionchart(TrainY, PredictedTestLabels, 'RowSummary','row-normalized','ColumnSummary','column-normalized'); 
title("D Tree with PCA, Traning Set");



