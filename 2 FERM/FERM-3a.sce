clear; clc;
// FERM-3a.sce
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Balances gráficos

// CONSTANTES
V = 1; // L
F = 0.25; // L/h
D = F/V // h-1
S0 = 5; // g/L
mumax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

// BALANCES
scf(1); clf(1);
xtitle('FERM-3','X','S');
Xmin = 0; dX = 0.001; Xmax = 3; // g/L 
Smin = 0; dS = 0.001; Smax = 6; // g/L 

// Balance de microorganismo
// d(V*X)dt = -F*X + rX*V = 0
// dXdt = -D*X + rX = -D*X + mu*X = X*(-D + mu) = 0
Xee = 0;
// -D + mu = -D + mumax*S/(KS+S+S^2/KI) = 0
// KS+S+S^2/KI = mumax*S/D
// S^2/KI + S*(1-mumax*S/D) + KS = 0
a = 1/KI; b = (1-mumax/D); c = KS;
See = (-b+sqrt(b^2-4*a*c))/(2*a)
plot([Xmin,Xmax],[See,See],'r-');
See = (-b-sqrt(b^2-4*a*c))/(2*a)
plot([Xmin,Xmax],[See,See],'r-');

// Balance de sustrato
S = Smin:dS:Smax;
mu = mumax*S ./(KS+S+S^2/KI);
// d(V*S)dt = F*S0 - F*S + rS*V = 0
// dSdt = D*(S0-S) + rS = D*(S0-S) - rX/Y = D*(S0-S) - mu*X/Y 
X = D*(S0-S)*Y./mu;
plot(X,S,'r--')

a = gca; a.data_bounds = [Xmin,Smin;Xmax,Smax];
