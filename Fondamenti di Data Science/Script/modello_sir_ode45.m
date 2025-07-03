% Modello SIR- Soluzione numerica con ode45
clear; close all; clc;

%% Parametri del modello
beta = 0.3;         % Tasso di contagio (probabilità di trasmissione per contatto)
gamma = 0.1;        % Tasso di recupero (velocità con cui gli infetti guariscono)

%% Popolazione iniziale
N = 1;              % Popolazione totale normalizzata (N = 1 per lavorare in frazioni)
I0 = 1e-3;          % Frazione iniziale di infetti (0.001)
R0 = 0;             % Nessun rimesso/guarito inizialmente
S0 = N - I0 - R0;   % Suscettibili iniziali = tutto il resto della popolazione

%% Intervallo di simulazione (in giorni)
tspan = [0 120];    % Simulazione da 0 a 120 giorni

%% Definizione del sistema SIR come funzione anonima
sir_equations = @(t, y) [
    -beta * y(1) * y(2) / N;                % dS/dt: calo dei suscettibili
     beta * y(1) * y(2) / N - gamma * y(2); % dI/dt: variazione infetti
     gamma * y(2)                           % dR/dt: aumento dei rimossi
];

%% Condizioni iniziali del sistema
y0 = [S0; I0; R0];

%% Integrazione numerica con ode45 (Runge-Kutta adattivo di ordine 4/5)
[t, y] = ode45(sir_equations, tspan, y0);

%% Visualizzazione dei risultati
figure;
plot(t, y(:,1), 'b-', 'LineWidth', 2); hold on;   % Suscettibili
plot(t, y(:,2), 'r-', 'LineWidth', 2);            % Infetti
plot(t, y(:,3), 'g-', 'LineWidth', 2);            % Rimossi
xlabel('Tempo (giorni)');
ylabel('Numero di individui (frazione della popolazione totale)');
legend('Suscettibili', 'Infetti', 'Rimossi', 'Location', 'best');
title('Modello SIR - Simulazione epidemica con ode45');
grid on;
