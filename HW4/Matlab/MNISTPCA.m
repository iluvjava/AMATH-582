classdef MNISTPCA < handle
    % This class handle everything related PCA and PCA dimensionality
    % reduction. 
    %   1. Store that original MNIST data matrix. Separated into test and
    %   validation sets. 
    %   2. Store the SVD decomposition 
    %   3. Produce beautiful plots. 
    %   4. Peoject onto the subspace or return data traning data/test data
    %   
    %   in the subspace projected onto. 
    
    properties
        
        Data; 
        DataStd; 
        Labels;
        U; Sigma; V; 
        
    end
    
    methods
        function this = MNISTPCA(n)
            % Make a PCA related stuff, on training set, or the test set. 
            
            switch  n
                case 1
                    [images, labels] = mnist_parse... 
                        ('data\train-images.idx3-ubyte', 'data\train-labels.idx1-ubyte');
                case 2
                    [images, labels] = mnist_parse... 
                        ('data\t10k-images.idx3-ubyte', 'data\t10k-labels.idx1-ubyte');
                otherwise
                    error("Unknown Mode");
            end
            
            FlattendImagesStd = ImageNormalize(images);
            
            this.Data = images; 
            this.DataStd = FlattendImagesStd;
            this.Labels = labels;
            
            [U, Sigma, V] = svd(FlattendImagesStd, "econ");
            
            this.U = U; this.Sigma = Sigma; this.V = V;
            
        end
        
        function null = beautifulEnergyPlot(this)
            
            S = this.Sigma;
            
            figure;
            CulmulativeSigma = cumsum(diag(S))./sum(S, "all");
            SingularValues = diag(S)./max(diag(S));

            subplot(2, 1, 2);
            bar(CulmulativeSigma);
            Energy98 = find(CulmulativeSigma > 0.98, 1);
            Energy95 = find(CulmulativeSigma > 0.95, 1);
            Energy90 = find(CulmulativeSigma > 0.90, 1);
            xline(Energy98, '-', strcat("98%: r=", num2str(Energy98)),... 
                "linewidth", 2, "fontsize", 12);
            xline(Energy95, '-', strcat("95%: r=", num2str(Energy95)),...
                "linewidth", 2, "fontsize", 12);
            xline(Energy90, '-', strcat("90%: r=", num2str(Energy90)),...
                "linewidth", 2, "fontsize", 12);
            title("Culmulative Energy");
            xlabel("Ranks");
            ylabel("Energy");

            subplot(2, 1, 1);
            bar(SingularValues(1:Energy98)); 
            title("Singular Values Spectrum");
            xlabel("Ranks");
            ylabel("Relative Size to max");
            
            null = 0;
            
        end
        
        function null = figurePlotProj3D(this)
            
            Sig = this.Sigma; 
            labels = this.Labels;
            V = this.V; 
            U = this.U;
            ModesIdx = [1, 5, 8];
            
            Projection = Sig*V.';
            Projection = Projection(ModesIdx, :);
            
            figure;
            for Label = 0:9
                disp(Label)
                PointsWithLabel = Projection(:, labels == Label);
                X = PointsWithLabel(1, :); 
                Y = PointsWithLabel(2, :);
                Z = PointsWithLabel(3, :);
                Color = rand(1, 3);
                scatter3(X, Y, Z, 6,"MarkerFaceColor", Color, "MarkerEdgeColor", Color);
                hold on;
            end
            legend(["0", "1", "2", "3", "4", "5", "6", "7", "8","9"]);
            title("Principal Compoenent Projection Onto: 1, 5, 8"); 
            xlabel("Principal Mode: 1"); 
            ylabel("Principal Mode: 5");
            zlabel("Principal Mode: 8"); 
            
            null = 0;
        end
        
        function [DataProj, Labels, Projector, FilterIdx] = principalProj(this, principalEnergy, group)
            
            switch nargin 
                case 1
                    principalEnergy = 0.9;
                    group = 0:9;
                case 2
                    group = 0:9;
                case 3
                    
                otherwise
                    error("bleh")
            end
            
            EnergyS = cumsum(diag(this.Sigma))./sum(this.Sigma, "all");
            LastModeIdx = find(EnergyS > principalEnergy, 1);
            DataProj = this.Sigma*this.V.';
            DataProj = DataProj(1: LastModeIdx, :);
            [DataProj, Labels, FilterIdx] = SplitByLabels(DataProj, this.Labels, group);
            Projector = this.U.';
            Projector = Projector(1: LastModeIdx, :);
            
        end
        
    end
end

