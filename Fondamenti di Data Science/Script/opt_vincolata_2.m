% Ottimizzazione vincolata: Esercizio 2
clear; close all; clc; 

%% Definizione della funzione obiettivo (Rosenbrock) e vincolo
f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;               % Funzione obiettivo: Rosenbrock
h = @(x) (x(1) + 0.5)^2 + (x(2) + 0.5)^2 - 0.25;             % Vincolo di uguaglianza: cerchio centrato in (-0.5, -0.5)

%% Parametri della penalizzazione
mu_values = [1e-1, 1e-2, 1e-3, 1e-4];                        % Valori decrescenti di penalizzazione mu
x0 = [1, 1];                                                 % Punto iniziale
x_vals = x0;                                                 % Salva tutti i punti finali per ogni valore di mu

%% Definizione della funzione di discesa del gradiente
function trajectory = gradient_descent(objective, start, step, max_iter)
    x = start;              % Punto iniziale
    trajectory = x;         % Inizializza la traiettoria

    for i = 1:max_iter
        gradient = num_gradient(objective, x);     % Calcola il gradiente numerico della funzione penalizzata
        x = x - step * gradient;                   % Aggiorna il punto (discesa nella direzione opposta al gradiente)
        trajectory = [trajectory; x];              % Memorizza il punto
    end
end

%% Funzione per il calcolo del gradiente numerico (centrata)
function gradient = num_gradient(func, point)
    eps = 1e-6;                             % Passo per derivata numerica
    gradient = zeros(size(point));          % Inizializza vettore gradiente

    for i = 1:length(point)
        d = zeros(size(point));
        d(i) = eps;                                                         % Perturba una sola variabile alla volta
        gradient(i) = (func(point + d) - func(point - d)) / (2 * eps);      % Derivata centrata
    end  
end

%% Ciclo principale: penalizzazione + discesa del gradiente
for mu = mu_values
    phi = @(x) f(x) + (1/mu)*h(x)^2;                            % Funzione penalizzata
    traj = gradient_descent(phi, x0, 0.01*mu, 5000);            % Discesa del gradiente sulla funzione penalizzata
    x0 = traj(end, :);                                          % Punto finale corrente diventa il nuovo x0
    x_vals = [x_vals; x0];                                      % Aggiunge alla lista dei risultati
end

%% Preparazione della griglia per il plot
[xg, yg] = meshgrid(linspace(-1.5, 1.5, 400), linspace(-1.5, 1.5, 400));
Z = 100*(yg - xg.^2).^2 + (1 - xg).^2;                          % Calcola i valori della funzione Rosenbrock

%% Costruzione del vincolo (cerchio)
theta = linspace(0, 2*pi, 400);
xc = -0.5 + 0.5*cos(theta);                                    % Coordinate x del cerchio
yc = -0.5 + 0.5*sin(theta);                                    % Coordinate y del cerchio

%% Visualizzazione grafica del risultato
figure;
contour(xg, yg, Z, 30, 'LineWidth', 1.2); hold on;             % Contour plot della funzione di costo
colorbar;
xlabel('x'); ylabel('y');
title('Penalizzazione + discesa del gradiente');
axis equal; grid on;

plot(xc, yc, 'r-', 'LineWidth', 2, 'DisplayName', 'Vincolo');                               % Traccia il vincolo
plot(x_vals(:,1), x_vals(:,2), 'ko--', 'DisplayName', 'Iterazioni');                        % Iterazioni dell’ottimizzazione
plot(x_vals(1,1), x_vals(1,2), 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Inizio');      % Punto iniziale
plot(x_vals(end,1), x_vals(end,2), 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Fine');    % Punto finale
legend('Location', 'southeast');
