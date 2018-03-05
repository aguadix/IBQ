clear; clc;
// FERM-3c
// FERMENTADOR CONTINUO CON INHIBICIÓN POR SUSTRATO
// Dinámica

S0 = 5; // g/L
D = 0.25; // h-1
Umax = 0.53 // h-1
KS = 0.12; // g/L
Y = 0.5; // ad
KI = 2.2; // g/L

tfin = 100; dt = 0.01; // h
t = 0:dt:tfin;

function dxdt = f(t,x)
    U = Umax*x(2)/(KS+x(2)+x(2)^2/KI)
    rX = U*x(1)
    rS = -rX/Y
    dxdt(1) = -D*x(1) + rX
    dxdt(2) = D*(S0-x(2)) + rS
endfunction

scf(1); clf(1);
xgrid; xtitle('FERM-3c','X','S')

for Sini = 0:6:6; // g/L
    for Xini = 0:0.05:3; // g/L
        xini = [Xini;Sini];
        x = ode(xini,0,t,f);
        X = x(1,:); Xfin = X($);
        S = x(2,:); Sfin = S($);
        if Xfin < 0.01 then
            plot(X,S,'r',Xfin,Sfin,'bo')
        else
            plot(X,S,'g',Xfin,Sfin,'bo')
        end
    end
end