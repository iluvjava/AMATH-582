function [tonicOffSet, peakingFreq] = PeakingFrequencies(spectroGram, tonickeyFreq)
    %  This function finds the tonic offset vector and the peaking
    %  frequency vector from trhe given instance of SpectroGram.
    % 
    
    SpectroMatrix = spectroGram.Spec;
    SpecHz = spectroGram.Hz;
    for II = 1:size(SpectroMatrix, 2)
       FreqDomain = SpectroMatrix(:, II);
       [~, MaxIndex] = max(abs(FreqDomain));
       peakingFreq(II) = SpecHz(MaxIndex);
    end
    tonicOffSet = round(12*(log2(peakingFreq) - log2(tonickeyFreq)));
    
    spectroGram.PeakingFreq = peakingFreq;
    spectroGram.TonicOffSet = tonicOffSet;
end

