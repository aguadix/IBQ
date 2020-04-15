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

// SOLUCIÓN SUPUESTA
Xeeguess = 1; Seeguess = 0; Peeguess = 1; // g/L
//Xeeguess = 0; Seeguess = 10; Peeguess = 0; // g/L
xeeguess = [Xeeguess; Seeguess; Peeguess];

// RESOLVER
xee = fsolve(xeeguess, f);
Xee = xee(1)
See = xee(2)
Pee = xee(3)
Prod = D*Pee


// OPTIMIZAR D para MAXIMIZAR PROD

Dtest = 0.1:0.001:0.5; // h-1
for i = 1:length(Dtest)
    D = Dtest(i);  
    xee = fsolve(xeeguess, f);
    Xee(i) = xee(1);
    See(i) = xee(2);
    Pee(i) = xee(3);
end

Prod = Dtest'.*Pee;
[Prodmax,indexProdmax] = max(Prod)
Dopt = Dtest(indexProdmax)
XeeProdmax = Xee(indexProdmax)
SeeProdmax = See(indexProdmax)
PeeProdmax = Pee(indexProdmax)

scf(1); clf(1);  

subplot(221); 
plot(Dtest,Xee,'ro',Dopt,XeeProdmax,'x');
xgrid; xtitle('FERM-2a','D','Xee');

subplot(222); 
plot(Dtest,See,'ro',Dopt,SeeProdmax,'x');
xgrid; xtitle('FERM-2a','D','See');

subplot(223); 
plot(Dtest,Pee,'ro',Dopt,PeeProdmax,'x');
xgrid; xtitle('FERM-2a','D','Pee');

subplot(224); 
plot(Dtest,Prod,'ro',Dopt,Prodmax,'x');
xgrid; xtitle('FERM-2a','D','Prod');
