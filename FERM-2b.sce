clear; clc;
// FERM-2b.sce
// FERMENTADOR CONTINUO
// Dinámica

S0 = 10; // g/L
D = 0.1; // h-1
Umax = 0.3; // h-1
KS = 0.1; // g/L
Y = 0.8; // ad
a = 0.08; // ad
b = 0.03; // h-1

Xini = 1; Sini = 10; Pini = 0; // g/L
xini = [Xini;Sini;Pini];

tfin = 100; dt = 0.01; // h
t = 0:dt:tfin;

function dxdt = f(t,x)
    U = Umax*x(2)/(KS+x(2))
    rX = U*x(1)
    rS = -rX/Y
    rP = (a*U+b)*x(1)
    dxdt(1) = -D*x(1) + rX
    dxdt(2) = D*(S0-x(2)) + rS
    dxdt(3) = -D*x(3) + rP
endfunction

x = ode(xini,0,t,f);
X = x(1,:); Xfin = X($)
S = x(2,:); Sfin = S($)
P = x(3,:); Pfin = P($)

scf(1); clf(1);
plot(t,X,t,S,t,P)
xgrid; xtitle('FERM-2b','t','X(azul), S(verde), P(rojo)')
