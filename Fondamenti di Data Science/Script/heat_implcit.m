% Heat: Implicit scheme
clear; close all; clc;

lg = 10.;                   % Semi-lunghezza del dominio spaziale. Il dominio si estenderà da -lg a +lg.
dx = 0.05;                  % Dimensione della mesh spaziale, ovvero la distanza tra due punti consecutivi.
nx = round(lg / dx);        % Numero di intervalli in una metà del dominio (da 0 a lg), arrotondando al numero intero più vicino.
cfl = 2.;                   % Numero di Courant-Friedrichs-Lewy (CFL). Per gli schemi impliciti, questo valore può essere maggiore di 0.5.
dt = dx * dx * cfl;         % Passo temporale. Anche se la stabilità è incondizionata, un dt troppo grande può ridurre l'accuratezza.
Tfinal = 0.5;               % Tempo totale della simulazione.
nt = floor(Tfinal / dt);    % Numero di passi temporali interi necessari per raggiungere Tfinal.

%% Inizializzazione
x = zeros(1, 2 * nx + 1);       % Inizializza un vettore di zeri per i punti nello spazio (da -lg a +lg).
u0 = zeros(1, 2 * nx + 1);      % Inizializza un vettore di zeri per il dato iniziale della soluzione.

%% Ciclo per popolare i punti spaziali 'x' e il dato iniziale 'u0'.
for i = 1 : 2 * nx + 1
  x(i) = (i - nx - 1) * dx;           % Calcola la coordinata x per ogni punto, centrando l'intervallo attorno a zero.
  u0(i) = max(0., 1. - x(i) ^ 2);     % Definisce il dato iniziale (una parabola capovolta troncata a 0).
end

u = u0;             % Assegna il dato iniziale alla soluzione corrente 'u'.

%% Inizializzazione della matrice 'matr' per il sistema lineare.
% La dimensione è (2*nx + 1) x (2*nx + 1), corrispondente al numero totale di punti della mesh.
matr = zeros(2 * nx + 1, 2 * nx + 1);

%% Costruzione della matrice tridiagonale che rappresenta lo schema implicito.
% Questo ciclo costruisce la parte centrale della matrice.
for i = 2 : 2 * nx
    matr(i, i) = 1. + 2 * dt / (dx * dx);    % Elemento diagonale principale.
    matr(i, i+1) = - dt / (dx * dx);         % Elemento sulla diagonale superiore (a destra).
    matr(i, i-1) = - dt / (dx * dx);         % Elemento sulla diagonale inferiore (a sinistra).
end

% Gestione dei contorni (boundary conditions).
%   Queste righe definiscono le condizioni al contorno per il primo e l'ultimo punto.
%   Assumendo condizioni di contorno di Dirichlet (es. u(0) = u(L) = 0) o Neumann zero.
%   Il codice qui imposta una condizione implicita che riflette la formula centrale anche ai bordi,
%   il che potrebbe necessitare di aggiustamenti a seconda delle reali condizioni al contorno desiderate.
matr(1, 1) = 1. + 2 * dt / (dx * dx);                           % Elemento diagonale per il primo punto.
matr(1, 2) = - dt / (dx * dx);                                  % Elemento per il punto successivo (a destra) per il primo punto.
matr(2 * nx + 1, 2 * nx) = - dt / (dx * dx);                    % Elemento per il punto precedente (a sinistra) per l'ultimo punto.
matr(2 * nx + 1, 2 * nx + 1) = 1. + 2 * dt / (dx * dx);         % Elemento diagonale per l'ultimo punto.

%% Ciclo principale di avanzamento temporale.
for n = 1 : nt
    % Risoluzione del sistema lineare per ottenere la soluzione al passo temporale successivo.
    %   u_new = A^(-1) * u_old, dove A è la matrice 'matr'.
    %   L'uso di inv(matr) è computazionalmente costoso per matrici grandi;
    %   è preferibile usare la divisione inversa (matr \ u') per risolvere il sistema Ax=b.
    u = (matr ^ -1 * u')';                  % Calcola la soluzione al nuovo passo temporale invertendo la matrice e 
                                            %   moltiplicandola per il vettore soluzione precedente.

    % Aggiornamento della visualizzazione a intervalli regolari.
    if rem(n, 5) == 0                           % Aggiorna il grafico ogni 5 passi temporali.
        clf()                                   % Cancella il contenuto della figura corrente.
        plot(x,u,x,u0,'linewidth',2)            % Traccia la soluzione corrente e la condizione iniziale.
        title('Schema implicito, cfl 2');       % Imposta il titolo del grafico.
        pause(0.01);                            % Mette in pausa per 0.01 secondi per visualizzare l'animazione.
    end
end

%% Confronto con la Soluzione Pseudo-Esatta
uexact = zeros(1, 2 * nx + 1);                      % Inizializza un vettore per immagazzinare la soluzione esatta.

% Ciclo per calcolare la soluzione esatta usando l'integrale di convoluzione.
for i = 1 : 2 * nx + 1                              % Itera su ogni punto spaziale 'i' per calcolare uexact(i).
    for j = 1 : 2 * nx + 1                          % Itera su ogni punto spaziale 'j' per l'integrazione.

         t = nt * dt;                               % Calcola il tempo finale della simulazione.
         y = (j - nx - 1) * dx;                     % Calcola la coordinata y (variabile di integrazione) corretta.
         x1 = (i - nx - 1) * dx;                    % Calcola la coordinata x (punto di valutazione) corretta.

         uexact(i) = uexact(i) + u0(j) * dx * exp(-(x1 - y) ^ 2 / (4 * t));
    end

    uexact(i) = uexact(i) / sqrt(4 * pi * nt * dt); % Normalizza l'integrale con il fattore 1/sqrt(4*pi*t).
end

plot(x,u,x,uexact,x,u0,'linewidth',2)               % Genera un grafico che confronta la soluzione calcolata, quella esatta e la condizione iniziale.
legend('computed','exact','initial')                
title('Schema implicito, cfl 2, 500 time steps');   