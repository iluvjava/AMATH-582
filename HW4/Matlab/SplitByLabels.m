function [Data, Labels, FilteringIdx] = SplitByLabels(data, labels, splitby)
    % data is assume to be that each column is the sample, and each row corresponds to a certain feature. 
    labels = labels.';
    BoolArray = zeros(size(labels)); 
    for L = splitby
       BoolArray = BoolArray + (labels == L);
    end
    BoolArray = boolean(BoolArray);
    Labels = labels(:, BoolArray);
    Data = data(:, BoolArray);
    FilteringIdx = find(BoolArray == 1);
end
