% Metodo di Runge-Kutta del 4° ordine per dy/dt = y * cos(t)
clear; close all; clc; 

% Definizione della funzione differenziale f(t, y) = y * cos(t)
f = @(t, y) y * cos(t);

%% Condizioni iniziali del problema
t0 = 0;                 % Tempo iniziale
y0 = 1;                 % Valore iniziale y(t0)
T = 10;                 % Tempo finale
N = 20;                 % Numero di suddivisioni (passi)
h = (T - t0) / N;       % Calcolo del passo temporale

%% Inizializzazione dei vettori tempo e soluzione numerica
t = linspace(t0, T, N+1);  % Vettore dei tempi equidistanti
y = zeros(1, N+1);         % Preallocazione del vettore delle soluzioni
y(1) = y0;                 % Assegna la condizione iniziale

%% Implementazione del metodo Runge-Kutta 4° ordine
for n = 1:N
    % Calcolo dei coefficienti intermedi k1, k2, k3, k4
    k1 = f(t(n), y(n));
    k2 = f(t(n) + h/2, y(n) + h/2 * k1);
    k3 = f(t(n) + h/2, y(n) + h/2 * k2);
    k4 = f(t(n) + h,   y(n) + h * k3);

    % Formula del metodo RK4 per avanzare alla prossima y
    y(n+1) = y(n) + h/6 * (k1 + 2*k2 + 2*k3 + k4);
end

% Calcolo della soluzione esatta per confronto: y(t) = exp(sin(t))
y_exact = exp(sin(t));

%% Grafico delle soluzioni
figure;
plot(t, y, 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');                       % Soluzione numerica
hold on;
plot(t, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Soluzione esatta');   % Soluzione analitica
xlabel('t');
ylabel('y(t)');
title('Soluzione di dy/dt = y cos(t) con RK4');
legend('Location', 'northwest');
grid on;
