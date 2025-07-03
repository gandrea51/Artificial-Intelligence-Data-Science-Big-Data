% Ottimizzazione vincolata: Esercizio 3
clear; close all; clc;

%% Funzione obiettivo (quadratica semplice): Minimizziamo la distanza da (3,2)
f = @(x) 0.5*(x(1) - 3)^2 + (x(2) - 2)^2;

%% Vincoli di disuguaglianza (g(x) ≤ 0): Tradotti in penalità con max(0, g(x))^2
g1 = @(x) -2*x(1) + x(2);         % -2x1 + x2 ≤ 0
g2 = @(x) x(1) + x(2) - 4;        % x1 + x2 ≤ 4 → riscritta come x1 + x2 - 4 ≤ 0
g3 = @(x) -x(2);                  % x2 ≥ 0 → riscritta come -x2 ≤ 0

% Somma delle penalità associate ai vincoli
penalty = @(x) max(0, g1(x))^2 + max(0, g2(x))^2 + max(0, g3(x))^2;

%% Funzione penalizzata (metodo delle penalità esterne)
mu = 1e-1;                                          % Primo valore del parametro di penalizzazione
penalized_f = @(x, mu) f(x) + (1/mu) * penalty(x);  % Obiettivo penalizzato

%% Parametri iniziali per l'ottimizzazione
x0 = [3; 2];                                % Punto iniziale (vicino al minimo della funzione non vincolata)
mu_vals = [1e-1, 1e-2, 1e-3, 1e-4];         % Valori decrescenti di penalizzazione
x_vals = x0;                                % Tracciamento dei punti a ogni iterazione

%% Ottimizzazione per valori successivi di mu: Utilizza fminunc (ottimizzatore unconstrained)
options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'off');

for mu = mu_vals
    obj = @(x) penalized_f(x, mu);       % Definisce la funzione penalizzata per questo mu
    x0 = fminunc(obj, x0, options);      % Minimizza la funzione penalizzata
    x_vals = [x_vals, x0];               % Salva il nuovo punto ottimo trovato
end

%% Visualizzazione dei risultati
figure;
hold on;

% Griglia per il contour della funzione obiettivo
[xg, yg] = meshgrid(linspace(-1, 4, 400), linspace(-1, 4, 400));
Z = 0.5*(xg - 3).^2 + (yg - 2).^2;                                  % Valori della funzione obiettivo
contour(xg, yg, Z, 30, 'LineWidth', 1.2);                           % Contour lines
colormap('parula');
colorbar;
xlabel('x'); ylabel('y');
title('Penalizzazione per vincoli di disuguaglianza');
axis equal; grid on;

%% Visualizza i vincoli come curve implicite
fimplicit(@(x, y) -2*x + y, [-1 4 -1 4], 'r--', 'LineWidth', 1.5, 'DisplayName', '-2x + y \leq 0');
fimplicit(@(x, y) x + y - 4, [-1 4 -1 4], 'b--', 'LineWidth', 1.5, 'DisplayName', 'x + y \leq 4');
fimplicit(@(x, y) -y, [-1 4 -1 4], 'g--', 'LineWidth', 1.5, 'DisplayName', 'y \geq 0');

%% Visualizza la traiettoria delle iterazioni
plot(x_vals(1,:), x_vals(2,:), 'ko--', 'DisplayName', 'Iterazioni');                % Traiettoria iterativa
scatter(x_vals(1,1), x_vals(2,1), 50, 'b', 'filled', 'DisplayName', 'Inizio');      % Punto iniziale
scatter(x_vals(1,end), x_vals(2,end), 50, 'r', 'filled', 'DisplayName', 'Ottimo');  % Punto finale
legend('Location', 'bestoutside');                                                  % Legenda esterna per chiarezza
