classdef ParameterPack < handle
    % This class is going to contain all the things that is related to
    % graining, linear or quadratic LDA models. 
    
    
    properties
        
        DisType;                       % Basic training settings
        PCAOnOff;
        SplitByLabels;
        PCAEnergyLevel;
        
        KernelFunc;                    % SVM specific settings. 
        
        
        TrainX; TrainY;                % Basic training data. 
        TestX, TestY;
        ValX, ValY; 

       
        TrainedModel;                  % Results after the training. 
        CrossValLoss; 
        PredictedValidateLabels;
        PredictedTestlabels; 
        PredictedTrainingLabels;
        
    end
    
    methods
        function this = ParameterPack(splitByLabels, mode, pcaOnOff, pcaEnergy)
            % splitByLabels: The digits that we want the model to
            % distinguish. 
            % SplitBylabels: The digits you want to filter out and train
            % the MNIST model for. 
            % Mode: 
            % The discriminant type you want to use to train the data. 
            this.SplitByLabels = splitByLabels; 
            this.DisType = mode;
            this.PCAOnOff = pcaOnOff;
            this.PCAEnergyLevel = pcaEnergy; 
        end
        
        function this = visualizeResults(this, modelName)
            % Visualize the result of the trained model on all 3 data set,
            % and plot them, onto one figure. 
            figure('Position', [0, 0, 2000 600]); 
            subplot(1, 3, 1);
            confusionchart(this.PredictedTrainingLabels, this.TrainY, ... 
                'RowSummary','row-normalized','ColumnSummary','column-normalized');
            title(strcat("Train Set ", modelName));
            
            subplot(1, 3, 2)
            confusionchart(this.PredictedValidateLabels, this.ValY, ... 
                'RowSummary','row-normalized','ColumnSummary','column-normalized');
            title(strcat("Val Set ", modelName)); 
            
            subplot(1, 3, 3); 
            confusionchart(this.PredictedTestlabels, this.TestY, ... 
                    'RowSummary','row-normalized','ColumnSummary','column-normalized');
            title(strcat("Test Set ", modelName)); 
            
        end
        
       
    end
end

