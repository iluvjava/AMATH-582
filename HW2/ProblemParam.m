classdef ProblemParam < handle
    % All parameters regarding the problem will be packed here. 
    % This class will cut the audio data into chunks. 
    properties
        SampleRate;  % The sample rate associated with the files, floats/sec
        AudioData;   % Audio data as a series of floats. 
        TotalTime;   % How many seconds does the audio sample have in total. 
        ChunkSize;   % How many floats per chunk? 
        ChunkTime;   % How many second does one chunk of data span
        TotalChunks; % total number of chunks on the signal
        BPM;         % Beats Per minutes OR Bars per minites. (Depending on caller's input)
        
        TimeVec;     % The Time vector for the whole auidio data. 
        Hz;          % The frequencies vector for the whole audio data. 
    end
    
    methods
        function this = ProblemParam(bpm, fileName)
            [this.AudioData, this.SampleRate] = audioread(fileName); 
            this.ChunkSize = (60/bpm)*this.SampleRate;
            this.BPM = bpm;
            TotalTime = length(this.AudioData)/this.SampleRate; 
            this.TotalTime = TotalTime; 
            ChunkTime = length(this.AudioData)/this.ChunkSize;
            this.ChunkTime = ChunkTime;
            this.TotalChunks = floor(length(this.AudioData)/this.ChunkSize);
        end
        
        
        function [chunk, timevec, hz]= getChunk(this, i)
           % chunk: float vector, audio data. 
           % timevec: spatial time domain vector. 
           
           i     = i - 1; 
           Start = i*this.ChunkSize + 1; 
           Start = floor(Start);
           End   = (i + 1)*this.ChunkSize; 
           End   = min(length(this.AudioData), ceil(End));
           chunk = this.AudioData(Start: End);
           chunk = chunk.';
           if nargout >= 2
               Timespan = length(chunk)*(1/this.SampleRate);
               timevec = linspace(-Timespan/2, Timespan/2, length(chunk) + 1);
               timevec = timevec(1: end - 1);
           end
           if nargout == 3
                n = length(chunk);
                L = Timespan;
                if mod(n, 2) == 0
                    hz = (2*pi/L)*[0: n/2 - 1, -n/2: -1];
                else
                    hz = (2*pi/L)*[0, 1:(n - 1)/2, -(n - 1)/2:-1];
                end
                hz = hz/(2*pi);
           end           
           
        end
        
        function n = totalChunk(this)
            N = length(this.AudioData); 
            n = N/this.ChunkSize; 
        end
        
    end
end
