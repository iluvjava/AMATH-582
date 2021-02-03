function F = GFilter(center, w, domainvec)
    % Give a center and the with of the Guassian Filter, return a vector
    % that is representing the filter. 
    %
    % Center: 
    %       Where the guassian filter is located at. 
    % w: 
    %       The width of the guassian filter. 
    % domainvec: 
    %       A domain vector represent where the filter filtering. It can be
    %       both in the frequency, or the signal domain. 
    f = @(x) exp(-(x - center).^2/(w/4)^2);
    F = f(domainvec);
end