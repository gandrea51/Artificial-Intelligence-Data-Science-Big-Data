% Equazione differenziale: y'(t) = -15y(t); y(0) = 1
% Si tratta di un problema stiff per via dell'elevata costante negativa.
clear; clc; close all

%% Parametri del problema stiff
lambda = -15;             % Coefficiente stiff (molto negativo → soluzione decade rapidamente)
y0 = 1;                   % Valore iniziale
T = 1;                    % Tempo finale della simulazione
h = 0.05;                 % Passo temporale (fisso)
N = round(T / h);         % Numero di passi temporali
t = linspace(0, T, N+1);  % Vettore dei tempi (da 0 a T, con N+1 punti)

% Soluzione esatta del problema: y(t) = y0 * exp(lambda * t)
y_exact = y0 * exp(lambda * t);

%% Inizializzazione delle soluzioni numeriche
y_euler_exp = zeros(1, N+1);        % Vettore per Euler esplicito
y_euler_exp(1) = y0;                % Condizione iniziale

y_euler_imp = zeros(1, N+1);        % Vettore per Euler implicito
y_euler_imp(1) = y0;

y_crank_nic = zeros(1, N+1);        % Vettore per Crank-Nicolson (trapezi)
y_crank_nic(1) = y0;

%% Applicazione dei metodi numerici
for n = 1:N

    % === Metodo di Euler esplicito ===
    % Formula: y_{n+1} = y_n + h * f(t_n, y_n)
    y_euler_exp(n+1) = y_euler_exp(n) + h * lambda * y_euler_exp(n);

    % === Metodo di Euler implicito ===
    % Formula: y_{n+1} = y_n / (1 - h*lambda)
    y_euler_imp(n+1) = y_euler_imp(n) / (1 - h * lambda);

    % === Metodo di Crank–Nicolson (semi-implicito) ===
    % Formula: y_{n+1} = y_n * (1 + 0.5*h*lambda) / (1 - 0.5*h*lambda)
    a = 1 + 0.5 * h * lambda;
    b = 1 - 0.5 * h * lambda;
    y_crank_nic(n+1) = y_crank_nic(n) * (a / b);
end

%% Visualizzazione dei risultati
figure;
plot(t, y_exact, 'k-', 'LineWidth', 2); hold on;                        % Soluzione esatta
plot(t, y_euler_exp, 'r--o', 'DisplayName', 'Euler Esplicito');         % Euler esplicito
plot(t, y_euler_imp, 'b--s', 'DisplayName', 'Euler Implicito');         % Euler implicito
plot(t, y_crank_nic, 'g--d', 'DisplayName', 'Crank-Nicolson');          % Crank–Nicolson

legend('Location', 'northeast');
xlabel('t'); ylabel('y(t)');
title(['Confronto metodi numerici su problema stiff con h = ', num2str(h)]);
grid on;
