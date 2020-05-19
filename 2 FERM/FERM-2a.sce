clear; clc;
// FERM-2a.sce
// FERMENTADOR CONTINUO
// Estado estacionario

// SISTEMA DE ECUACIONES ALGEBRAICAS
function dxdt = f(x)
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
    rP = (alpha*mu+beta)*X
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
mumax = 0.3; // h-1
KS = 0.1; // g/L
Y = 0.8; // ad
alpha = 0.08; // ad
beta = 0.03; // h-1

// SOLUCIÓN SUPUESTA
Xeeguess = 1; Seeguess = 0.01; Peeguess = 1; // g/L
xeeguess = [Xeeguess; Seeguess; Peeguess];

// OPTIMIZAR D para MAXIMIZAR PROD

Dinterval = 0.1:0.001:0.5; // h-1
for i = 1:length(Dinterval)
    // CONSTANTES
    D = Dinterval(i);  
    // RESOLVER
    xee = fsolve(xeeguess, f);
    Xee(i) = xee(1);
    See(i) = xee(2);
    Pee(i) = xee(3);
end

Prod = Dinterval'.*Pee;
[Prodmax,indexProdmax] = max(Prod)
Dopt = Dinterval(indexProdmax)
XeeProdmax = Xee(indexProdmax)
SeeProdmax = See(indexProdmax)
PeeProdmax = Pee(indexProdmax)

scf(1); clf(1);  

subplot(411); 
plot(Dinterval,Xee,'bo',Dopt,XeeProdmax,'kx');
xgrid; xtitle('FERM-2a','','Xee');

subplot(412); 
plot(Dinterval,See,'go',Dopt,SeeProdmax,'kx');
xgrid; xtitle('','','See');

subplot(413); 
plot(Dinterval,Pee,'ro',Dopt,PeeProdmax,'kx');
xgrid; xtitle('','','Pee');

subplot(414); 
plot(Dinterval,Prod,'co',Dopt,Prodmax,'kx');
xgrid; xtitle('','D','Prod');
