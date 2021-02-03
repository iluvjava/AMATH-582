function hz = TVecToHz(tvec)
    % Given a time domain, return a shifted frequencies domain. 
    n = length(tvec);
    L = tvec(end) - tvec(1);
    if mod(n, 2) == 0
        hz = (2*pi/L)*[0: n/2 - 1, -n/2: -1];
    else
        hz = (2*pi/L)*[0, 1:(n - 1)/2, -(n - 1)/2:-1];
    end
    hz = hz/(2*pi);
    hz = fftshift(hz);
end
