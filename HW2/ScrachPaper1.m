%% GIVEN STARTER CODE

figure(1)
% [y, Fs] = audioread("GNR.m4a"); 
[y, Fs] = audioread("GNR.m4a"); 
tr.gnr  = length(y)/Fs;
bar((1:length(y))/Fs, y); 
xlabel("Time [sec]"); 
ylabel("Amplitude"); 
title("Stween child O 'Mine'"); 
p8 = audioplayer(y, Fs); 
playblocking(p8);

% Y is the double vector representing the waveform and the Fs is the sample
% rate of the wave. Sample rate: Floats per second, its about 123 bpm
% Assume 4/4, how many beats per second? 
% 123/60 == 2.05
% How many seconds per beat? 
% 1/2.05 == 0.4878
% If cut it into sections of 0.4878, each should corresponds to one beat. 
% How many floats per 0.4878 second? 
% 4800*0.4878 == 2341.44
% How do we quantize signal into 2341.44 floats per chunks such that each
% chunks are exactly one beat in the music score? 
% start: floor(i*chucksize), end: ceil((i+1)*chuncksize)

% ROUTINE SUMMARIZATION: 
bmp = 123; SampleRate = 4800;
Chunksize = (60/bmp)*SampleRate;


%% Testing the problem parameter parts. 
p = ProblemParam(127/4, "GNR.m4a");
for i = 1: p.TotalChunks
    [chunk, t]= p.getChunk(i);
    % playblocking(audioplayer(chunk, p.SampleRate));
    plot(t, chunk);
    pause(1);
end


%% FILTER OUT ALL HIGH FREQUENCIES AND RECONSTRUCT IT. 
CHUNK = 2; 

p = ProblemParam(126/16, "GNR.m4a");
[filtered, ~, hz] = OctaveFilter(p, CHUNK, 220, 3);
[original, t] = p.getChunk(CHUNK);
play(p, filtered/max(abs(filtered)));

figure(1)
subplot(2, 1, 1)
subplot(3, 1, 1); plot(t, filtered/max(abs(filtered)));
subplot(3, 1, 2); plot(t, original/max(abs(original)));
filteredHz = fftshift(abs(fft(filtered)));
subplot(3, 1, 3); plot(fftshift(hz), normalize(filteredHz));

figure(2)
[m, hzvec, t] = spectrogram(t, original, 64, 3, 800);
pcolor(t, hzvec, m); shading interp; title("first 4 bars"); 


function F = GFilter(center, w, tspan)
    f = @(x) exp(-(x - center).^2/(w/4)^2);
    F = f(tspan);
end

function v = normalize(vec)
    v = vec/max(abs(vec), [], "all");
end

function null = play(p, audio)
    playblocking(audioplayer(audio, p.SampleRate));
    null = 0;
end

function [filtered, tspan, hz] = OctaveFilter(p, i, rootnote, octave)
    [chunk, tspan, hz] = p.getChunk(i);
    chunkFFT = fft(chunk);
    kFilter = (abs(hz) < rootnote*(2^octave + 1)).*(abs(hz) > rootnote);
    chunkFFTFiltered = kFilter.*chunkFFT; 
    filtered = real(ifft(chunkFFTFiltered));
end

function [specMatrix, hzvec, t] = spectrogram(tvec, ...
                    signal, chunkation, filterWidth, freqthreshold)
    % returns a matrix, which is ready to be displayed via pcolor. 
    % Matrix columns are stacked with frequencies vector. 
    % signal: 
    %       the signal to display
    % chunkation: 
    %       Number of chunks to divide the signal into 
    % filterWidth: 
    %       filterwidth relative to the chunkation width
    dt = (max(tvec) - min(tvec))/chunkation;
    hzvec = tvecToHz(tvec);
    tstart = tvec(1);
    for II = 0: chunkation - 1
        F = GFilter(tstart + II*dt + dt/2, filterWidth*dt, tvec);
        signalFiltered = F.*signal;
        signalFilteredFFTshifted = fftshift(fft(signalFiltered));
        specMatrix(:, II + 1) = signalFilteredFFTshifted;
        t(II + 1) = tstart + II*dt + dt/2;
    end
    specMatrix = abs(specMatrix)/max(abs(specMatrix), [], "all");
    specMatrix = log(specMatrix + 1);
    
    if nargin >= 5
        low = 0; high = 0; 

        switch(length(freqthreshold))
            case 1
                high = freqthreshold; 
            case 2
                low = freqthreshold(1); 
                high = freqthreshold(2);
        end
        
        indexStart = find(hzvec > low); indexStart = indexStart(1);
        indexEnd = find(hzvec > high); indexEnd = indexEnd(1);
        hzvec = hzvec(indexStart: indexEnd);
        specMatrix = specMatrix(indexStart: indexEnd, :);
    end
    
end

function hz = tvecToHz(tvec)
    % Given a time domain, return a shifted frequencies domain. 
    n = length(tvec);
    L = tvec(end) - tvec(1);
    if mod(n, 2) == 0
        hz = (2*pi/L)*[0: n/2 - 1, -n/2: -1];
    else
        hz = (2*pi/L)*[0, 1:(n - 1)/2, -(n - 1)/2:-1];
    end
    hz = hz/(2*pi);
    hz = fftshift(hz);
end



