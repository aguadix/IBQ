clear; clc;
// ENZ-1.sce
// REACTOR ENZIMÁTICO DISCONTINUO
// Inhibición por sustrato
// https://youtu.be/oa6vfF2ZptY


// SISTEMA DE ECUACIONES DIFERENCIALES
function dxdt = f(t,x)
    // Variables diferenciales
    S = x(1)
    P = x(2)
    // Velocidad de reacción para el sustrato
    rS = -rmax*S/(KM+S+S^2/KI)
    // Balance de sustrato
    // d(V*S)dt = rS*V 
    dSdt = rS; 
    // Balance de producto
    // d(V*P)dt = rp*V = -rS*V 
    dPdt = -rS
    // Derivadas
    dxdt(1) = dSdt
    dxdt(2) = dPdt
endfunction

// CONSTANTES
rmax = 0.5; // mM/min
KM = 4.5; // mM
KI = 0.25; // mM

// CONDICIONES INICIALES
Sini = 1; Pini = 0; // mM
xini = [Sini;Pini];

// TIEMPO
tfin = 20; dt = 0.01; t = 0:dt:tfin; // min

// RESOLVER
x = ode(xini,0,t,f);
S = x(1,:); Sfin = S($)
P = x(2,:); Pfin = P($)

// GRÁFICAS
scf(1); clf(1);
plot(t,S,t,P)
xgrid; xtitle('ENZ-1','t','S(azul), P(verde)');


// OPTIMIZAR Sini para MAXIMIZAR Pfin

Siniinterval = 0.1:0.1:5.0; // mM

for i = 1:length(Siniinterval)
    Sini = Siniinterval(i);  
    xini = [Sini;Pini];
    x = ode(xini,0,t,f);
    Pfin(i) = x(2,$);
end

[Pfinmax,indexPfinmax] = max(Pfin)
Siniopt = Siniinterval(indexPfinmax)

scf(2); clf(2);  
plot(Siniinterval,Pfin,'ro',Siniopt,Pfinmax,'x')
xgrid; xtitle('ENZ-1','Sini','Pfin')
