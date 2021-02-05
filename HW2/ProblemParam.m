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
        
        
        function [chunk, timevec, hz] = getChunk(this, i)
            % Get chunks according to BPM, one chunk is one beat. 
            % chunk:     
            %    float row vector, sliced from audio data. 
            % timevec: 
            %    spatial time domain vector, start with zero. 
            % hz: 
            %    The frequencies vector, not shifted. 

            i     = i - 1; 
            Start = i*this.ChunkSize + 1; 
            Start = floor(Start);
            End   = (i + 1)*this.ChunkSize; 
            End   = min(length(this.AudioData), ceil(End));
            chunk = this.AudioData(Start: End);
            chunk = chunk.';
            if nargout >= 2
               Timespan = length(chunk)*(1/this.SampleRate);
               timevec  = linspace(0, Timespan, length(chunk) + 1);
               timevec  = timevec(1: end - 1);
            end
            hz = TVecToHz(timevec);
        end
        
        function [chunk, timevec, hz] = slice(this, i, total)
            % Cut the signal into a total amount of time and then slice out
            % the ith one only. 
            chunkSize = round(length(this.AudioData)/total);
            timeSpan  = chunkSize*(1/this.SampleRate);
            timevec   = linspace(0, timeSpan, chunkSize + 1); 
            timevec   = timevec(1: end - 1);
            hz        = TVecToHz(timevec);
            chunk     = this.AudioData((i - 1)*chunkSize + 1: ... 
                min(i*chunkSize, length(this.AudioData)));
            chunk     = chunk.';
        end
        
        function [chunk, timevec, hz] = timeSlice(this, startT, endT)
            startIndex = ceil(startT*this.SampleRate);
            endIndex  = round(endT*this.SampleRate);
            chunkSize = endIndex - startIndex + 1; 
            timevec   = linspace(startT, endT, chunkSize + 1);
            timevec   = timevec(1: end - 1);
            hz        = TVecToHz(timevec);
            chunk     = this.AudioData(startIndex: min(endIndex, length(this.AudioData)));
            chunk     = chunk';
        end
        
        function n = totalChunk(this)
            N = length(this.AudioData); 
            n = N/this.ChunkSize; 
        end
        
    end
end

