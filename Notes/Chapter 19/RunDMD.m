function [Lambda, Phi] = RunDMD(X, ranks)
    % dataMatrix: 
    %   Data matrix is assumed to be snapshots of functions stacked into the
    % each column of the matrix. 
    % ranks: 
    %   The ranks we use to describe the proper orthogonal modes for the
    %   functions. 
    % X1 = X(:, 1: end - 1); 
    % X2 = X(:, 2: end); 
    [U, Sigma, V] = svd(X(:, 1: end - 1), "econ");
    U = U(:, 1: ranks); 
    Sigma = Sigma(1: ranks, 1: ranks); 
    V = V(:, 1: ranks);
    Atilde = U'*X(:, 2: end)*V\Sigma;
    [W, Lambda] = eig(Atilde);
    Phi = X(:, 2: end)*V/Sigma*W; 
end

