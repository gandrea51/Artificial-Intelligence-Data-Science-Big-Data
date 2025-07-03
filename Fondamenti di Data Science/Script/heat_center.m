% Heat: Center scheme - Unstable
clear; close all; clc;

lg = 10.;                   % Semi-lunghezza del dominio spaziale. Il dominio si estenderà da -lg a +lg.
dx = 0.05;                  % Dimensione della mesh spaziale, ovvero la distanza tra due punti consecutivi.
nx = round(lg / dx);        % Numero di intervalli in una metà del dominio (da 0 a lg), arrotondando al numero intero più vicino.
cfl = 0.1;                  % Numero di Courant-Friedrichs-Lewy (CFL). Questo valore è critico per la stabilità, ma in questo schema non basterà.
dt = dx * dx * cfl;         % Passo temporale. Per uno schema esplicito come quello di riferimento, questa formula deriva dalla condizione di stabilità.
Tfinal = 0.5;               % Tempo totale della simulazione.
nt = floor(Tfinal / dt);    % Numero di passi temporali interi necessari per raggiungere Tfinal.

%% Inizializzazione
x = linspace(-lg, lg, 2 * nx + 1);        % Crea un vettore di coordinate spaziali distribuite uniformemente da -lg a +lg, inclusi gli estremi.
u0 = exp(-x.^2);                          % Condizione iniziale della temperatura come una funzione Gaussiana.

u = u0;                                   % Inizializza 'u' (la soluzione al tempo attuale) con la condizione iniziale.
u1 = u0;                                  % 'u1' rappresenta la soluzione al passo temporale precedente ($u^{n-1}$).
u2 = u0;                                  % 'u2' rappresenta la soluzione due passi temporali prima ($u^{n-2}$).

% Prepara i vettori 'up' e 'um' per il calcolo delle differenze finite.
up = shift(1, u0);                        % Shift a destra
um = shift(-1, u0);                       % Shift a sinistra

%% Calcolo del primo passo temporale usando uno schema a due livelli
% Questo è necessario perché lo schema centrato (leapfrog) è a tre livelli e richiede i primi due stati per iniziare.
u1 = u0 + dt / (dx * dx) * (up + um - 2 * u0);

%% Ciclo principale di avanzamento temporale per lo schema centrato (leapfrog).
for n = 2 : nt
    % Calcola i vettori ' e 'um' basati sulla soluzione al passo precedente ($u^n$).
    up = shift(1, u1);
    um = shift(-1, u1);

    % Applica lo schema centrato (leapfrog) per l'equazione del calore.
    u = u2 + 2 * dt / (dx * dx) * (up + um - 2 * u1);
    
    % Aggiorna i vettori della soluzione per il prossimo passo temporale:
    u2 = u1;
    u1 = u;

    % Blocchi di codice per la visualizzazione periodica dei risultati.
    if rem(n, 1) == 0                           % Aggiorna il grafico ad ogni passo temporale (rem(n,1) è sempre 0).
        clf()                                       % Cancella il contenuto della figura corrente.
        plot(x, u, x, u0, 'LineWidth', 2)           % Traccia la soluzione corrente e la condizione iniziale.
        title('Schema centrale, clf = 0.1');        % Imposta il titolo del grafico. Notare che il titolo indica CFL=0.1, ma nello script è 0.4.
        pause(0.1);                                 % Mette in pausa per 0.1 secondi per un'animazione.
    end
end

%% Confronto con la soluzione pseudo-esatta
uexact = zeros(1, 2 * nx + 1);                      % Inizializza un vettore per immagazzinare la soluzione esatta.

% Ciclo per calcolare la soluzione esatta usando l'integrale di convoluzione.
for i = 1 : 2 * nx + 1                              % Itera su ogni punto spaziale 'i' per calcolare uexact(i).
    for j = 1 : 2 * nx + 1                          % Itera su ogni punto spaziale 'j' per l'integrazione.
        
        t = nt * dt;                                % Calcola il tempo finale della simulazione.
        y = (j - nx - 1) * dx;                      % Calcola la coordinata y (variabile di integrazione) corretta.
        x1 = (i - nx - 1) * dx;                     % Calcola la coordinata x (punto di valutazione) corretta.
        uexact(i) = uexact(i) + u0(j) * dx * exp(-((i-j) * dx) ^ 2 / (4 * nt * dt));
    end

    uexact(i) = uexact(i) / sqrt(4 * pi * nt * dt);      % Normalizza l'integrale.
end

plot(x, u, x, uexact, x, u0, 'linewidth', 2)       % Genera un grafico che confronta la soluzione calcolata, quella esatta e la condizione iniziale.
legend('computed','exact','initial')               % Aggiunge una legenda per identificare le curve nel grafico.
title('Schema centrale, cfl=0.4, 500 time steps'); % Imposta il titolo del grafico finale.