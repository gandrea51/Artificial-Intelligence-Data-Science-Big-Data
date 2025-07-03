% Ottimizzazione: Confronto tra Metodo di Newton vs Gradient Descent per minimizzare f(x)
clear; close all; clc;

% Definizione della funzione obiettivo e delle sue derivate
f = @(x) x.^4 - 3*x.^3 + 2;          % Funzione da minimizzare
df = @(x) 4*x.^3 - 9*x.^2;           % Derivata prima (gradiente)
d2f = @(x) 12*x.^2 - 18*x;           % Derivata seconda (Hessiana nel caso unidimensionale)

x0 = 2;              % Punto iniziale comune per entrambi i metodi
tol = 1e-8;          % Tolleranza per il criterio di arresto (sul gradiente)
max_iter = 50;       % Numero massimo di iterazioni

%% Metodo di Newton
x_newton = x0;                                          % Inizializzazione della variabile
newton_hist = x_newton;                                 % Vettore per salvare i punti visitati

for i = 1:max_iter
    if abs(df(x_newton)) < tol                          % Arresto se il gradiente è sufficientemente piccolo
        break;
    end
    
    x_newton = x_newton - df(x_newton)/d2f(x_newton);   % Aggiornamento con il passo di Newton
    newton_hist(end+1) = x_newton;                      % Salvataggio del nuovo punto
end

%% Metodo del Gradient Descent
alpha = 0.01;             % Tasso di apprendimento (learning rate)
x_gd = x0;                % Inizializzazione
gd_hist = x_gd;           % Vettore per i punti visitati

for i = 1:max_iter
    if abs(df(x_gd)) < tol                  % Arresto se il gradiente è sufficientemente piccolo
        break;
    end
    
    x_gd = x_gd - alpha * df(x_gd);         % Aggiornamento con passo proporzionale al gradiente
    gd_hist(end+1) = x_gd;                  % Salvataggio del nuovo punto
end

%% Grafico della funzione e dei percorsi dei due metodi
x_vals = linspace(min([newton_hist gd_hist])-1, ...
    max([newton_hist gd_hist])+1, 500);                     % Asse x
y_vals = f(x_vals);                                         % Calcolo dei valori della funzione

figure;
plot(x_vals, y_vals, 'k-', 'LineWidth', 1.5); hold on;                                          % Grafico della funzione
plot(newton_hist, f(newton_hist), 'ro-', 'MarkerFaceColor', 'r', 'DisplayName', 'Newton');      % Newton
plot(gd_hist, f(gd_hist), 'bo-', 'MarkerFaceColor', 'b', 'DisplayName', 'Gradient Descent');    % Gradiente
legend('f(x)', 'Newton', 'Gradient Descent', 'Location', 'best');                               % Legenda
xlabel('x'); ylabel('f(x)');                                                                    % Etichette assi
title('Confronto: Metodo di Newton vs Gradient Descent');                                       % Titolo
grid on;                                                                                        % Mostra la griglia

%% Confronto del numero di iterazioni
fprintf('\nNumero di iterazioni:\n');
fprintf('Metodo di Newton: %d\n', numel(newton_hist) - 1);     % Iterazioni Newton
fprintf('Gradient Descent: %d\n', numel(gd_hist) - 1);         % Iterazioni GD
