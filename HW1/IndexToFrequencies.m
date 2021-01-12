function [Freqxyz] = IndexToFrequencies(params, index)
    Kx = params.Kx; Ky = params.Ky; Kz = params.Kz; 
    Freqxyz = [Kx(index), Ky(index), Kz(index)];
end