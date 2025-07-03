% Equazione del calore in 2 dimensioni - Schema Esplicito
clear; close all; clc;

%% Inizializzazione
Lx = 1;                           % Lunghezza del dominio in direzione x (es. 1 metro).
Ly = 1;                           % Lunghezza del dominio in direzione y (es. 1 metro).
dx = 0.025;                       % Dimensione della mesh spaziale (passo di discretizzazione) in direzione x.
dy = 0.025;                       % Dimensione della mesh spaziale (passo di discretizzazione) in direzione y.
cfl = 0.4;                        % Numero di Courant-Friedrichs-Lewy (CFL). Questo parametro è CRITICO per la STABILITÀ degli schemi espliciti. 
                                  %     Per l'equazione del calore 2D, la condizione di stabilità è dt * (1/dx^2 + 1/dy^2) <= 0.5.
nx = Lx / dx;                     % Numero di intervalli della mesh in direzione x.
ny = Ly / dy;                     % Numero di intervalli della mesh in direzione y.

%% Calcolo del passo temporale (dt) basato sulla condizione di stabilità dello schema esplicito 2D.

% dt <= 0.5 / (1/dx^2 + 1/dy^2). Utilizzando cfl < 0.5 si garantisce la stabilità.
dt = cfl / (1 / dx^2 + 1 / dy^2); 
Tfinal = 0.01;                    % Tempo finale di simulazione.
nt = floor(Tfinal/dt);            % Numero intero di passi temporali necessari per raggiungere Tfinal.
%nt = 20;                         % Opzione per impostare un numero fisso di cicli temporali,
                                  %     utile per test rapidi indipendentemente da Tfinal e dt.

%% Dati iniziali
x = zeros(1, nx + 1);             % Inizializza un vettore per le coordinate dei punti della griglia in direzione x.
y = zeros(1, ny + 1);             % Inizializza un vettore per le coordinate dei punti della griglia in direzione y.

% Inizializza la matrice 'u0' che conterrà i valori iniziali della temperatura (o altra quantità).
% Le dimensioni sono (nx+1) righe per (ny+1) colonne.
% Il primo indice ('i') si riferisce allo spostamento lungo x, il secondo ('j') lungo y.
% ATTENZIONE: In MATLAB, il primo indice è la riga e il secondo è la colonna. Quindi u0(i,j)
% significa che 'i' è la riga (corrispondente a x) e 'j' è la colonna (corrispondente a y).
u0 = zeros(nx + 1, ny + 1);             

% Cicli annidati per popolare i vettori delle coordinate 'x' e 'y' e la matrice 'u0'.
for i = 1 : nx + 1                      % Ciclo sulle coordinate x (dal primo al (nx+1)-esimo punto).
    x(i) = dx * (i - 1);                % Calcola la coordinata x per il punto i.
    
    for j = 1 : ny + 1                  % Ciclo sulle coordinate y (dal primo al (ny+1)-esimo punto).
        y(j) = (j - 1) * dy;            % Calcola la coordinata y per il punto j.
        
        % Definisce la condizione iniziale della temperatura.
        % È una "gobba" con un picco al centro del dominio (0.5, 0.5), troncata a zero se negativa.
        u0(i, j) = max(0, 1 - 500 * (x(i) - 0.5) ^ 2 - 500 * (y(j) - 0.5) ^ 2);
    end
end

surf(u0)                                % Visualizza la condizione iniziale come una superficie 3D.

%% Schema esplicito
u = u0;                                 % Inizializza la soluzione 'u' al tempo attuale con la condizione iniziale 'u0'.

% Ciclo principale di avanzamento temporale.
for iter = 1 : nt
    % Cicli annidati per iterare su tutti i punti interni della griglia.
    % Gli indici partono da 2 e arrivano a nx/ny-1 per evitare i bordi,
    %   dove le condizioni al contorno dovrebbero essere applicate o considerate.
    %   In questo script, i bordi sono implicitamente impostati a non cambiare (zero Neumann)
    %   o a mantenere il loro valore iniziale (zero Dirichlet), a seconda di come si interpreta la formula.
   
    for i = 2 : nx              % Itera sull'indice x, escludendo i bordi estremi (i=1 e i=nx+1).
        for j = 2 : ny          % Itera sull'indice y, escludendo i bordi estremi (j=1 e j=ny+1).
            
            % Applica lo schema esplicito alle differenze finite per l'equazione del calore 2D.
            % L'equazione è: u_t = D * (u_xx + u_yy)
            % La discretizzazione è:
            % u(i,j)_new = u(i,j)_old + dt * [ (u(i+1,j) + u(i-1,j) - 2*u(i,j))/dx^2  (parte di u_xx)
            %                                 + (u(i,j+1) + u(i,j-1) - 2*u(i,j))/dy^2 ] (parte di u_yy)
            % Qui si assume D=1 (coefficiente di diffusione).

            u(i, j) = u(i, j) + dt * ((u(i+1, j) + u(i-1, j) - 2*u(i, j)) / (dx * dx) ...       % Contributo della diffusione in x
                                    + (u(i, j+1) + u(i, j-1) - 2*u(i, j)) / (dy * dy));         % Contributo della diffusione in y
        end
    end
    
    drawnow                 % Forza l'aggiornamento del grafico, utile per animazioni.
    surf(u)                 % Visualizza la soluzione 'u' al tempo corrente come una superficie 3D.
end