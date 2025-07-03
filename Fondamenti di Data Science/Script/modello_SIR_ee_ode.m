% Modello SIR: Confronto tra Metodo di Eulero Esplicito e ODE45
clear; close all; clc;

%% Parametri del modello SIR
beta = 0.3;     % Tasso di trasmissione (contagio)
gamma = 0.1;    % Tasso di guarigione (rimozione)

%% Popolazione iniziale normalizzata (N = 1)
N = 1;
I0 = 1e-3;          % Frazione iniziale di infetti
R0 = 0;             % Nessun guarito all'inizio
S0 = N - I0 - R0;   % Suscettibili iniziali

%% Intervallo temporale della simulazione
T = 160;                        % Durata della simulazione (giorni)
h = 1;                          % Passo temporale per Eulero esplicito
t_euler = 0:h:T;                % Vettore dei tempi per Eulero
Nsteps = length(t_euler);       % Numero di step

%% Inizializzazione dei vettori per Eulero
S_euler = zeros(1, Nsteps);
I_euler = zeros(1, Nsteps);
R_euler = zeros(1, Nsteps);

% Condizioni iniziali
S_euler(1) = S0;
I_euler(1) = I0;
R_euler(1) = R0;

%% Integrazione con Metodo di Eulero Esplicito
for n = 1:Nsteps-1
    % Derivate secondo il modello SIR
    dS = -beta * S_euler(n) * I_euler(n);
    dI = beta * S_euler(n) * I_euler(n) - gamma * I_euler(n);
    dR = gamma * I_euler(n);
    
    % Aggiornamento delle variabili
    S_euler(n+1) = S_euler(n) + h * dS;
    I_euler(n+1) = I_euler(n) + h * dI;
    R_euler(n+1) = R_euler(n) + h * dR;
end

%% Integrazione con ODE45 (metodo adattivo integrato in MATLAB)
odefun = @(t, y) [...
    -beta * y(1) * y(2);                    % dS/dt
     beta * y(1) * y(2) - gamma * y(2);     % dI/dt
     gamma * y(2)];                         % dR/dt

% Risoluzione con ODE45
[t_ode, y_ode] = ode45(odefun, [0 T], [S0; I0; R0]);

%% Confronto grafico tra Eulero esplicito e ode45
figure;

subplot(3,1,1)
plot(t_ode, y_ode(:,1), 'b', t_euler, S_euler, 'b--');
ylabel('Suscettibili');
legend('ode45','Eulero','Location','northeast');
title('Confronto SIR - ode45 vs Eulero Esplicito');
grid on;

subplot(3,1,2)
plot(t_ode, y_ode(:,2), 'r', t_euler, I_euler, 'r--');
ylabel('Infetti');
legend('ode45','Eulero','Location','northeast');
grid on;

subplot(3,1,3)
plot(t_ode, y_ode(:,3), 'g', t_euler, R_euler, 'g--');
xlabel('Tempo (giorni)');
ylabel('Guariti/Rimossi');
legend('ode45','Eulero','Location','southeast');
grid on;
