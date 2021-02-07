%% GNR PRODUCE SPECTROGRAM: 2 BARS EACH
% Good Parameters for GNR: 
%   bpm: 126/8, Chunk: 1, chuncation: 128, filterwidth: 4, filter: Gauss
%   bpm: 126/8, Chunk: 2, chunkation: 16, filterwidth: 2, filter: Guass
%   bpm: 126/8, Chunk: 3, chunkation: 16, filterwidth: 2, filter: Gauss
%   bpm: 126/8, Chhnk: 4, chunkation: 16, filterwidth: 2, filter: Gauss

CHUNK = 1;           % <- Choose which 2 bars of music you want here
WAVELET = @GFilter;  % <- Change your type of wavelet here.

p = ProblemParam(126/8, "GNR.m4a");
sp = SpectroGram(128, 4, [200 800]);

%
% -------------------------------------------------------------------------
% 1. Construct all parameters needed for the music. 
% 2. Filter out the frequencies for the instrument. 
% -------------------------------------------------------------------------

[original, t, hz] = p.getChunk(CHUNK);
filtered = OctaveFilter(t, original, 220, 3);
Play(p, CHUNK);

% -------------------------------------------------------------------------
% 1. Plot the filtered sound waves.
% 2. Plot the fft of filtered sound wave.
% 3. Plot the original sound waves. 
% 4. Plot the fft of the original sound wave. 
% -------------------------------------------------------------------------
figure(1)
subplot(4, 1, 1); plot(t, Normalize(filtered));
filteredHz = fftshift(abs(fft(filtered)));
subplot(4, 1, 4); plot(hz, Normalize(filteredHz));

subplot(4, 1, 3); plot(t, Normalize(original));
originalHz = fftshift(abs(fft(original)));
subplot(4, 1, 2); plot(hz, Normalize(originalHz));
title("Global Frequencies Filtering");

% -------------------------------------------------------------------------
% 1. Visualizing the spectrogram.
% -------------------------------------------------------------------------
[m, hzvec, spectroTvec] = CreateSpectrogram(filtered, t, sp, WAVELET);
figure(2); 
subplot(1, 2, 1);
pcolor(spectroTvec, hzvec, m); shading interp; 
title(strcat("GNR, bar: ", num2str((CHUNK - 1)*2), ...
    " to bar: ", num2str(CHUNK*2)));
xlabel("time[sec]"); ylabel("Frequencies [Hz]");


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
h = subplot(1, 2, 2);
plot(notes, "x", "markersize", 10, "linewidth", 4);
title("Unique Tonic Offsets"); xlabel("index"); ylabel("tonic offset");
set(h, "Ytick" , [1, 3, 5, 6, 8, 10, 11, 13, 15, 17, 18], ... 
    "YtickLabel", ["C#", "D#", "F", "F#", "G#", "A#", "C", "C#", "D#", "F", "F#"]);
saveas(gcf, "gnr-spectro", "png");
