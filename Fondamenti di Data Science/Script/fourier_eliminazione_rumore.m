% Fourier: Eliminazione rumore
clear; close all; clc;

dt = .001;                              % Passo temporale
t = 0:dt:1;                             % Tempo
x = sin(2*pi*50*t) + sin(2*pi*120*t);   % Segnale
x_noisy = x + 2*randn(size(t));         % Aggiungere del rumore normale

%% Calcolare la trasformata di fourier: utilizzare il comando fft e dare la lunghezza del vettore x
N = length(x_noisy);
Y = fft(x_noisy, N);

%   Calcolare l'energia del sistema: detto spettro di potenza. 
%   Si calcola tramite prodotto scalare coefficienti (slide 30) normalizzato per la dimensione del vettore
PSD = Y .* conj(Y) / N;

% Determinare i valori superiori a 100
indices = PSD > 100;

% Mettere uguali a zero tutti i coefficienti con valori minori
PSDclean = PSD .* indices;
Y = indices .* Y;

% Calcolare la trasformata inversa ifft
yfilt = ifft(Y);

Fs = 1/dt;
freq = Fs*(0:(N/2))/N;

%% Fare il plot del segnale originale e del segnale pulito
plot(-1000,-1000,'k','LineWidth',1.5)
hold on
plot(-1000,-1000,'r','LineWidth',1.2)
plot(t,x_noisy,'r','LineWidth',1.2)
plot(t,x,'k-o','LineWidth',1.5)
axis([0 .25 -5 5])
legend('Segnale pulito','Segnale con rumore')
title('Segnale e segnale con rumore')


figure
plot(t,x,'k','LineWidth',1.5)
hold on
plot(t,yfilt,'b','LineWidth',1.2)
axis([0 .25 -5 5])
legend('Segnale pulito','Segnale filtrato')
title('Segnale e segnale filtrato')


figure
plot(freq(2:floor(N/2)+1),PSD(2:floor(N/2)+1),'r','LineWidth',1.5)
hold on
plot(freq(2:floor(N/2)+1),PSDclean(2:floor(N/2)+1),'-b','LineWidth',1.2)
legend('Coeff. Fourier con rumore','Coeff. filtrati')
title('Intensità del segnale')
