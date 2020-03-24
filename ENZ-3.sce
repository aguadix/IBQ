clear; clc;
// ENZ-3.sce
// REACTOR ENZIMÁTICO CONTINUO CON ENZIMA CONFINADA
// Con desactivación enzimática

// SISTEMA DE ECUACIONES DIFERENCIALES
function dxdt = f(t,x)
    // Variables diferenciales
    S = x(1)
    E = x(2)
    // Velocidad de reacción para el sustrato
    rS = -k*E*S/(KM+S)
    // Balance de sustrato
    // d(V*S) = F*S0 - F*S + rS*V
    dSdt = F*(S0-S)/V + rS
    // Velocidad de reacción para la enzima
    rE = -kd*E
    // Balance de enzima
    // d(V*E) = F*E0 + rE*V
    dEdt = F*E0/V + rE
    // Derivadas
    dxdt(1) = dSdt
    dxdt(2) = dEdt
endfunction

// CONDICIONES INICIALES
Sini = 10; // mmol/L
Eini = 0.5; // mmol/L
xini = [Sini;Eini];

// CONSTANTES
V = 10; // L
F = 1; // L/h
S0 = 10; // mmol/L
KM = 0.5; // mmol/L
k = 0.5; // h-1
kd = 0.1; // h-1
//  dEdtini = F*E0/V + rEini = 0 => E0 = -rEini*V/F
E0 = kd*Eini*V/F  // mmol/L

// TIEMPO
tfin = 200; dt = 0.01; t = 0:dt:tfin; // h

// RESOLVER
x = ode(xini,0,t,f);
xfin = x(:,$);
dxdtfin = f(tfin,xfin)
Estacionario = abs(dxdtfin ./ xfin) < 1E-5

S = x(1,:); See = S($)
E = x(2,:); Eee = E($)

// GRÁFICAS
scf(1); clf(1);
plot(t,S);
xgrid; xtitle('ENZ-3','t','S');

scf(2); clf(2);
plot(t,E);
xgrid; xtitle('ENZ-3','t','E');
