clear; clc;
// FERM-3c.sce
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Dinámica

// SISTEMA DE ECUACIONES DIFERENCIALES
function dxdt = f(t,x)
    // Variables diferenciales
    X = x(1)
    S = x(2)
    // Ecuación de Monod
    mu = mumax*S/(KS+S+S^2/KI)
    // Velocidad de reacción para el microorganismo
    rX = mu*X
    // Balance de microorganismo
    // d(V*X)dt = -F*X + rX*V
    dXdt = -D*X + rX
    // Velocidad de reacción para el sustrato
    rS = -rX/Y
    // Balance de sustrato
    // d(V*S)dt = F*S0 - F*S + rS*V
    dSdt = D*(S0-S) + rS
    // Derivadas
    dxdt(1) = dXdt
    dxdt(2) = dSdt
endfunction

// CONSTANTES
V = 1; // L
F = 0.25; // L/h
D = F/V // h-1
S0 = 5; // g/L
mumax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

// CAMPO VECTORIAL
Xmin = 0; dX = 0.10; Xmax = 3; // g/L 
Smin = 0; dS = 0.25; Smax = 6; // g/L 
scf(1); fchamp(f,0,Xmin:dX:Xmax,Smin:dS:Smax);

// CONDICIONES INICIALES
Xini = 0; // g/L 
Sini = 0; // g/L
// Sini = 0 => Separatriz: 0.82 < Xini < 0.83 
// Sini = 6 => Separatriz: 2.33 < Xini < 2.34 
xini = [Xini;Sini];

// TIEMPO
tfin = 1000; dt = 0.1; t = 0:dt:tfin; // h

// RESOLVER
x = ode(xini,0,t,f);
X = x(1,:); Xee = X($)
S = x(2,:); See = S($)

// GRÁFICAS
scf(1); plot(X,S,'o-');
a = gca; a.data_bounds = [Xmin,Smin;Xmax,Smax];
