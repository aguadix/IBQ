clear; clc;
// FERM-3c.sce
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Dinámica

S0 = 5; // g/L
D = 0.25; // h-1
Umax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

tfin = 100; dt = 0.1; // h
t = 0:dt:tfin;

function dxdt = f(t,x)
    U = Umax*x(2)/(KS+x(2)+x(2)^2/KI)
    rX = U*x(1)
    rS = -rX/Y
    dxdt(1) = -D*x(1) + rX
    dxdt(2) = D*(S0-x(2)) + rS
endfunction

// CAMPO VECTORIAL
Xmin = 0; dX = 0.5; Xmax = 5;
Smin = 0; dS = 0.5; Smax = 5;
fchamp(f,0,Xmin:dX:Xmax,Smin:dS:Smax);

xini = locate(1)

x = ode(xini,0,t,f);
X = x(1,:); Xee = X($);
S = x(2,:); See = S($);
plot(X,S,'o');
