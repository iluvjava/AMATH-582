function params = LDAModelMnist(mnistTraining, mnistTesting, params)
    % What it does: 
    %   Function us a part of the data to train the LDA model, and then use
    %   the rest to validate the model, and then it will predict with the
    %   model on the: Training set, the test set, and the  validation set. 
    % 
    % mnistTraining: 
    %   An instance of the class LDAModelMnist, it has to be a training
    %   instace. 
    % mnistTesting
    %   An instacoe of the class LDAModeMnist, it has to be a testing
    %   instance. 
    % ldaParams: 
    %   An instance f the class LDAParameters. Which is stored for all the
    %   parameters that are relatvent to the training of the model. 
    
    [X, X1, TestX, Y, Y1, ~] = PrepareData(mnistTraining, mnistTesting, params);
    
    % Train the model on the 90% of the data and the labels: 
    TrainedModel = fitcdiscr(X.', Y.', "DiscrimType", params.DisType);
    params.TrainedModel = TrainedModel; 
    
    % Get the predicted labels on all the trainning set. 
    params.PredictedTrainingLabels = predict(TrainedModel, X.'); 
    
    % Validate on the validation set, store the results for the
    % validation set. 
    PredictedValidateLabels = predict(TrainedModel, X1.'); 
    params.PredictedValidateLabels = PredictedValidateLabels;
    params.CrossValLoss = sum(PredictedValidateLabels ~= reshape(Y1, size(PredictedValidateLabels)))... 
        /length(PredictedValidateLabels); 
    
    % Test on the test set, store the results for the test set. 
    params.PredictedTestlabels = predict(TrainedModel, TestX.'); 
    
    
    
end

