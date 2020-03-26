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
S0 = 5; // g/L
D = 0.25; // h-1
mumax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

// SOLUCIÓN SUPUESTA
// Xeeguess = 0.5; Seeguess = 0.5; // g/L; CONVERGE AL EE1
 Xeeguess = 1.5; Seeguess = 2.0; // g/L; CONVERGE AL EE2
// Xeeguess = 1.0; Seeguess = 0.1; // g/L; CONVERGE AL EE3

xeeguess = [Xeeguess; Seeguess];


// RESOLVER
[xee,v,info] = fsolve(xeeguess, f)
Xee = xee(1)
See = xee(2)

// GRÁFICAS
plot(Xee,See,'x');
Xmin = 0; Xmax = 3; // g/L 
Smin = 0; Smax = 6; // g/L
a = gca(); a.data_bounds = [Xmin Xmax Smin Smax];
//a.tight_limits = 'on';

// ESTABILIDAD DE LOS ESTADOS ESTACIONARIOS
// A = numderivative(f,xee)  // Jacobiano
h = 1E-6;
dfdXee = (f([Xee+h;See]) - f([Xee;See]))/h
dfdSee = (f([Xee;See+h]) - f([Xee;See]))/h

A = [dfdXee dfdSee]

lambda = spec(A)  // Valores propios
Estable = real(lambda) < 0
