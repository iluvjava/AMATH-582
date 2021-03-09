%% Read it. 
MnistTrain = MNISTPCA(1); 
MnistTest = MNISTPCA(2);

%% Plot it. 
MnistTrain.beautifulEnergyPlot();
saveas(gcf, "singular-value-spectrum", "png");
MnistTrain.figurePlotProj3D();
saveas(gcf, "3-mode-projection", "png"); 

%% LDA PCA ALL DIGITS
clc;
ldaParams = ParameterPack(0:9, "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams);
ldaParams.visualizeResults("LDA");
saveas(gcf, "conmat-lda-alldigits-with-pca", "png"); 

%% LDA PCA 4, 5, 7
clc;
ldaParams = ParameterPack([4, 5, 7], "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams);
ldaParams.visualizeResults("LDA");
saveas(gcf, "conmat-lda-digits-with-pca", "png");

%% LDA PCA, 4, 9 
clc;
ldaParams = ParameterPack([4, 9], "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams);
ldaParams.visualizeResults("LDA");
saveas(gcf, "conmat-lda-2-hardests-digits-pca", "png"); 

%% LDA PCA, 0, 1
clc;
ldaParams = ParameterPack([0, 1], "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams);
ldaParams.visualizeResults("LDA");
saveas(gcf, "conmat-lda-2-easiest-digits-pca", "png");

%% SVM All Digits 
clc;
SVMParams = ParameterPack(0:9, [], true, 0.5);
SVMParams.KernelFunc = "Gaussian"; 
SVMModelMnist(MnistTrain, MnistTest, SVMParams);
SVMParams.visualizeResults("SVM");
saveas(gcf, "conmat-svm-alldigits-pca", "png");

%% SVM PCA 4, 9 SPLIT
clc;
SVMParams = ParameterPack([4, 9], [], true, 0.5);
SVMParams.KernelFunc = "Gaussian"; 
SVMModelMnist(MnistTrain, MnistTest, SVMParams);
SVMParams.visualizeResults("SVM");
saveas(gcf, "conmat-svm-hardest-2-digits-pca", "png"); 

%% SVM PCA 0, 1 SPLIT
clc;
SVMParams = ParameterPack([0, 1], [], true, 0.5);
SVMParams.KernelFunc = "Gaussian"; 
SVMModelMnist(MnistTrain, MnistTest, SVMParams);
SVMParams.visualizeResults("SVM");
saveas(gcf, "conmat-svm-easiest-2-digits-pca", "png"); 

%% TREE PCA 4, 9
clc;
TreeParams = ParameterPack([4, 9], [], true, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
TreeParams.visualizeResults("Dtree");
saveas(gcf, "conmat-dtree-hardest-2-digits", "png");

%% TREE PCA 0, 1
clc;
TreeParams = ParameterPack([0, 1], [], true, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
TreeParams.visualizeResults("Dtree");
saveas(gcf, "conmat-dtree-easiest-2-digits", "png"); 

%% EXTRA MODELS THAT ARE NOT REQUIRED FOR THE HW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREE PCA ALL DIGITS
clc;
TreeParams = ParameterPack(0:9, [], true, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
TreeParams.visualizeResults("Dtree");
saveas(gcf, "extra-tree-alldigits-pca", "png"); 

%% QDA PCA ALL DIGITS
clc;
ldaParams = ParameterPack(0:9, "quadratic", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams)
ldaParams.visualizeResults("LDA");
saveas(gcf, "extra-qda-alldigits-pca", "png"); 

%% TREE ALL DIGITS
clc;
TreeParams = ParameterPack(0:9, [], false, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
TreeParams.visualizeResults("Dtree");
saveas(gcf, "extra-dtree-nopca-alldigits", "png"); 

%% TREE ALL DIGITS LOW PCA 0.3
clc;
TreeParams = ParameterPack(0:9, [], true, 0.3);
TreeMnist(MnistTrain, MnistTest, TreeParams);
TreeParams.visualizeResults("Dtree");
saveas(gcf, "extra-dtree-lowpca-alldigits", "png");

%% SVM All DIGIT HIGH PCA 0.8
clc;
SVMParams = ParameterPack(0:9, [], true, 0.8);
SVMParams.KernelFunc = "Gaussian"; 
SVMModelMnist(MnistTrain, MnistTest, SVMParams);
SVMParams.visualizeResults("SVM");
saveas(gcf, "svm-alldigits-gaussian", "png"); v

