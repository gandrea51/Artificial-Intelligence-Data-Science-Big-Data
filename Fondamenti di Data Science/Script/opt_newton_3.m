% Ottimizzazione: Metodo di Newton in 2D
clear; close all; clc;

% Definizione della funzione:
%       f(x,y) = (x - 2)^4 + (x - 2)^2 * y^2 + (y + 1)^2
% Derivata parziale rispetto x:
%       df/dx = 4(x-2)^3 + 2(x-2)y^2
% Derivata parziale rispetto y:
%       df/dy = 2y(x-2)^2 + 2(y+1)

f = @(v) (v(1)-2)^4 + (v(1)-2)^2*v(2)^2 + (v(2)+1)^2;

%% Definizione del gradiente (vettore delle derivate parziali)
grad_f = @(v) [4*(v(1)-2)^3 + 2*(v(1)-2)*v(2)^2;
               2*(v(1)-2)^2*v(2) + 2*(v(2)+1)];

%% Definizione della matrice hessiana (derivate seconde)
hess_f = @(v) [12*(v(1)-2)^2 + 2*v(2)^2,   4*(v(1)-2)*v(2);
               4*(v(1)-2)*v(2),           2*(v(1)-2)^2 + 2];

xk = [1; 1];        % Punto iniziale
tol = 1e-6;         % Tolleranza per arresto basato sul gradiente
max_iter = 30;      % Numero massimo di iterazioni
history = xk';      % Salva il percorso delle iterazioni (righe: punti)

fprintf('Iter\t x\t\t y\t\t f(x,y)\n');

%% Inizio del ciclo del metodo di Newton
for k = 1:max_iter
    
    if norm(grad_f(xk)) < tol           % Arresto se il gradiente è abbastanza piccolo
        break;
    end

    % Calcolo hessiana e gradiente nel punto corrente
    H = hess_f(xk);
    g = grad_f(xk);

    if det(H) < 1e-9                            % Verifica se la hessiana è mal condizionata o singolare
        warning("Hessiana quasi singolare")
        pk = -g;                                % Fallback: direzione del gradiente negativo
    else
        pk = -H\g;                              % Direzione di Newton: risolve H * pk = -g
    end    

    xk = xk + pk;                               % Aggiorna il punto
    history(end+1, :) = xk';                    % Salva il nuovo punto nel percorso
end

% Output dei risultati
fprintf('\nPunto stazionario trovato in: [%.6f, %.6f]\n', xk(1), xk(2));
fprintf('Valore funzione: f = %.6f\n', f(xk'));

%% Generazione del grafico di contorno della funzione
[X, Y] = meshgrid(linspace(-1, 3, 100), linspace(-2, 2, 100));
Z = (X-2).^4 + (X-2).^2.*Y.^2 + (Y+1).^2;

figure;
contour(X, Y, Z, 30); hold on;                              % Contour plot con 30 livelli
plot(history(:,1), history(:,2), 'ro-', 'LineWidth', 2, ...
    'MarkerFaceColor', 'r');                                % Percorso delle iterazioni
xlabel('x'); ylabel('y');
title('Metodo di Newton su $f(x,y) = (x-2)^4+(x-2)^2y^2+(y+1)^2$', ...
    'Interpreter', 'latex');                                % Titolo con LaTeX
legend('Livelli di f(x,y)', 'Iterazioni Newton', 'Location', 'best');
grid on;
axis equal;                                                 % Assicura proporzioni uniformi su x e y
