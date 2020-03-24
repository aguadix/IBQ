clear; clc;
// FERM-1.sce
// FERMENTADOR DISCONTINUO

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
    // d(V*X)dt = rX*V
    dXdt = rX
    // Velocidad de reacción para el sustrato
    rS = -rX/Y
    // Balance de sustrato
    // d(V*S)dt = rS*V
    dSdt = rS
    // Velocidad de reacción para el producto
    rP = (a*mu+b)*X
    // Balance de producto
    // d(V*P)dt = rP*V
    dPdt = rP
    // Derivadas
    dxdt(1) = dXdt
    dxdt(2) = dSdt
    dxdt(3) = dPdt
endfunction

// CONSTANTES
mumax = 0.3; // h-1
KS = 0.1; // g/L
Y = 0.8; // ad
a = 0.08; // ad
b = 0.03; // h-1

// CONDICIONES INICIALES
Xini = 0.01; Sini = 10; Pini = 0; // g/L
xini = [Xini;Sini;Pini];

// TIEMPO
tfin = 40; dt = 0.01; t = 0:dt:tfin; // h

// RESOLVER
x = ode(xini,0,t,f);
X = x(1,:); Xfin = X($)
S = x(2,:); Sfin = S($)
P = x(3,:); Pfin = P($)

Sobj = Sini/1000;
indexSobj = find(S<Sobj,1);
tSobj = t(indexSobj)
XSobj = X(indexSobj)
PSobj = P(indexSobj)

// GRÁFICAS
scf(1); clf(1);
plot(t,X,t,S,t,P);
plot(tSobj,XSobj,'o');
plot(tSobj,Sobj,'go');
plot(tSobj,PSobj,'ro');
xgrid; xtitle('FERM-1','t','X(azul), S(verde), P(rojo)');
