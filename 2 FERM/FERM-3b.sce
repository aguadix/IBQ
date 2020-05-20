clear; clc;
// FERM-3b.sce
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Estados estacionarios

// SISTEMA DE ECUACIONES DIFERENCIALES
function dxdt = f(x)
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

// SOLUCIÓN SUPUESTA
Xeeguess = 0;   Seeguess = 5;   // xee = [0   ;5  ]  // g/L
//Xeeguess = 1.5; Seeguess = 2.5; // xee = [1.32;2.35] // g/L
//Xeeguess = 2.5; Seeguess = 0.1; // xee = [2.44;0.11] // g/L
xeeguess = [Xeeguess; Seeguess];
   
// RESOLVER
[xee,v,info] = fsolve(xeeguess, f)
Xee = xee(1)
See = xee(2)

// GRÁFICAS
scf(1); plot(Xee,See,'ro');

// ESTABILIDAD DE LOS ESTADOS ESTACIONARIOS
// Derivadas parciales
h = 1E-6;
dfdXee = (f([Xee+h;See]) - f([Xee;See]))/h
dfdSee = (f([Xee;See+h]) - f([Xee;See]))/h

// Matriz jacobiana
J = [dfdXee,dfdSee]

// Valores propios
lambda = spec(J)

// Criterio de estabilidad
Estable = real(lambda) < 0
