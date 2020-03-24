clear; clc;
// FERM-2b.sce
// FERMENTADOR CONTINUO
// Dinámica

// SISTEMA DE ECUACIONES DIFERENCIALES
function dxdt = f(t,x)
    // Variables diferenciales
    X = x(1)
    S = x(2)
    P = x(3)
    // Ecuación de Monod
    mu = mumax*S/(KS+S)
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
    // Velocidad de reacción para el producto
    rP = (a*mu+b)*X
    // Balance de producto
    // d(V*P)dt = -F*P + rP*V
    dPdt = -D*P + rP
    // Derivadas
    dxdt(1) = dXdt
    dxdt(2) = dSdt
    dxdt(3) = dPdt
endfunction

// CONSTANTES
S0 = 10; // g/L
D = 0.1 // h-1
mumax = 0.3; // h-1
KS = 0.1; // g/L
Y = 0.8; // ad
a = 0.08; // ad
b = 0.03; // h-1

// CONDICIONES INICIALES
Xini = 1; Sini = 10; Pini = 0; // g/L
xini = [Xini;Sini;Pini];

// TIEMPO
tfin = 100; dt= 0.1; t = 0:dt:tfin; // h

// RESOLVER
x = ode(xini,0,t,f);
xfin = x(:,$);
dxdtfin = f(tfin,xfin)
Estacionario = abs(dxdtfin ./ xfin) < 1E-5

X = x(1,:); Xfin = X($)
S = x(2,:); Sfin = S($)
P = x(3,:); Pfin = P($)

// GRÁFICAS
scf(1); clf(1);
plot(t,X,t,S,t,P);
xgrid; xtitle('FERM-2b','t','X(azul), S(verde), P(rojo)');
