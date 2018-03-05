clear; clc;
// ENZ-1
// REACTOR ENZIMÁTICO DISCONTINUO
// Inhibición por sustrato

rmax = 0.5; // mM/min
KM = 4.5; // mM
KS = 0.25; // mM
Pini = 0; // mM

tfin = 20; dt = 0.01; //min
t = 0:dt:tfin;

function dxdt = f(t,x)
    r = rmax*x(1)/(KM+x(1)+x(1)^2/KS)
    dxdt(1) = -r; 
    dxdt(2) = r
endfunction

Sinitest = 0.1:0.1:5.0; // mM

for i = 1:length(Sinitest)
    Sini = Sinitest(i);  
    xini = [Sini;Pini];
    x = ode(xini,0,t,f);
    Pfin(i) = x(2,$);
end

[Pfinmax,index] = max(Pfin)
Siniopt = Sinitest(index)

scf(1); clf(1);  
plot(Sinitest',Pfin,'ro')
xgrid; xtitle('ENZ-1','Sini','Pfin')