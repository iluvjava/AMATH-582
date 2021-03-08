function [X, X1, TestX, Y, Y1, TestY] = PrepareData(mnistTraining, mnistTesting, params)
    % Getting the testing data, training data for the MNIST data set. 
    TrainX = mnistTraining.DataStd;
    TrainY = mnistTesting.Labels;
    TestX = mnistTesting.DataStd;
    TestY = mnistTesting.Labels;
    [TestX, TestY, ~] = SplitByLabels(TestX, TestY, params.SplitByLabels); 
    [TrainX, TrainY, ~] = SplitByLabels(TrainX, TrainY, params.SplitByLabels); 
    
    % If PCA, then project the data onto the PCA components; 
    if params.PCAOnOff 
        [TrainX, TrainY, Proj] = mnistTraining.principalProj(params.PCAEnergyLevel, params.SplitByLabels); 
        TestX = Proj*TestX; 
    end
    
    % minmax all features on test and training data. 
    TrainX = MinMaxStd(TrainX); 
    TestX = MinMaxStd(TestX); 
    params.TestX = TestX; 
    params.TestY = TestY;
    
    % Split the training into training and validation set. 
    [X, X1, Y, Y1] = TrainTestSplit(TrainX, TrainY); 
    params.TrainX = X; 
    params.TrainY = Y; 
    params.ValX = X1; 
    params.ValY = Y1; 
end

