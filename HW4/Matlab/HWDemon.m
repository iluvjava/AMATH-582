%% Read it. 

MnistTrain = MNISTPCA(1); 
MnistTest = MNISTPCA(2);

%% Plot it. 
MnistTrain.beautifulEnergyPlot();
MnistTrain.figurePlotProj3D();

%% LDA PCA ALL DIGITS
clc;
ldaParams = ParameterPack(0:9, "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams)
%%
ldaParams.visualizeResults("LDA");

%% LDA PCA 4, 5, 7
clc;
ldaParams = ParameterPack([4, 5, 7], "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams)
%%
ldaParams.visualizeResults("LDA");

%% LDA PCA, 4, 9 
clc;
ldaParams = ParameterPack([4, 9], "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams)
%%
ldaParams.visualizeResults("LDA");

%% LDA PCA, 0, 1
clc;
ldaParams = ParameterPack([0, 1], "linear", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams)
%%
ldaParams.visualizeResults("LDA");

%% SVM All Digits 
clc;
SVMParams = ParameterPack(0:9, [], true, 0.5);
SVMParams.KernelFunc = "Gaussian"; 
SVMModelMnist(MnistTrain, MnistTest, SVMParams);
%%
SVMParams.visualizeResults("SVM");

%% SVM PCA 4, 9 SPLIT
clc;
SVMParams = ParameterPack([4, 9], [], true, 0.5);
SVMParams.KernelFunc = "Gaussian"; 
SVMModelMnist(MnistTrain, MnistTest, SVMParams);
%%
SVMParams.visualizeResults("SVM");

%% SVM PCA 0, 1 SPLIT
clc;
SVMParams = ParameterPack([0, 1], [], true, 0.5);
SVMParams.KernelFunc = "Gaussian"; 
SVMModelMnist(MnistTrain, MnistTest, SVMParams);
%%
SVMParams.visualizeResults("SVM");

%% TREE PCA 4, 9
clc;
TreeParams = ParameterPack([4, 9], [], true, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
%%
TreeParams.visualizeResults("Dtree");

%% TREE PCA 0, 1
clc;
TreeParams = ParameterPack([0, 1], [], true, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
%%
TreeParams.visualizeResults("Dtree");


%% EXTRA MODELS THAT ARE NOT REQUIRED FOR THE HW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TREE PCA ALL DIGITS
clc;
TreeParams = ParameterPack(0:9, [], true, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
%%
TreeParams.visualizeResults("Dtree");

%% QDA PCA ALL DIGITS
clc;
ldaParams = ParameterPack(0:9, "quadratic", true, 0.5);
LDAModelMnist(MnistTrain, MnistTest, ldaParams)
%%
ldaParams.visualizeResults("LDA");

%% TREE ALL DIGITS
clc;
TreeParams = ParameterPack(0:9, [], false, 0.5);
TreeMnist(MnistTrain, MnistTest, TreeParams);
%%
TreeParams.visualizeResults("Dtree");

%% TREE ALL DIGITS LOW PCA
clc;
TreeParams = ParameterPack(0:9, [], true, 0.3);
TreeMnist(MnistTrain, MnistTest, TreeParams);
%%
TreeParams.visualizeResults("Dtree");


