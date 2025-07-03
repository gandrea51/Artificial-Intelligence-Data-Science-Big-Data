% Heat: Explicit scheme
clear; close all; clc;

% Condizioni sulla stabilità
%cfl=0.6;
%nt = 120;

lg = 10.;                   % Semi-lunghezza dello spazio computazionale (da -lg a +lg).
dx = 0.05;                  % Dimensione della mesh spaziale (passo spaziale).
nx = lg / dx;               % Numero di punti per metà dello spazio (dall'origine a lg).
cfl = 0.4;                  % Numero di Courant-Friedrichs-Lewy (CFL) per la stabilità.
dt = dx * dx * cfl;         % Passo temporale in base al dx e al CFL (per la stabilità dello schema esplicito).
Tfinal = 0.5;               % Tempo finale della simulazione.
nt = floor(Tfinal / dt);    % Numero totale di passi temporali interi per raggiungere Tfinal.

%% Inizializzazione
x = zeros(1, 2 * nx + 1);   % Inizializza un vettore di zeri per i punti nello spazio (da -lg a +lg).
u0 = zeros(1, 2 * nx + 1);  % Inizializza un vettore di zeri per il dato iniziale della soluzione.

%% Ciclo per popolare i punti spaziali 'x' e il dato iniziale 'u0'.
for i = 1 : 2 * nx + 1
  x(i) = (i - nx - 1) * dx;           % Calcola la coordinata x per ogni punto, centrando l'intervallo attorno a zero.
  u0(i) = max(0., 1. - x(i) ^ 2);     % Definisce il dato iniziale (una parabola capovolta troncata a 0).
end

u = u0;                     % Assegna il dato iniziale alla soluzione corrente 'u'.
up = u0;                    % Inizializza 'up' (soluzione con shift a destra) con il dato iniziale.
um = u0;                    % Inizializza 'um' (soluzione con shift a sinistra) con il dato iniziale.
uexact = u0;                % Inizializza 'uexact' (soluzione esatta) con il dato iniziale (sarà ricalcolata).

plot(x,u0,'linewidth',2)    % Crea un grafico del dato iniziale in funzione di x con una linea spessa.
title(['Dato iniziale'])    % Imposta il titolo del grafico.

%% Ciclo principale di avanzamento temporale
for n = 1 : nt
    % Calcola i vettori 'up' e 'um' che rappresentano la soluzione shiftata a destra e sinistra.
    % La funzione 'shift' è una funzione ausiliaria sposta gli elementi del vettore 'u' a destra (up) o a sinistra (um) per implementare
    % le differenze finite centrate.
    up = shift(1, u);       % Sposta la soluzione 'u' di un passo a destra.
    um = shift(-1, u);      % Sposta la soluzione 'u' di un passo a sinistra.

    % Applica lo schema esplicito alle differenze finite per l'equazione del calore.
    u = u + dt / (dx * dx) * (up + um -2 * u);

    % Se il numero di passi temporali è un multiplo di 5, aggiorna il grafico.
    if rem(n, 5) == 0
        clf()                                   % Cancella il contenuto della figura corrente.
        plot(x,u,x,u0,'linewidth',2)            % Traccia la soluzione corrente 'u' e il dato iniziale 'u0'.
        title('Schema esplicito, cfl=0.4');     % Imposta il titolo del grafico.
        pause(0.01);                            % Mette in pausa l'esecuzione per un breve periodo per visualizzare l'animazione.
    end
end

%% Confronto con la soluzione pseudo-esatta
uexact = zeros(1, 2 * nx + 1);                      % Inizializza un vettore per la soluzione esatta (integrale).

% Ciclo per calcolare la soluzione esatta usando l'integrale di convoluzione.
for i = 1 : 2 * nx + 1                              % Itera su ogni punto nello spazio per calcolare uexact(i).
    for j = 1 : 2 * nx + 1                          % Itera su ogni punto dello spazio per l'integrazione.
         
         t = nt * dt;                               % Calcola il tempo finale della simulazione.
         y = (j - nx - 1) * dx;                     % Calcola la coordinata y (variabile di integrazione) corretta.
         x1 = (i - nx - 1) * dx;                    % Calcola la coordinata x (punto di valutazione) corretta.
         
         % Aggiunge il contributo dell'integrale per il punto (i) e la variabile di integrazione (j).
         % La formula originale nello script aveva un errore nell'uso di uo(j) (dovrebbe essere u0(j))
         % e nella coordinata y e x1 per la valutazione dell'esponenziale.
         % Assumendo che 'uo(j)' sia un errore di battitura per 'u0(j)':
         uexact(i) = uexact(i) + u0(j) * dx * exp(-(x1 - y) ^ 2 / (4 * t));
    end
    
    uexact(i) = uexact(i) / sqrt(4 * pi * nt * dt);     % Normalizza l'integrale con il fattore 1/sqrt(4*pi*t).
end

plot(x,u,x,uexact,x,u0,'linewidth',2)                   % Traccia la soluzione calcolata, quella esatta e il dato iniziale.
legend('computed','exact','initial')                    % Aggiunge una legenda al grafico.
title('Schema esplicito, cfl=0.4, 500 time steps');     % Imposta il titolo finale del grafico.