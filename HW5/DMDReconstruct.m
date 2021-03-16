function [Reconstructed, Idx] = DMDReconstruct(Phi, Lambda, u0, DeltaT, t)
    % Function will automatically choose the modes and eigen value with the
    % least magnitude to reconstruct the dynamical system. 
    % Phi, Lambda: are coming out from the RunDMD function. 
    % X is the 
    % u0: The initial condition in the form of column matrix. 
    % totalCount: How many time moment we want to advance it. 
    % DeltaT: What is the time measurements for the dynamics for each snapt
    % shots? 
    
    % Takes out the best mode and its corresponding value. 
    
    Omega = log(diag(Lambda))/DeltaT;
    [OmegaSmallest, Idx] = min(Omega); 
    Phi = Phi(:, Idx); 
    y0 = Phi\u0;
    
    for Itr = t
        Reconstructed(:, Itr) = Phi*(y0.*exp(OmegaSmallest*t(Itr)));
    end
end

