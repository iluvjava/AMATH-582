function [specMatrix, hzvec, t] = CreateSpectrogram(signal, tvec, sp, FilterFunc)
    % returns a matrix, which is ready to be displayed via pcolor. 
    % Matrix columns are stacked with frequencies vector. 
    % signal: 
    %   A series of floats that we want to view process. 
    % p: 
    %   An instance of the class: SpectroGram, it contains the parameters
    %   we need for the visualization.
    
    chunkation = sp.N;
    filterWidth = sp.Width;
    freqthreshold = sp.FreqCutoff;
    hzvec = TVecToHz(tvec);
    dt = (max(tvec) - min(tvec))/chunkation;
    
    low = freqthreshold(1); high = freqthreshold(2);
    indexStart = find(hzvec > low); indexStart = indexStart(1);
    indexEnd = find(hzvec > high); indexEnd = indexEnd(1);
    
    tstart = tvec(1);
    for II = 0: chunkation - 1
        F = FilterFunc(tstart + II*dt + dt/2, filterWidth*dt, tvec);
        signalFiltered = F.*signal;
        signalFilteredFFTshifted = fftshift(fft(signalFiltered));
        specMatrix(:, II + 1) = signalFilteredFFTshifted(indexStart: indexEnd);
        t(II + 1) = tstart + II*dt + dt/2;
    end
    specMatrix = abs(specMatrix)./max(abs(specMatrix), [], 1);
    specMatrix = log(specMatrix + 1);  % Put into log space.
    
    % specMatrix = specMatrix(indexStart: indexEnd, :);
    hzvec = hzvec(indexStart: indexEnd);
    
    % Assign into the parameter object, state mutated. 
    sp.Spec = specMatrix; 
    sp.Hz = hzvec; 
    sp.Tvec = t;
end