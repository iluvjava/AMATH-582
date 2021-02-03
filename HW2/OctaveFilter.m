function [filtered, tspan, hz] = OctaveFilter(p, i, rootnote, octave)
    % Filter out the frequencies for a given chunk of music from the
    % Audio. 
    % p: an instance ofthe ProblemParam. 
    % i: The index of the chunk of music that we are interested in. 
    % rootnote: The tonic key and it's also the lowest key. 
    % octave: The number of octave you want to go up from the tonic key. 
    
    [chunk, tspan, hz] = p.getChunk(i);
    chunkFFT = fft(chunk);
    
    kFilter = (abs(hz) < rootnote*(2^octave + 1)).*(abs(hz) > rootnote);
    
    chunkFFTFiltered = kFilter.*chunkFFT; 
    filtered = real(ifft(chunkFFTFiltered));
end