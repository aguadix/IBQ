clear; clc;
// FERM-3b
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Estados estacionarios

S0 = 5; // g/L
D = 0.25; // h-1
Umax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

Xeeguess = 1; Seeguess = 0.1; // g/L
xeeguess = [Xeeguess; Seeguess];

function dxdt = f(x)
    U = Umax*x(2)/(KS+x(2)+x(2)^2/KI)
    rX = U*x(1)
    rS = -rX/Y
    dxdt(1) = -D*x(1) + rX
    dxdt(2) = D*(S0-x(2)) + rS
endfunction

[xee,v,info] = fsolve(xeeguess, f)
Xee = xee(1)
See = xee(2)