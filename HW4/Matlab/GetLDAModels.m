function [TrainedModel, Loss, TestLabels, PredictedLabels] = GetLDAModels(MnistTrain, MnistTest, labelsFilter, distype)
    % MnistTrain: 
    %   Instance of the class MNISTPCA with mode: 1
    % MnistTest: 
    %   Instance of the class MNISTPCA with mode: 2
    % labels filter: 
    %   The digits you want to train on for the LDA specifically. 
    % distype: 
    %   Tye of discriminant for the model, if not set, then it's linear,
    %   else, you can only set it to quadratic. 

    switch nargin 
        case 2
            labelsFilter = 0:9; 
            distype = "linear"; 
        case 3
            distype = "linear"; 
        case 4
            if isempty(labelsFilter)
                labelsFilter = 0:9; 
            end
    end
    
    [DataTrain, LabelsTrain, Projector, ~] = MnistTrain.principalProj(0.5, labelsFilter); 
    TestData = Projector*MnistTest.DataStd;
    TestLabels = MnistTest.Labels;
    [TestData, TestLabels] = SplitByLabels(TestData, TestLabels, labelsFilter); 

    TrainedModel = fitcdiscr(DataTrain.', LabelsTrain.', "DiscrimType", distype);
    
    % Cross val get predicted test labels. 
    PredictedLabels = predict(TrainedModel, TestData.');
    CVModel = crossval(TrainedModel);
    Loss = kfoldLoss(CVModel);
    disp(strcat("10 digits cross val loss: ", num2str(Loss)));
    
    % Get Training Loss
    TrainingPredictedLabels = predict(TrainedModel, DataTrain.');
    TrainingLoss = sum(TrainingPredictedLabels ~= reshape(LabelsTrain, size(TrainingPredictedLabels)))/length(LabelsTrain); 
    disp(strcat("Loss on Training set: ", num2str(TrainingLoss))); 

end