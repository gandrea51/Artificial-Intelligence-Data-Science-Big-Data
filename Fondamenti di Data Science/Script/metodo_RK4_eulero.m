% Metodo di Runge-Kutta del 4° ordine e confronto con Eulero esplicito
clear; close all; clc;

% Definizione della funzione differenziale dy/dt = y * cos(t)
f = @(t, y) y * cos(t);

% Soluzione esatta del problema (per confronto): y(t) = exp(sin(t))
y_exact_fun = @(t) exp(sin(t));

%% Parametri iniziali del problema
T = 5;                              % Tempo finale
y0 = 1;                             % Condizione iniziale y(0)
Ns = [20 40 80 160 320 640];        % Numeri di passi da testare (diversi livelli di discretizzazione)

% Inizializzazione dei vettori per memorizzare errori e passi
errors_euler = zeros(size(Ns));  % Errori globali per Eulero
errors_rk4   = zeros(size(Ns));  % Errori globali per RK4
hs = zeros(size(Ns));            % Dimensione del passo h = T/N

% Ciclo su tutti i valori di N
for i = 1:length(Ns)
    N = Ns(i);       % Numero di suddivisioni
    h = T / N;       % Calcolo del passo
    hs(i) = h;
    t = linspace(0, T, N+1);  % Vettore temporale equidistante

    % ---------------------------
    % Metodo di Eulero esplicito
    % ---------------------------
    y_euler = zeros(1, N+1);  % Allocazione memoria
    y_euler(1) = y0;          % Condizione iniziale

    for n = 1:N
        % Formula di Eulero: y_{n+1} = y_n + h*f(t_n, y_n)
        y_euler(n+1) = y_euler(n) + h * f(t(n), y_euler(n));
    end

    % -------------------------------
    % Metodo di Runge-Kutta 4° ordine
    % -------------------------------
    y_rk4 = zeros(1, N+1);  % Allocazione memoria
    y_rk4(1) = y0;          % Condizione iniziale

    for n = 1:N
        % Calcolo dei coefficienti k1, k2, k3, k4 per RK4
        k1 = f(t(n), y_rk4(n));
        k2 = f(t(n) + h/2, y_rk4(n) + h/2 * k1);
        k3 = f(t(n) + h/2, y_rk4(n) + h/2 * k2);
        k4 = f(t(n) + h,   y_rk4(n) + h * k3);
        
        % Formula completa RK4
        y_rk4(n+1) = y_rk4(n) + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
    end

    % ------------------------------
    % Calcolo errore globale finale
    % ------------------------------
    y_true = y_exact_fun(T);                        % Valore esatto in T
    errors_euler(i) = abs(y_true - y_euler(end));   % Errore finale Eulero
    errors_rk4(i)   = abs(y_true - y_rk4(end));     % Errore finale RK4
end

%% Plot log-log degli errori globali rispetto a h
figure;
loglog(hs, errors_euler, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Eulero esplicito');
hold on;
loglog(hs, errors_rk4, 'rs--', 'LineWidth', 1.5, 'DisplayName', 'RK4');
xlabel('Passo h');
ylabel('Errore globale |y(T) - y_N|');
title('Confronto dell''errore globale: Eulero vs RK4');
legend('Location', 'southeast');
grid on;

%% Calcolo dell'ordine di convergenza con fit lineare nel log-log
p_euler = polyfit(log(hs), log(errors_euler), 1);               % Coefficiente angolare ≈ ordine
p_rk4   = polyfit(log(hs), log(errors_rk4), 1);

fprintf('Ordine di convergenza (Eulero): ~%.2f\n', p_euler(1));
fprintf('Ordine di convergenza (RK4): ~%.2f\n', p_rk4(1));
