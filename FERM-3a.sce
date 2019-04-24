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

S = 0:0.01:3;
U = Umax*S ./(KS+S+S.^2/KI);

Nee = 0
for i = 1:length(S)-1
    if sign(U(i)-D) <> sign(U(i+1)-D) then
        Nee = Nee+1
        See(Nee) = S(i)
    end
end

scf(1); clf(1);
plot(S,U)
xgrid; xtitle('FERM-3a','S','U')
