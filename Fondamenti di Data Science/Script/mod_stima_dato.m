close all; clear; clc;

load('global_data.mat');

% Dati osservati
I_data = Iperc(1:end);          % Colonna
S_data = Sperc(1:end);
R_data = Rperc(1:end);
Nt = length(I_data);      T = Nt;       t_data = linspace(0, T, Nt);

%% Popolazione iniziale (normalizzata o percentuale)
y0 = [S_data(1), I_data(1), R_data(1)]; 
N_total = S_data(1) + I_data(1) + R_data(1); % Assicurati che sia 1 o la dimensione della popolazione

%% Ottimizzazione con finestre mobili (Sliding Window)
window_size = 30;   % Dimensione della finestra (e.g., 30 giorni)
step_size = 7;      % Passo della finestra (e.g., 7 giorni)

num_windows = floor((Nt - window_size) / step_size) + 1;

beta_history = zeros(num_windows, 1);
gamma_history = zeros(num_windows, 1);
window_start_times = zeros(num_windows, 1);

params0 = [0.3, 0.03]; % Stima iniziale per beta e gamma

fprintf('Inizio ottimizzazione con finestre mobili...\n');

for i = 1:num_windows
    idx_start = (i - 1) * step_size + 1;
    idx_end = idx_start + window_size - 1;

    if idx_end > Nt
        idx_end = Nt;
        idx_start = Nt - window_size + 1; % Adatta l'inizio per l'ultima finestra
    end
    if idx_start < 1
        idx_start = 1;
    end

    t_window = t_data(idx_start:idx_end);
    S_window = S_data(idx_start:idx_end);
    I_window = I_data(idx_start:idx_end);
    R_window = R_data(idx_start:idx_end);

    y0_window = [S_window(1), I_window(1), R_window(1)];

    % Assicurati che i dati non siano tutti zero per evitare errori nell'ottimizzazione
    if sum(I_window) == 0 && sum(R_window) == 0
        % Se non ci sono infetti o rimossi in questa finestra,
        % i parametri SIR classici potrebbero non essere ben definiti.
        % Potresti voler assegnare i valori precedenti o saltare.
        if i > 1
            beta_history(i) = beta_history(i-1);
            gamma_history(i) = gamma_history(i-1);
        else
            beta_history(i) = NaN; % O un valore predefinito
            gamma_history(i) = NaN;
        end
         window_start_times(i) = t_window(1);
        continue;
    end

    cost_func_window = @(params) sir_error(params, t_window, S_window, I_window, R_window, y0_window);

    % Ottimizzazione con fminsearch
    % Aumenta MaxIterations per una migliore convergenza in finestre più piccole
    options = optimset('fminsearch');
    options.MaxIterations = 500; % Aumenta il numero di iterazioni
    options.TolFun = 1e-6;       % Tolleranza sulla funzione obiettivo
    options.TolX = 1e-6;         % Tolleranza sui parametri

    % Gestione degli avvisi/errori di fminsearch
    try
        [params_opt_window, fval_window] = fminsearch(cost_func_window, params0, options);
    catch ME
        warning('Errore durante fminsearch nella finestra %d: %s\n', i, ME.message);
        params_opt_window = params0; % Usa i parametri iniziali in caso di errore
    end


    beta_history(i) = params_opt_window(1);
    gamma_history(i) = params_opt_window(2);
    window_start_times(i) = t_window(1);

    fprintf('Finestra %d (giorni %d-%d): Beta stimato = %.4f, Gamma stimato = %.4f\n', ...
            i, floor(t_window(1)), floor(t_window(end)), beta_history(i), gamma_history(i));

    % Aggiorna params0 per la prossima finestra per una convergenza più rapida
    params0 = params_opt_window;
end

fprintf('\nOttimizzazione completata.\n');

% Rimuovi eventuali NaN se ci sono state finestre problematiche
beta_history = beta_history(~isnan(beta_history));
gamma_history = gamma_history(~isnan(gamma_history));
window_start_times = window_start_times(~isnan(window_start_times));

%% Plot dei parametri stimati nel tempo
figure;
subplot(2,1,1);
plot(window_start_times, beta_history, 'b-o');
xlabel('Tempo (giorni)');
ylabel('Beta');
title('Valori ottimali di Beta nel tempo');
grid on;

subplot(2,1,2);
plot(window_start_times, gamma_history, 'r-o');
xlabel('Tempo (giorni)');
ylabel('Gamma');
title('Valori ottimali di Gamma nel tempo');
grid on;

%% Simulazione finale con parametri medi o con interpolazione dei parametri
% Per una simulazione finale, puoi usare una media dei parametri stimati
% oppure interpolare i parametri per avere valori continui.
% Qui useremo la media per semplicità o gli ultimi parametri stimati
% a seconda di come vuoi visualizzare il risultato finale.

beta_final = mean(beta_history);
gamma_final = mean(gamma_history);
fprintf('\nBeta medio stimato: %.4f\n', beta_final);
fprintf('Gamma medio stimato: %.4f\n', gamma_final);

sir_ode_final = @(t, y) [
    -beta_final * y(1) * y(2);
     beta_final * y(1) * y(2) - gamma_final * y(2);
     gamma_final * y(2)
];
[t_fit_final, y_fit_final] = ode45(sir_ode_final, t_data, y0);

%% Plot confronto finale
figure;
plot(t_data, I_data, 'ro', 'DisplayName', 'Infetti - dati'); hold on;
plot(t_fit_final, y_fit_final(:,2), 'r-', 'DisplayName', 'Infetti - modello (media)');
plot(t_data, S_data, 'bo', 'DisplayName', 'Suscettibili - dati');
plot(t_fit_final, y_fit_final(:,1), 'b-', 'DisplayName', 'Suscettibili - modello (media)');
plot(t_data, R_data, 'go', 'DisplayName', 'Rimossi - dati');
plot(t_fit_final, y_fit_final(:,3), 'g-', 'DisplayName', 'Rimossi - modello (media)');
legend('Location', 'best');
xlabel('Tempo'); ylabel('Percentuale / individui');
title('Fit del modello SIR ai dati osservati con parametri medi');
grid on;

