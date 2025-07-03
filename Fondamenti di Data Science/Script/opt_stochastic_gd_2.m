% Ottimizzazione: Mini-batch SGD per regressione lineare (1D)
clear; close all; clc;

%% Generazione di dati sintetici: y = 3*x + rumore gaussiano
n = 100;                                 % Numero di dati
x_data = linspace(0, 10, n)';            % Vettore colonna di x, equidistanti tra 0 e 10
y_data = 3 * x_data + randn(n, 1);       % y = 3x + rumore

theta = 0;            % Stima iniziale del parametro (pendenza)
alpha = 0.01;         % Learning rate (passo di aggiornamento)
epochs = 2;           % Numero di epoche (quante volte si scorre l'intero dataset)
batch_size = 10;      % Dimensione del mini-batch

theta_history = theta;  % Salva la storia dei valori di theta per tracciarne l'evoluzione

%% Ciclo principale: Mini-batch SGD
for epoch = 1:epochs
    idx = randperm(n);             % Mescola casualmente gli indici dei dati
    x_shuffled = x_data(idx);      % Applica la permutazione a x
    y_shuffled = y_data(idx);      % Applica la permutazione a y

    % Ciclo su tutti i dati, a step di batch_size
    for i = 1:batch_size:n
        
        indices = i:min(i+batch_size-1, n);         % Estrae gli indici per il batch corrente

        x_batch = x_shuffled(indices);              % Estrae i dati del mini-batch
        y_batch = y_shuffled(indices);  

        % Calcola il gradiente medio sul mini-batch: grad = -2 * media su batch di [x_i * (y_i - theta * x_i)]
        grad_batch = -2 * mean(x_batch .* (y_batch - theta * x_batch));

        theta = theta - alpha * grad_batch;         % Aggiorna theta usando il gradiente del mini-batch
        theta_history(end+1) = theta;               % Salva il nuovo valore di theta per analisi successiva
    end
end

%% Stampa del valore finale del parametro trovato
fprintf('Parametro ottimale trovato: theta = %.4f\n', theta);

% Grafico dei dati originali e della retta ottenuta
figure;
scatter(x_data, y_data, 20, 'b', 'filled'); hold on;   % Dati originali
plot(x_data, theta * x_data, 'r-', 'LineWidth', 2);    % Retta appresa
title('Mini-batch SGD: Regressione lineare');
xlabel('x'); ylabel('y');
legend('Dati', 'Fit finale', 'Location', 'best');
grid on;

% Grafico dell'evoluzione di theta nel tempo
figure;
plot(theta_history, 'LineWidth', 1.5);
xlabel('Iterazione'); ylabel('\theta');
title('Convergenza del parametro \theta con mini-batch SGD');
grid on;
