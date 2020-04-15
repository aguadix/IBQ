clear; clc;
// FERM-4.sce
// FERMENTADOR SEMICONTINUO CON INHIBICIÓN POR SUSTRATO

// SISTEMA DE ECUACIONES DIFERENCIALES
function dxdt = f(t,x)
    // Variables diferenciales
    V  = x(1)
    VX = x(2)
    VS = x(3)
    // Balance global
    // d(V*RHO)dt = F*RHO
    dVdt  = F
    // Concentraciones
    X = VX/V
    S = VS/V
    // Ecuación de Monod
    mu = mumax*S/(KS+S+S^2/KI)
    // Velocidad de reacción para el microorganismo
    rX = mu*X
    // Balance de microorganismo
    dVXdt = rX*V
    // Velocidad de reacción para el sustrato
    rS = -rX/Y
    // Balance de sustrato
    dVSdt = F*S0 + rS*V
    // Derivadas
    dxdt(1) = dVdt
    dxdt(2) = dVXdt
    dxdt(3) = dVSdt
endfunction

// CONSTANTES
F = 0.05; // L/h
S0 = 10; // g/L
mumax = 0.8; // h-1
KS = 0.1; // g/L
Y = 0.5; // ad
KI = 10; // g/L

// CONDICIONES INICIALES
Vini = 0.5; // L   
VXini = 0.01; // g 
VSini = 0.25//0.5; // g  
xini = [Vini; VXini; VSini];

// TIEMPO
tfin = 10; dt = 0.01; // h
t = 0:dt:tfin;

// RESOLVER
x = ode(xini,0,t,f);
V  = x(1,:); Vfin  = V($)
VX = x(2,:); VXfin = VX($)
VS = x(3,:); VSfin = VS($)
S = VS./V;

// S óptima => dmudS = d(mu*S/(KS+S+S^2/KI)) = 0 
// KS+S+S^2/KI - S*(1+2*S/KI) = 0 
// KS - S^2/KI = 0
Sopt = sqrt(KS*KI) 

indexSopt = find(S>Sopt);
tSopt = dt*length(indexSopt)

// GRÁFICAS
scf(1); clf(1); 
plot(t,V)
xgrid; xtitle('FERM-4','t','V')

scf(2); clf(2);
plot(t,VX,t,VS)
xgrid; xtitle('FERM-4','t','VX(azul), VS(verde)')

scf(3); clf(3);
plot(t,S,t(indexSopt),S(indexSopt),'go');
xgrid; xtitle('FERM-4','t','S')

// OPTIMIZAR S0 para MAXIMIZAR VXfin

S0test = 1:0.1:20; // g/L

for i = 1:length(S0test)
    S0 = S0test(i);  
    x = ode(xini,0,t,f);
    VXfin(i) = x(2,$);
end

[VXfinmax,indexVXfinmax] = max(VXfin)
S0opt = S0test(indexVXfinmax)

scf(4); clf(4);  
plot(S0test,VXfin,'ro',S0opt,VXfinmax,'x')
xgrid; xtitle('FERM-04','S0','VXfin')
