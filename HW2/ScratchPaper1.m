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
bmp = 123; SampleRate = 48000;
Chunksize = (60/bmp)*SampleRate;


%% Testing the problem parameter parts. 
p = ProblemParam(127/4, "Floyd.m4a");
for i = 1: p.TotalChunks
    [chunk, t]= p.getChunk(i);
    % playblocking(audioplayer(chunk, p.SampleRate));
    plot(t, chunk);
    pause(1);
end


%% FILTER OUT ALL HIGH FREQUENCIES AND RECONSTRUCT IT. 
CHUNK = 1; 

p = ProblemParam(126/16, "GNR.m4a");
[filtered, ~, hz] = OctaveFilter(p, CHUNK, 220, 3);
[original, t] = p.getChunk(CHUNK);
Play(p, filtered/max(abs(filtered)));

figure(1)
subplot(2, 1, 1)
subplot(3, 1, 1); plot(t, filtered/max(abs(filtered)));
subplot(3, 1, 2); plot(t, original/max(abs(original)));
filteredHz = fftshift(abs(fft(filtered)));
subplot(3, 1, 3); plot(fftshift(hz), Normalize(filteredHz));

figure(2)
[m, hzvec, t] = SpectroGram(t, original, 64, 2, 800);
pcolor(t, hzvec, m); shading interp; title("first 4 bars"); 


%% GNR PRODUCE SPECTROGRAM
%  Preparing parameters.
CHUNK = 1;
p = ProblemParam(126/8, "GNR.m4a");

%%
% -------------------------------------------------------------------------
% 1. Construct all parameters needed for the music. 
% 2. Filter out the frequencies for the instrument. 
% -------------------------------------------------------------------------

[filtered, ~, hz] = OctaveFilter(p, CHUNK, 220, 3);
[original, t] = p.getChunk(CHUNK);
Play(p, CHUNK);

%%
% -------------------------------------------------------------------------
% 1. Plot the filtered sound waves.
% 2. Plot the fft of filtered sound wave.
% 3. Plot the original sound waves. 
% 4. Plot the fft of the original sound wave. 
% -------------------------------------------------------------------------
figure(1)
subplot(4, 1, 1); plot(t, Normalize(filtered));
filteredHz = fftshift(abs(fft(filtered)));
subplot(4, 1, 4); plot(fftshift(hz), Normalize(filteredHz));

subplot(4, 1, 3); plot(t, Normalize(original));
originalHz = fftshift(abs(fft(original)));
subplot(4, 1, 2); plot(fftshift(hz), Normalize(originalHz));

%%
% -------------------------------------------------------------------------
% 1. Visualizing the spectrogram.
% -------------------------------------------------------------------------
sp = SpectroGram(16, 2, [200 800]);
[m, hzvec, spectroTvec] = CreateSpectrogram(filtered, t, sp);
figure(2)
pcolor(spectroTvec, hzvec, m); shading interp; title("first 4 bars"); 


%%
% -------------------------------------------------------------------------
% Getting the keys from the spectro analysis.
% 1. Trim off the repreated peaking frequencies. 
% -------------------------------------------------------------------------
[tonicOffSet, peakingFreq] = PeakingFrequencies(sp, 261.63);
notes = [];
for II = 1: length(tonicOffSet)
    
   if length(notes) == 0
       notes(1) = tonicOffSet(II);
   else
       if notes(end) == tonicOffSet(II)
           continue;
       end
       notes(end + 1) = tonicOffSet(II);
   end
   
end
figure(3); 
plot(notes, "o");
title("Unique Tonic Offsets"); xlabel("index"); ylabel("tonic offset");


