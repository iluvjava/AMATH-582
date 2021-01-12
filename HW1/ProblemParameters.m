classdef ProblemParameters < handle
    % I will put all the parameters associated with HW into this class, 
    % so it's easier to refer to.
    
    
    
    
    properties
        L = 10;     % The width of the cube. 
        n = 64;     % The Fourier Resolution. 
        x; y; z;    % Axis for the cube. 
        ks; k;      % The shifted and unshifted Freq domain vector. 
        X; Y; Z;    % The cube in signal domain. 
        Kx; Ky; Kz; % The cube in freq domain, shifted, low at center. 
    end
    
    methods
        function this = ProblemParameters()
            L  = this.L; n = this.n;
            x2 = linspace(-L, L, n + 1); x = x2(1:n); y = x; z = x;
            k=(2*pi/(2*L))*[0:n/2-1 -n/2:-1]; ks = fftshift(k);
            this.x = x; this.y = y; this.z = z;
            this.ks = ks; this.k = k;
            [X, Y, Z] = meshgrid(x, y, z); 
            [Kx, Ky, Kz] = meshgrid(ks, ks, ks);
            this.X = X; this.Y = Y; this.Z = Z;
            this.Kx = Kx; this.Ky = Ky; this.Kz = Kz; 
        end
        
    end
end

