% Ottimizzazione: Mini-batch SGD per regressione lineare multivariata 
clear; close all; clc;

%% Dati sintetici
n = 200;                                    % Numero di campioni
d = 2;                                      % Numero di variabili indipendenti (feature)
X = randn(n, d);                            % Matrice X: campioni con 2 feature, distribuzione normale

theta_true = [2; -1];                       % Coefficienti veri: y = 2*x1 - 1*x2 + rumore
y = X * theta_true + 0.5 * randn(n, 1);     % Target y con rumore gaussiano

%% Inizializzazione Mini-batch SGD
theta = zeros(d, 1);                        % Parametri iniziali (theta1 e theta2)
alpha = 0.05;                               % Learning rate
epochs = 30;                                % Numero di epoche (ripetizioni dell'intero dataset)
batch_size = 20;                            % Dimensione del mini-batch

theta_history = theta';                     % Inizializza cronologia dei parametri (per grafico)

%% Ciclo Mini-batch SGD
for epoch = 1:epochs
    idx = randperm(n);                      % Mescola casualmente gli indici dei dati
    X_shuffled = X(idx, :);                 % Applica la permutazione a X
    y_shuffled = y(idx);                    % Applica la permutazione a y
    
    for i = 1:batch_size:n
        indices = i:min(i + batch_size - 1, n);     % Indici del batch corrente
        X_batch = X_shuffled(indices, :);           % Seleziona mini-batch di input
        y_batch = y_shuffled(indices);              % Seleziona mini-batch di output
        
        % Calcolo del gradiente medio sul mini-batch: grad = -1/m * X^T * (y - X*theta)
        grad = -(X_batch' * (y_batch - X_batch * theta)) / size(X_batch, 1);
        
        theta = theta - alpha * grad;               % Aggiornamento dei parametri con passo alpha
        theta_history(end+1, :) = theta';           % Salvataggio dei parametri per tracciarne la traiettoria
    end
end

%% Visualizzazione dei risultati
x1 = X(:, 1);              % Estrai prima feature
x2 = X(:, 2);              % Estrai seconda feature

% Crea una griglia per visualizzare i piani
[xg1, xg2] = meshgrid(linspace(min(x1), max(x1), 20), linspace(min(x2), max(x2), 20));

% Piano con i veri coefficienti
Z_true = theta_true(1)*xg1 + theta_true(2)*xg2;

% Piano con i coefficienti appresi
Z_final = theta(1)*xg1 + theta(2)*xg2;

%% Plot 3D dei dati e dei piani
figure;
scatter3(x1, x2, y, 30, 'b', 'filled'); hold on;                % Punti dati
mesh(xg1, xg2, Z_true, 'EdgeColor', 'g', 'FaceAlpha', 0.3);     % Piano vero (verde trasparente)
mesh(xg1, xg2, Z_final, 'EdgeColor', 'r', 'FaceAlpha', 0.3);    % Piano appreso (rosso trasparente)
xlabel('x_1'); ylabel('x_2'); zlabel('y');
legend('Dati', 'Piano vero', 'Piano appreso');
title('Mini-Batch SGD - Regressione lineare 3D');
grid on;
view(45, 25);                                                   % Vista angolata 3D

%% Plot dell’evoluzione dei parametri
figure;
plot(theta_history, 'LineWidth', 1.5);                          % Grafico della traiettoria di theta1 e theta2
xlabel('Iterazione'); ylabel('\theta');
legend({'\theta_1', '\theta_2'}, 'Location', 'best');
title('Convergenza dei parametri con Mini-Batch SGD');
grid on;
