function v = Normalize(vec)
    v = vec/max(abs(vec), [], "all");
    if sum(imag(v)) ~= 0
        v = abs(v);
    end
end