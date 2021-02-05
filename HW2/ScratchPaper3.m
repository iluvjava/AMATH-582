p  = ProblemParam(64/8, "Floyd.m4a");
sp = SpectroGram(128, 2, [50 400]);
FILTERFUNC = @ShannonFilter;
CHUNK = 1;
% playblocking(audioplayer(p.AudioData, p.SampleRate));

%% FILTER FREQUENCIES DOMAIN

[filtered, ~, hz] = OctaveFilter(p, CHUNK, 110/2, 4);
[original, t] = p.getChunk(CHUNK);

Play(p, CHUNK);
% playblocking(audioplayer(filtered, p.SampleRate));


[m, hzvec, spectroTvec] = CreateSpectrogram(filtered, t, sp, FILTERFUNC);
%% 
pcolor(spectroTvec, hzvec, m); shading interp; 
title(strcat("floyd: Chunk: ", num2str(CHUNK))); 

