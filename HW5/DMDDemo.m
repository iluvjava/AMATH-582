x = linspace(-10 ,10, 100); 
t = linspace(0, 4*pi, 80); 
dt = t(2) - t(1);
[X, T] = meshgrid(x, t); 

% f1=sech(X+3).*(1-0.5*cos(2*T));
% f2=(sech(X).*tanh(X)).*(2.5*sin(3*T));
f1 = sech(X + 3).*(1*exp(1i*2.3*T));
f2 = (sech(X).*tanh(X)).*(2*exp(1i*2.8*T));
f  = f1 + f2;

figure(1); 
subplot(1, 2, 1); 
surf(X, T, real(f)); shading interp
title("original real part")
xlabel("x"); ylabel("t"); 
subplot(1, 2, 2);
surf(X, T, imag(f)); shading interp
title("original imaginary part")
xlabel("x"); ylabel("t"); 

% Perform the DMD with rank of 2: 
[Lambda, Phi] = RunDMD(f.', 30); 
u0 = f(1, :)'; % Take out the fist snapshot from the data matrix. 
y0 = Phi\u0; 
Omega = log(diag(Lambda))/dt;
for Itr = 1: length(t)
    UDMDModes(:, Itr) = Phi*(y0.*exp(Omega*t(Itr)));
end

figure(2); 
subplot(1, 2, 1); 
title("recovered real part"); 
surf(X, T, real(UDMDModes')); shading interp
xlabel("x"); ylabel("T");
subplot(1, 2, 2);
title("recovered imag part"); 
surf(X, T, imag(UDMDModes')); shading interp
xlabel("x"); ylabel("T");



