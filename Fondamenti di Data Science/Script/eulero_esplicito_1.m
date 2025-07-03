% Metodo di Eulero esplicito per dy/dt = y * cos(t)
clear; close all; clc;
%% Definizione della funzione f(t, y)
f = @(t, y) y * cos(t); 

%% Condizioni iniziali
t0 = 0;                 % Tempo iniziale
y0 = 1;                 % Valore iniziale
T = 10;                 % Tempo finale
N = 400;                % Numero di passi
h = (T - t0)/N;         % Passo temporale

%% Inizializzazione
t = linspace(t0, T, N+1);   % t: Vettore che contiene tutti i punti temporali da t0 a T, inclusi N+1 punti
y = zeros(1, N+1);          % y: valori approssimati di y ad ogni punto temporale

y(1) = y0;                  % Assegniamo il valore iniziale y0 al primo elemento del vettore y

%% Metodo di Eulero esplicito
for i = 1:N
    y(i+1) = y(i) + h * f(t(i), y(i));  % Applichiamo il metodo di Eulero esplicito
end
%% Soluzione esatta per confronto
y_exact = exp(sin(t));   % Calcoliamo la soluzione esatta dell'equazione differenziale per confrontarla con la nostra approssimazione.
                         % La soluzione esatta di dy/dt = y * cos(t) con condizione iniziale y(0) = 1 è y(t) = exp(sin(t)).
%% Plot dei risultati
figure;
plot(t, y, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Eulero esplicito');
hold on;                  
plot(t, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Soluzione esatta'); 
xlabel('t');             
ylabel('y(t)');          
title('Soluzione di dy/dt = y cos(t) con Eulero esplicito'); 
legend('Location', 'northwest'); 
grid on;                 