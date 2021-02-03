classdef SpectroGram < handle
    % This is a class that models the spectrogram, and parameters for the
    % Gabor filtering. 
    % 
    % It will stores the: 
    %   1. Frequencies Axis. 
    %   2. The spectrogram Matrix. 
    %   3. The Time vector. 
    %   4. Spatial discretization. 
    %   5. Gobar filter width. 
    
    properties
        Hz;     % The frequencies vector, for the spectrogram
        Tvec;   % The time domain vector, for the spectrogram
        Spec;   % The Spectrogram matrix.
        
        N;      % The spetial domian discretization of the signal. 
        Width;  % The width of the gabor filter. 
        
        FreqCutoff; 
                % The frequencies that we are going to retain for the spec,
                % in the form of [low, high].
        PeakingFreq;
                % An vector representing the frequencies that has the max
                % magnitude.
        TonicOffSet;
                % How many semitone above/befow from the given tonic key.
    end
    
    methods
        function this = SpectroGram(chunkcation, filterwidth, freqcutoff)
            if length(freqcutoff) ~= 2 || freqcutoff(2) <= freqcutoff(1)
               error("Not valid input. ") 
            end
            this.N = chunkcation;
            this.Width = filterwidth;
            this.FreqCutoff = freqcutoff;
        end
        
    end
end

