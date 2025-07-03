% Ottimizzazione: Stochastic Gradient Descent
clear; close all; clc;

%% Generazione di dati sintetici: y = 3*x + rumore
n = 100;                                % Numero di campioni
x_data = linspace(0, 10, n)';           % Vettore colonna con valori di x da 0 a 10
y_data = 3 * x_data + randn(n, 1);      % Valori di y con pendenza 3 e rumore gaussiano

theta = 0;                              % Inizializzazione del parametro (pendenza della retta)
alpha = 0.01;                           % Learning rate (passo di aggiornamento)
epochs = 2;                             % Numero di epoche (quante volte si vede l'intero dataset)

theta_history = theta;                  % Vettore per memorizzare l'evoluzione di theta

%% Ciclo principale di Stochastic Gradient Descent
for epoch = 1:epochs
    idx = randperm(n);                              % Mescola gli indici dei dati per ogni epoca (SGD)

    for i = 1:n
        x_i = x_data(idx(i));                       % Estrae un campione x in ordine casuale
        y_i = y_data(idx(i));                       % Estrae il corrispondente y

        grad_i = -2 * x_i * (y_i - theta * x_i);    % Gradiente del costo per il singolo esempio: grad = -2*x*(y - theta*x)
        theta = theta - alpha * grad_i;             % Aggiornamento del parametro con il gradiente calcolato
        
        theta_history(end+1) = theta;               % Salva il valore di theta per tracciare la sua evoluzione
    end
end

% Visualizzazione del parametro finale
fprintf('Parametro ottimale trovato: theta = %.4f\n', theta);

%% Grafico dei dati originali e della retta ottenuta con il theta finale
figure;
scatter(x_data, y_data, 20, 'b', 'filled'); hold on;  % Dati rumorosi
plot(x_data, theta * x_data, 'r-', 'LineWidth', 2);   % Retta di regressione
title('SGD: Regressione lineare su dati rumorosi');
xlabel('x'); ylabel('y');
legend('Dati', 'Fit finale', 'Location', 'best');
grid on;

% Grafico dell’evoluzione del parametro theta durante l’apprendimento
figure;
plot(theta_history, 'LineWidth', 1.5);
xlabel('Iterazione'); ylabel('\theta');
title('Convergenza del parametro \theta con SGD');
grid on;
