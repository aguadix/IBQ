// FERM-2a
// FERMENTADOR CONTINUO
// Estado estacionario
clear; clc;

S0 = 10; // g/L
//D = 0.1; // h-1
Umax = 0.3; // h-1
KS = 0.1; // g/L
Y = 0.8; // ad
a = 0.08; // ad
b = 0.03; // h-1

Xeeguess = 1; Seeguess = 0; Peeguess = 1; // g/L
//Xeeguess = 0; Seeguess = 10; Peeguess = 0; // g/L
xeeguess = [Xeeguess; Seeguess; Peeguess];

function dxdt = f(x)
    U = Umax*x(2)/(KS+x(2))
    rX = U*x(1)
    rS = -rX/Y
    rP = (a*U+b)*x(1)
    dxdt(1) = -D*x(1) + rX
    dxdt(2) = D*(S0-x(2)) + rS
    dxdt(3) = -D*x(3) + rP
endfunction

Dtest = 0.1:0.001:0.5; // h-1
for i = 1:length(Dtest)
    D = Dtest(i);  
    xee = fsolve(xeeguess, f);
    Xee(i) = xee(1);
    See(i) = xee(2);
    Pee(i) = xee(3);
end

Prod = Dtest'.*Pee;
[Prodmax,index] = max(Prod)
Dopt = Dtest(index)

scf(1); clf(1);  

subplot(221); plot(Dtest,Xee,'ro')
xgrid; xtitle('FERM-2a','D','Xee')

subplot(222); plot(Dtest,See,'ro')
xgrid; xtitle('FERM-2a','D','See')

subplot(223); plot(Dtest,Pee,'ro')
xgrid; xtitle('FERM-2a','D','Pee')

subplot(224); plot(Dtest,Prod,'ro')
xgrid; xtitle('FERM-2a','D','Prod')