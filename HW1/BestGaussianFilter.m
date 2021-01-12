function Filter = BestGaussianFilter(params, peakFrequenciesIndices)
    %   Function figure out the best Guassian filter given the indices of the
    %   frequencies that is peaking in the Fourier Domain. 
    % params: 
    %   An instance of the class: ProbemParameters. 
    % preakFrequenciesIndices: 
    %   An array of indices indicating the index of the preaking
    %   frequencies in the frequencies space. 
    % Return: 
    %   A filter for the freq domain, in the shape of [1, 64, 64, 64] 
    
    Kx = params.Kx; 
    Ky = params.Ky; 
    Kz = params.Kz;
    for II = 1: length(peakFrequenciesIndices)
        F = peakFrequenciesIndices(II);
        Coords(:,II) = [Kx(F), Ky(F), Kz(F)];
    end
    Center = mean(Coords, 2);
    Variance = [0.5, 0.5, 0.5];
    GaussianFilter = @(x, y, z, vx, vy, vz)... 
        exp(-(vx*(x - Center(1)).^2 + vy*(y - Center(2)).^2 + vz*(z - Center(3)).^2));
    Filter = GaussianFilter(params.Kx, params.Ky, params.Kz, Variance(1), Variance(2), Variance(3));
end
