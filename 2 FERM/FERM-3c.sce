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
S0 = 5; // g/L
D = 0.25; // h-1
mumax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

// CAMPO VECTORIAL
Xmin = 0; dX = 0.25; Xmax = 3; // g/L 
Smin = 0; dS = 0.50; Smax = 6; // g/L 

fchamp(f,0,Xmin:dX:Xmax,Smin:dS:Smax);
a = gca(); a.data_bounds = [Xmin Xmax Smin Smax];


// CONDICIONES INICIALES
Xini = 0.0; Sini = 0.0; // g/L
xini = [Xini;Sini];
// xini = locate(1)

// TIEMPO
tfin = 1000; dt = 0.1; t = 0:dt:tfin; // h

// RESOLVER
x = ode(xini,0,t,f);
X = x(1,:); Xee = X($)
S = x(2,:); See = S($)

// TRAYECTORIA
plot(X,S,'o');
a = gca(); 
a.data_bounds = [Xmin Xmax Smin Smax];
