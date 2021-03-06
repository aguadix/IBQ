clear; clc;
// ENZ-2.sce
// REACTOR ENZIMÁTICO DISCONTINUO
// No adiabático, con desactivación enzimática
// https://youtu.be/RvEby-16eeA

// SISTEMA DE ECUACIONES DIFERENCIALES
function dxdt = f(t,x)
    // Variables diferenciales
    S = x(1)
    E = x(2)
    T = x(3)
    // Constante de velocidad
    k2 = exp(25 - 7600/T)
    // Velocidad de reacción para el sustrato
    // rS = -rmax*S/(KM+S) = -k2*E*S/(KM+S) =*= -k2*E*S/S
    // * KM << S 
    rS = -k2*E
    // Balance de sustrato
    // d(V*S)dt = rS*V
    dSdt = rS
    // Constante de desactivación
    kd = exp(30 - 9300/T) + exp(110 - 36300/T)
    // Velocidad de reacción para la enzima
    rE = -kd*E^2
    // Balance de enzima
    // d(V*E)dt = rE*V
    dEdt = rE
    // Balance de energía
    // d(V*RHO*CP*T)dt = U*A*(TJ-T) 
    dTdt = UA*(TJ-T)/(V*RHO*CP)
    // Derivadas
    dxdt(1) = dSdt
    dxdt(2) = dEdt
    dxdt(3) = dTdt
endfunction

// CONSTANTES
RHO = 1000; // g/L 
CP = 1; // cal/(g*K)
V = 10; // L
UA = 1E5; // cal/(h*K)
TJ = 300; // K

// CONDICIONES INICIALES
Sini = 5; // mM
Eini = 0.25; // mM
Tini = 290; // K
xini = [Sini;Eini;Tini];

// TIEMPO
tfin = 5; dt = 0.01; t = 0:dt:tfin; // h

// RESOLVER
x = ode(xini,0,t,f)
S = x(1,:); Sfin = S($)
E = x(2,:); Efin = E($)
T = x(3,:); Tfin = T($)

// GRÁFICAS
scf(1); clf(1);
subplot(311); plot(t,S); xgrid; xtitle('ENZ-2','t','S');
subplot(312); plot(t,E); xgrid; xtitle('ENZ-2','t','E');
subplot(313); plot(t,T); xgrid; xtitle('ENZ-2','t','T');

// OPTIMIZAR TJ para MINIMIZAR Sfin

TJinterval = 290:360; // K

for i = 1:length(TJinterval)
    TJ = TJinterval(i);  
    x = ode(xini,0,t,f);
    Sfin(i) = x(1,$);
end

[Sfinmin,indexSfinmin] = min(Sfin)
TJopt = TJinterval(indexSfinmin)

scf(2); clf(2);  
plot(TJinterval,Sfin,'ro',TJopt,Sfinmin,'x');
xgrid; xtitle('ENZ-2','TC','Sfin');
