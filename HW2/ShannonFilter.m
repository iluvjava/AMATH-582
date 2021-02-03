function F = ShannonFilter(center, w, domainvec)
    F = (abs(domainvec - center) <= w/2);
end