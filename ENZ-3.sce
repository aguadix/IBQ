clear; clc;
// ENZ-3
// REACTOR ENZIMÁTICO CONTINUO CON ENZIMA CONFINADA
// Con desactivación enzimática

V = 10; // L
F = 1; // L/h
S0 = 10; // mmol/L
E0 = 0.5; // mmol/L
KM = 0.5; // mmol/L
k = 0.5; // h-1
kd = 0.1; // h-1

Sini = 10; // mmol/L
Eini = 0.5; // mmol/L
xini = [Sini;Eini];

tfin = 200; dt = 0.01; // h
t = 0:dt:tfin;

function dxdt = f(t,x)
    rm = k*x(2)
    rS = -rm*x(1)/(KM+x(1))
    dxdt(1) = F*(S0-x(1))/V + rS
    dxdt(2) = F*E0/V - kd*x(2)
endfunction

x = ode(xini,0,t,f);
S = x(1,:); Sfin = S($)
E = x(2,:); Efin = E($)

scf(1); clf(1);
plot(t,S)
xgrid; xtitle('ENZ-3','t','S')

scf(2); clf(2);
plot(t,E)
xgrid; xtitle('ENZ-3','t','E')
