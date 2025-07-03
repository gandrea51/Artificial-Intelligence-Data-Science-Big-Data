% Ottimizzazione: Metodo di Newton in una dimensione per ottimizzazione
clear; close all; clc;

%% Definizione della funzione obiettivo e delle sue derivate prima e seconda
f = @(x) x.^4 - 3*x.^3 + 2;          % Funzione da ottimizzare
df = @(x) 4*x.^3 - 9*x.^2;           % Derivata prima della funzione
d2f = @(x) 12*x.^2 - 18*x;           % Derivata seconda della funzione

x0 = 2;             % Punto iniziale per il metodo di Newton
tol = 1e-6;         % Tolleranza per il criterio di arresto
max_iter = 20;      % Numero massimo di iterazioni consentite

%% Inizializzazione delle variabili
x = x0;             % Valore iniziale
iter = 0;           % Contatore delle iterazioni
history = x;        % Vettore per salvare la storia dei punti visitati

% Stampa intestazione per l’output
fprintf('Iterazione\t x\t\t f(x)\n');
fprintf('%d\t\t %.6f\t %.6f\n', iter, x, f(x));

%% Ciclo del metodo di Newton
while abs(df(x)) > tol && iter < max_iter
    x = x - df(x)/d2f(x);                               % Formula di aggiornamento di Newton
    iter = iter +1;                                     % Incremento del contatore di iterazione
    history(end+1) = x;                                 % Salvataggio del nuovo punto
    fprintf('%d\t\t %.6f\t %.6f\n', iter, x, f(x));     % Output iterazione corrente
end

% Preparazione dei valori per il grafico della funzione
x_vals = linspace(min(history)-1, max(history)+1, 400);  % Asse x per il grafico
y_vals = f(x_vals);                                      % Valori di f(x) corrispondenti

%% Visualizzazione grafica della funzione e del percorso di Newton
figure;
plot(x_vals, y_vals, 'b-', 'LineWidth', 1.5); hold on;              % Grafico della funzione
plot(history, f(history), 'ro-', 'LineWidth', 1.5, ...              % Punti delle iterazioni
    'MarkerFaceColor', 'r');
xlabel('x'); ylabel('f(x)');                                        % Etichette degli assi
title('Metodo di Newton per l''ottimizzazione di f(x)');            % Titolo del grafico
grid on;                                                            % Griglia
legend('f(x)', 'Iterazioni Newton', 'Location', 'best');            % Legenda
