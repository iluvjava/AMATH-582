function F = HatFilter(center, w, domainvec)
    %  Filter a signal with a mexican hat filter.
    phi = @(t) (1 - t.^2/w^2).*exp((-t.^2/w^2)/2);
    F = phi(domainvec - center);
end

