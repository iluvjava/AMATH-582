function [Indices, Points] = GetPeakingSignal(params, signal)
  % Given cubes of signal, in the shape of [49, 64, 64, 64], the function
  % will take out the peaking signal, the indices and it's position 
  
  Indices = zeros(1, size(signal, 1)); 
  Points = zeros(3, size(signal, 1));
  
  for II = 1: size(signal, 1)
    Cube = signal(II, :, :, :); 
    Cube = abs(Cube)/max(abs(Cube), [], "all");
    Indices(II) = find(Cube == 1);
    Points(:, II) = ... 
        [params.X(Indices(II)); params.Y(Indices(II)); params.Z(Indices(II))];
  end

end

