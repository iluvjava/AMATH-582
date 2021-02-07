%% SETTING THINGS UP

WAVELET = @ShannonFilter;
p  = ProblemParam(64/32, "Floyd.m4a");

%% WHOLE SONG GABOR TRANSFORM: FOR BASS
% 1. Set up the spectrogram settings. 
% 2. Slide up the music audio
% 3. Play it. 
% 4. Crate spectrongram base on the globally filtere audio
% 5. Plot it. 
% -------------------------------------------------------------------------
sp = SpectroGram(64 , 2, [50 200]);          %  <-- Change your spectrogram settings here. 
[original, t, hz] = p.slice(1, 1);
filtered = OctaveFilter(t, original, 55, 1); %  <-- Change your global frequencies filter setting here.
playblocking(audioplayer(Normalize(filtered), p.SampleRate));
[m, hzvec, spectroTvec] = CreateSpectrogram(filtered, t, sp, WAVELET);
figure; pcolor(spectroTvec, hzvec, m); shading interp; 
xlabel("Time[sec]"); ylabel("Hz");
title("The Bass for Floyd");

%% JUST ONE OF THE TIME FRAME TRANSFORMED: FOR BASS
sp = SpectroGram(64, 4, [50 200]);
[original, t, hz] = p.timeSlice(8.63, 25.9);
filtered = OctaveFilter(t, original, 55, 1);
playblocking(audioplayer(Normalize(filtered), p.SampleRate));
[m, hzvec, spectroTvec] = CreateSpectrogram(filtered, t, sp, WAVELET);
subplot(1, 2, 1); pcolor(spectroTvec, hzvec, m); shading interp; 
xlabel("Time[sec]"); ylabel("Hz");
title("One bar of bass for Floyd");

% Figuring out the notes
[tonicOffSet, peakingFreq] = PeakingFrequencies(sp, 110);
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
set(h, "Ytick" , [-5 -3 -2  0  1 2], ... 
    "YtickLabel", ["D" "F" "G" "A" "A#" "B"]);

saveas(gcf, "floyd-bass-spectro", "png");
%% WHOLE SONG GABOR TRANSFORM: FOR THE GUIARGER: FOR GUITAR
sp = SpectroGram(300, 2, [400, 1600]);
[original, t, hz] = p.slice(1, 1);
filtered = OctaveFilter(t, original, 440, 3);
% playblocking(audioplayer(Normalize(filtered), p.SampleRate));
[m, hzvec, spectroTvec] = CreateSpectrogram(filtered, t, sp, WAVELET);
figure; pcolor(spectroTvec, hzvec, m); shading interp; 
xlabel("Time[sec]"); ylabel("Hz");
title("All of the guitar for Floyd");

%% JUST ONE OF THE TIME FRAME TRANSFORMED FOR THE GUIARGER: FOR GUITAR
sp = SpectroGram(64 , 2, [400 1600]);
[original, t, hz] = p.timeSlice(8.63, 25.9);
filtered = OctaveFilter(t, original, 440, 2);
playblocking(audioplayer(Normalize(filtered), p.SampleRate));
[m, hzvec, spectroTvec] = CreateSpectrogram(filtered, t, sp, WAVELET);
figure; pcolor(spectroTvec, hzvec, m); shading interp; 
xlabel("Time[sec]"); ylabel("Hz");
title("A bar of guitar for Floyd")
