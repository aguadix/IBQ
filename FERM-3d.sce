clear; clc; s = %s;
// FERM-3d
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Control

S0 = 5; // g/L
D = 0.25; // h-1
Umax = 0.53; // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

// (a) LOCALIZACIÓN DE ESTADOS ESTACIONARIOS

//Variables de estado: X, S
Xeeguess = 1; Seeguess = 0.1; // g/L (converge a ee estable)
//Xeeguess = 1; Seeguess = 1; // g/L (converge a ee inestable)
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

// (b) LINEALIZACIÓN

u = D; //Variable de entrada: D

function [y,dxdt] = SNL(x,u)
    D = u
    dxdt = f(x)
    y = x(1) //Variable de salida: X
endfunction

SL = lin(SNL,xee,u) 
Gp = ss2tf(SL)
polosGp = roots(denom(Gp))

// (c) CONTROL

// Elementos del sistema
Kc = 5; taui = 0.5; Gc = Kc*(1+1/(taui*s)) // Control PI
Kv = -1; Gv = Kv; // Válvula
Gm = 1; // Medida

// Polos
Gcl = syslin('c',Gc*Gv*Gp / (1+Gm*Gc*Gv*Gp)) // Servomecanismo
polosGcl = roots(denom(Gcl))

// Respuesta a escalón
dt = 0.01; tfin = 5; t = 0:dt:tfin;
u = 'step';
y = csim(u,t,Gcl);

scf(1); clf(1); 
plot(t,y); 
xgrid; xtitle('FERM-3d', 't', 'y');