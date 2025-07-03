% Modello SIR - Simulazione tramite Metodo di Eulero Esplicito
clear; close all; clc;

% Parametri del modello
beta = 0.2;      % Tasso di trasmissione dell'infezione
gamma = 0.1;     % Tasso di guarigione
N_pop = 1000;    % Popolazione totale (costante)

%% Condizioni temporali
t0 = 0;          % Tempo iniziale
T = 10;          % Tempo finale
N = 400;         % Numero di intervalli (passi di simulazione)
h = (T - t0)/N;  % Passo temporale

%% Inizializzazione dei vettori temporali e delle variabili
t = linspace(t0, T, N+1);   % Vettore dei tempi

S = zeros(1, N+1);          % Vettore dei suscettibili
I = zeros(1, N+1);          % Vettore degli infetti
R = zeros(1, N+1);          % Vettore dei guariti

%% Condizioni iniziali del modello
S(1) = N_pop - 10;          % Inizialmente suscettibili
I(1) = 10;                  % Numero iniziale di infetti
R(1) = 0;                   % Nessun guarito all'inizio

%% Metodo di Eulero per l'integrazione numerica del sistema
for i = 1:N
    % Derivata della componente S: tasso di diminuzione dei suscettibili
    dS = -beta * S(i) * I(i);
    
    % Derivata della componente I: nuovi infetti meno i guariti
    dI = beta * S(i) * I(i) - gamma * I(i);
    
    % Derivata della componente R: i guariti in funzione degli infetti
    dR = gamma * I(i);
    
    % Aggiornamento delle variabili usando Eulero esplicito
    S(i+1) = S(i) + h * dS;
    I(i+1) = I(i) + h * dI;
    R(i+1) = R(i) + h * dR;
end

%% Visualizzazione dei risultati
figure;
plot(t, S, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Suscettibili (S)');
hold on;
plot(t, I, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Infetti (I)');
plot(t, R, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Guariti (R)');
xlabel('Tempo (t)');
ylabel('Numero di individui');
title('Modello SIR con Metodo di Eulero Esplicito');
legend('Location', 'northeast');
grid on;
