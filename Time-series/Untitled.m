
tspan = linspace(0,0.5,100);

x0 = [-1,-1.5,-2,-2.5,-3; 1,1.5,2,2.5,3];
for n = 1:5
    [t,x] = ode15s(@sys3, tspan, x0(:,n));
    plot(x(:,1),x(:,2));
    hold on
end
legend("1", "2", "3", "4", "5")



function S1 = sys1(t,x)
    S1 = [x(1)^2 - x(1) + x(2) - x(2)^2; 
         2*x(1) + x(1)*x(2)];
end

function S2 = sys2(t,x)
    S2 = [x(1) - x(2)^2; x(2) - x(1)^2];
end 

function S3 = sys3(t,x)
    S3 = [(2 + x(1))*(x(2) - x(1)); (4 - x(1))*(x(2) + x(1))];
end 