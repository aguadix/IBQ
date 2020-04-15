clear; clc;
// FERM-3a.sce
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Estados estacionarios (método gráfico)

// CONSTANTES
S0 = 5; // g/L
D = 0.25; // h-1
mumax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

// BALANCES
Xmin = 0; dX = 0.001; Xmax = 3; // g/L 
Smin = 0; dS = 0.001; Smax = 6; // g/L 

// Balance de microorganismo
// d(V*X)dt = -F*X + rX*V = -F*X + mu*X*V = 0
// X*(-D + mu) = 0
Xee(1) = 0;
// D = mu = mumax*S/(KS+S+S^2/KI)
// S^2/KI + S*(1-mumax/D) + Ks = 0
a = 1/KI; b = (1-mumax/D); c = KS;
See(2) = (-b+sqrt(b^2-4*a*c))/(2*a)
See(3) = (-b-sqrt(b^2-4*a*c))/(2*a)

scf(1); clf(1);
plot([Xmin Xmax],[See(2) See(2)],'k');
plot([Xmin Xmax],[See(3) See(3)],'k');
xtitle('FERM-3a','X','S');

// Balance de sustrato
S = Smin:dS:Smax;
mu = mumax*S ./(KS+S+S^2/KI);
// Balance de sustrato
// d(V*S)dt = F*S0 - F*S + rS*V
// dSdt = D*(S0-S) + rS = D*(S0-S) - rX/Y = D*(S0-S) - mu*X/Y 
X = D*(S0-S)*Y./mu;
See(1) = S0

plot(X,S,'k')
a = gca(); a.data_bounds = [Xmin Xmax Smin Smax];
//a.tight_limits = 'on';

indexee2 = find(S>See(2),1);
Xee(2) = X(indexee2)

indexee3 = find(S>See(3),1);
Xee(3) = X(indexee3)

plot(Xee,See,'ro');
