% Ottimizzazione: Metodo Gradient Descent
clear; close all; clc;

% Prendere la funzione quadratica, f(x) = 0.5 * x' * Q * x - b' * x, definita nell'esempio pagina 34
Q = [2, 1; 1, 20];
b = [5; 3]; 

% Griglia per la visualizzazione
[x1, x2] = meshgrid(linspace(-4, 4, 100), linspace(-3, 3, 100));
z = zeros(size(x1));

% Valutazione della funzione su tutta la griglia
for i = 1:size(x1, 1)
    for j = 1:size(x1, 2)
        x = [x1(i,j); x2(i,j)];
        z(i,j) = 0.5*x'*Q*x - b'*x;
    end
end

%% Plot delle curve di livello
figure;
contour_levels = -10:10:50;
[C,h]=contourf(x1, x2, z,contour_levels);
clabel(C,h)
hold on;
colormap('parula');
colorbar;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
title('Curve di livello e iterazioni del metodo del gradiente', 'Interpreter', 'latex');
grid on;

%% Metodo del gradiente
x_k = [-3; -1];         % Punto iniziale
alpha = 0.085;          % Passo
max_iter = 30;          % Numero di iterazioni
iterazioni = x_k';      % Salva iterazioni per il plot

for k = 1:max_iter

    grad = Q*x_k -b;                    % Gradiente
    x_k = x_k - alpha*grad;             % Iterazioni
    iterazioni = [iterazioni; x_k'];    % Salvataggio iterazioni
end

%% Plot delle iterazioni
plot(iterazioni(:,1), iterazioni(:,2), '-o', 'LineWidth', 2, 'Color', 'r');

% Confrontare il risultato con fminsearch(f,[-3;1]);
f = @(x) 0.5 * x' * Q * x - b' * x;

% gradf = @(x) Q * x - b;
x_opt = fminsearch(@(x) f(x(:)), [-3; 1]);
plot(x_opt(1), x_opt(2), 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'g');

% Calcolo della differenza tra le soluzioni
differenza = norm(iterazioni(end, :)' - x_opt);

% Stampa della differenza nella Command Window (opzionale)
disp(['Norma della differenza: ', num2str(differenza)]);