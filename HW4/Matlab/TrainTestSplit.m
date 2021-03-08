function [X, X1, Y, Y1] = TrainTestSplit(data, label)
    % Permutes the data, 90% for training, and 10% for validation. 
    Permvec = randperm(length(label));
    Sep = floor(0.9*length(label));
    PermvecTrain = Permvec(1: Sep); 
    PermvecValidate = Permvec(Sep + 1: end);
    X = data(:, PermvecTrain);
    Y = label(PermvecTrain);
    X1 = data(:, PermvecValidate); 
    Y1 = label(PermvecValidate); 
end

