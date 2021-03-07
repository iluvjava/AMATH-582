function [SVMModel, Loss] = GetSVMModel(data, labels)
    % Given the data and the labels, this thing is going to standardize the
    % data and then train a SVM model, with the parameters that I think is
    % the best for the HW. 
    % Data: 
    %   Each row is one of the features for one sample, and each column
    %   Represents all the features for one sample. 
    % Labels: 
    %   This is a vector representing all the labels for multi-class
    %   classifications. 
    data = MinMaxStd(data); 
    DataLength = size(data, 2);
    Sep = floor(DataLength*0.9); 
    DataTrain = data(:, 1: Sep);
    LabelsTrain = labels(1: Sep); 
    DataVerify = data(:, Sep + 1: end); 
    LabelVerify = labels(Sep + 1:end);
    ModelTemplate = templateSVM("KernelFunction", "gaussian");
    SVMModel = fitcecoc(DataTrain.', LabelsTrain, "Learners", ModelTemplate);
    PredictedLabels = predict(SVMModel, DataVerify.');
    Loss = sum(PredictedLabels ~= reshape(LabelVerify, size(PredictedLabels)))./length(LabelVerify);
end

