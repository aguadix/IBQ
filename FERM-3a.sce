clear; clc;
// FERM-3a.sce
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Estados estacionarios (método. gráfico)

S0 = 5; // g/L
D = 0.25; // h-1
Umax = 0.53; // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L


// Balance de X
// X = 0
// S^2/KI + S + KS-Umax/D = 0
a = 1/KI; b = (1-Umax/D); c = KS
S1 = (-b+sqrt(b^2-4*a*c))/(2*a)
S2 = (-b-sqrt(b^2-4*a*c))/(2*a)

scf(1); clf(1);
plot([0 5],[S1 S1],'k');
plot([0 5],[S2 S2],'k');


// Balance de S
S = 0:0.05:5;
U = Umax*S ./(KS+S+S.^2/KI);
X = D*(S0-S)*Y./U;

scf(1); 
plot(X,S,'k')
xtitle('FERM-3a','X','S')



