% Ottimizzazione vincolata: Esercizio 1
clear; close all; clc;

%% Definizione della funzione obiettivo
% Funzione di Rosenbrock: noto test per ottimizzazione (non convessa, difficile da minimizzare)
f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;  

%% Vincolo di uguaglianza: (x + 0.5)^2 + (y + 0.5)^2 = 0.25 (cioè un cerchio centrato in (-0.5, -0.5) con raggio 0.5)
h = @(x) (x(1) + 0.5)^2 + (x(2) + 0.5)^2 - 0.25;

%% Funzione penalizzata: aggiunge il vincolo alla funzione obiettivo usando il metodo delle penalità quadratiche
penalized = @(x, mu) f(x) + (1/mu) * h(x)^2;

%% Parametri per l’ottimizzazione
mu_values = [1e-1, 1e-2, 1e-3, 1e-4];       % Valori della penalizzazione (più piccoli = vincolo più "rigido")
x_vals = zeros(length(mu_values)+1, 2);     % Per salvare i punti ottimali trovati
x0 = [1, 1];                                % Punto iniziale
x_vals(1, :) = x0;

% Impostazioni per l’ottimizzatore (quasi-Newton)
options = optimoptions('fminunc', 'Display','off', 'Algorithm', 'quasi-newton');

%% Ciclo di ottimizzazione con penalità decrescente
for i = 1:length(mu_values)
    
    mu = mu_values(i);                            % Penalizzazione corrente
    obj = @(x) penalized(x, mu);                  % Funzione da minimizzare
    x0 = fminunc(obj, x0, options);               % Minimizzazione unconstrained della funzione penalizzata
    x_vals(i+1, :) = x0;                          % Salva il punto ottenuto
end

%% Visualizzazione: contour plot della funzione di Rosenbrock
[xg, yg] = meshgrid(linspace(-1.5, 1.5, 100), linspace(-1.5, 1.5, 100));
F = 100*(yg - xg.^2).^2 + (1 - xg).^2;                  % Valori della funzione di Rosenbrock

figure;
contour(xg, yg, F, 30, 'LineWidth', 1.2); hold on;      % Linee di livello della funzione
colorbar;
xlabel('x'); ylabel('y');
title('Rosenbrock con vincolo circolare e iterazioni');
axis equal; grid on;

%% Vincolo: disegno del cerchio (vincolo di uguaglianza)
theta = linspace(0, 2*pi, 400);
xc = -0.5 + 0.5*cos(theta);             % X del cerchio
yc = -0.5 + 0.5*sin(theta);             % Y del cerchio
plot(xc, yc, 'r-', 'LineWidth', 2, 'DisplayName', 'Vincolo');

%% Traccia le iterazioni nel piano
plot(x_vals(:,1), x_vals(:,2), 'ko--', 'DisplayName', 'Iterazioni');                        % Tutti i punti trovati
plot(x_vals(1,1), x_vals(1,2), 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Inizio');      % Punto iniziale
plot(x_vals(end,1), x_vals(end,2), 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Fine');    % Punto finale
legend('Location', 'southeast');

%% Visualizzazione 3D della superficie
figure
surf(F)         % Superficie della funzione di Rosenbrock (senza coordinate esplicite perché sono implicite)
