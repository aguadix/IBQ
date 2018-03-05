// FERM-4
// FERMENTADOR SEMICONTINUO CON INHIBICIÓN POR SUSTRATO
clear; clc;

F = 0.05; // L/h
Umax = 0.8; // h-1
KS = 0.1; // g/L
Y = 0.5; // ad
KI = 10; // g/L

Vini = 0.5; // L   
VXini = 0.01; // g 
VSini = 0.5; // g  
xini = [Vini; VXini; VSini];

tfin = 10; dt = 0.01; // h
t = 0:dt:tfin;

function dxdt = f(t,x)
    X = x(2)/x(1)
    S = x(3)/x(1)
    U = Umax*S/(KS+S+S^2/KI)
    rX = U*X
    rS = -rX/Y
    dxdt(1) = F
    dxdt(2) = rX*x(1)
    dxdt(3) = F*S0 + rS*x(1)
endfunction

S0test = 1:0.1:20; // g/L

for i = 1:length(S0test)
    S0 = S0test(i);  
    x = ode(xini,0,t,f);
    VXfin(i) = x(2,$);
end

[VXfinmax,index] = max(VXfin)
S0opt = S0test(index)

scf(1); clf(1);  
plot(S0test,VXfin,'ro')
xgrid; xtitle('FERM-04','S0','VXfin')


S0 = S0opt;

x = ode(xini,0,t,f);
V = x(1,:); Vfin = V($)
VX = x(2,:); VXfin = VX($)
VS = x(3,:); VSfin = VS($)

S = VS./V;

scf(2); clf(2); 
plot(t,V)
xgrid; xtitle('FERM-4','t','V')

scf(3); clf(3);
plot(t,VX,t,VS)
xgrid; xtitle('FERM-4','t','VX(azul), VS(verde)')

scf(4); clf(4);
plot(t,S)
xgrid; xtitle('FERM-4','t','S')