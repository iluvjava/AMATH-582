function params = SVMModelMnist(mnistTraining, mnistTesting, params)
    % This function split the trainig of the MNIST data into train and
    % validation set, and then it standardize the data using it to tran a
    % SVM model, and then it predict with the SVM model on all the data
    % set. 
    %   The kernel function is going to be gaussian. 
    % mnistTraing: 
    %   An instance of the MNISTPCA class, has to be training instance 
    % mnistTesting: 
    %   An instance of the MNISTPCA class, has to be a test instance. 
    % ldaParams: 
    %   An instance of the ParameterPack class. 
    
    [X, X1, TestX, Y, Y1, ~] = PrepareData(mnistTraining, mnistTesting, params);
    
    % Train the data on the training set: 
    ModelTemplate = templateSVM("KernelFunction", params.KernelFunc);
    SVMModel = fitcecoc(X.', Y, "Learners", ModelTemplate);
    params.TrainedModel = SVMModel;
    
    % predict on the training set 
    TrainPre = predict(SVMModel, X.');
    params.PredictedTrainingLabels = TrainPre; 
    
    % predict on the val set
    ValPre = predict(SVMModel, X1.'); 
    params.PredictedValidateLabels = ValPre; 
    params.CrossValLoss = sum(ValPre ~= reshape(Y1, size(ValPre)))/length(ValPre); 
    
    % Predict on the test set 
    TestPre = predict(SVMModel, TestX.'); 
    params.PredictedTestlabels = TestPre; 
    
end

