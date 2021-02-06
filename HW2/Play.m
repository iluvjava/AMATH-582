function null = Play(p, i)
    [audio, ~, ~] = p.getChunk(i);
    playblocking(audioplayer(Normalize(audio), p.SampleRate));
    null = 0;
end
