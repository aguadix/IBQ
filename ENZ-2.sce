clear; clc;
// ENZ-2.sce
// REACTOR ENZIMÁTICO DISCONTINUO
// No adiabático, con desactivación enzimática

RHO = 1000; // g/L 
CP = 1; // cal/(g*K)
V = 10; // L
UA = 1E5; // cal/(h*K)

Sini = 5; // mM
Eini = 0.25; // mM
Tini = 290; // K
xini = [Sini;Eini;Tini];

tfin = 5; dt = 0.01; // h
t = 0:dt:tfin;

function dxdt = f(t,x)
    kh = exp(25 - 7600/x(3))
    kd = exp(30 - 9300/x(3)) + exp(110 - 36300/x(3))
    dxdt(1) = -kh*x(2)
    dxdt(2) = -kd*x(2)^2
    dxdt(3) = UA*(TC-x(3))/(RHO*V*CP)
endfunction


TCtest = 300:360; // K

for i = 1:length(TCtest)
    TC = TCtest(i);  
    x = ode(xini,0,t,f);
    Sfin(i) = x(1,$);
end

[Sfinmin,index] = min(Sfin)
TCopt = TCtest(index)

scf(1); clf(1);  
plot(TCtest',Sfin,'ro')
xgrid; xtitle('ENZ-02','TC','Sfin')


TC = TCopt;

x = ode(xini,0,t,f);
S = x(1,:); Sfin = S($)
E = x(2,:); Efin = E($)
T = x(3,:); Tfin = T($)

scf(2); clf(2);
plot(t,S)
xgrid; xtitle('ENZ-2','t','S')

scf(3); clf(3);
plot(t,E)
xgrid; xtitle('ENZ-2','t','E')

scf(4); clf(4);
plot(t,T)
xgrid; xtitle('ENZ-2','t','T')
