function [Reconstructed] = ReconstructAllRealization(filtered)
    % Given a series of data cube in the fourierspace that is: shifted, filtered. 
    % reconstruct that data using inverse fourier transform. 
    % Filtered: 
    %   Tensor of the size: [49, 64, 64, 64]
    Reconstructed = zeros(size(filtered));
    
    for II = 1: size(filtered, 1)
        Reconstructed(II, :, :, :) = ifftn(ifftshift(filtered(II, :, :, :)));
    end
end

