function [specMatrix, hzvec, t] = CreateSpectrogram(signal, tvec, p, FilterFunc)
    % returns a matrix, which is ready to be displayed via pcolor. 
    % Matrix columns are stacked with frequencies vector. 
    % signal: 
    %   A series of floats that we want to view process. 
    % p: 
    %   An instance of the class: SpectroGram, it contains the parameters
    %   we need for the visualization.
    
    chunkation = p.N;
    filterWidth = p.Width; 
    freqthreshold = p.FreqCutoff;
    hzvec = TVecToHz(tvec);
    dt = (max(tvec) - min(tvec))/chunkation;
    
    
    
    
    tstart = tvec(1);
    for II = 0: chunkation - 1
        F = FilterFunc(tstart + II*dt + dt/2, filterWidth*dt, tvec);
        signalFiltered = F.*signal;
        signalFilteredFFTshifted = fftshift(fft(signalFiltered));
        specMatrix(:, II + 1) = signalFilteredFFTshifted;
        t(II + 1) = tstart + II*dt + dt/2;
    end
    specMatrix = abs(specMatrix)./max(abs(specMatrix), [], 1);
    specMatrix = log(specMatrix + 1);  % Put into log space. 
    
    low = freqthreshold(1); high = freqthreshold(2);
        
    indexStart = find(hzvec > low); indexStart = indexStart(1);
    indexEnd = find(hzvec > high); indexEnd = indexEnd(1);
    hzvec = hzvec(indexStart: indexEnd);
    specMatrix = specMatrix(indexStart: indexEnd, :);
    
    % Assign into the parameter object, state mutated. 
    p.Spec = specMatrix; 
    p.Hz = hzvec; 
    p.Tvec = t;
end