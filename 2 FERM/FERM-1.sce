clear; clc;
// FERM-1.sce
// FERMENTADOR DISCONTINUO
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
    // d(V*X)dt = rX*V
    dXdt = rX
    // Velocidad de reacción para el sustrato
    rS = -rX/Y
    // Balance de sustrato
    // d(V*S)dt = rS*V
    dSdt = rS
    // Velocidad de reacción para el producto
    rP = (alpha*mu+beta)*X
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
alpha = 0.08; // ad
beta = 0.03; // h-1

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

// GRÁFICAS
scf(1); clf(1);
plot(t,X,t,S,t,P);
xgrid; xtitle('FERM-1','t','X(azul), S(verde), P(rojo)');

// 1. El producto supera los 5 g/L
Pobj = 5; // g/L
indexPobj = find(P>Pobj,1);
tPobj = t(indexPobj)
plot(tPobj,Pobj,'ro');

// 2. Se agota el sustrato.
Sobj = 0.001*Sini;
indexSobj = find(S<Sobj,1);
tSobj = t(indexSobj)
plot(tSobj,Sobj,'go');

// 3. El microorganismo crece a  1 g/(L·h)
for i = 1:length(t)
    dxdt(:,i) = f(t(i),x(:,i));
end
dXdt = dxdt(1,:);
dXdtobj = 1; // g/(L*h)
indexdXdtobj = find(dXdt>dXdtobj,1);
tdXdtobj = t(indexdXdtobj)
XdXdtobj = X(indexdXdtobj)
plot(tdXdtobj,XdXdtobj,'o');
// Recta tangente a X en (tdXdtobj,XdXdtobj)
// y = y0 + m*(x-x0)
plot(t,XdXdtobj + dXdtobj*(t-tdXdtobj),'--');

a1 = gca;
a1.data_bounds = [0,0;tfin,max([X,S,P])];
