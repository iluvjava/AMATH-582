function params = TreeMnist(mnistTraining, mnistTesting, params)



    % Train the model on the training set. 
    % t = templateTree();
    % Dtree = fitrensemble(TrainX.', TrainY, 'Method', 'LSBOost', 'NumLearningCycles', 260, ...
    %      'Learners', t);
    
    [X, X1, TestX, Y, Y1, ~] = PrepareData(mnistTraining, mnistTesting, params);
    
    TrainedModel = fitctree(X.', Y);
    params.TrainedModel = TrainedModel; 
    
    TrainPre = predict(TrainedModel, X.'); 
    params.PredictedTrainingLabels = TrainPre; 
    
    ValPre = predict(TrainedModel, X1.'); 
    params.PredictedValidateLabels = ValPre; 
    params.CrossValLoss = sum(ValPre ~= reshape(Y1, size(ValPre)))/length(ValPre); 
    
    % Predict on the test set 
    TestPre = predict(TrainedModel, TestX.'); 
    params.PredictedTestlabels = TestPre; 
    
end

