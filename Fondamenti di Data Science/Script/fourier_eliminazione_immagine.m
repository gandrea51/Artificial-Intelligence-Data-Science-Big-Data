% Fourier: Eliminazione rumore da immagini
clear; close all; clc; 

%   La FFT è ampiamente utilizzata per la riduzione del rumore e il filtraggio dei segnali, poiché è semplice
%   isolare e manipolare particolari bande di frequenza. Introduciamo un filtro di soglia FFT per la riduzione 
%   del rumore di un'immagine con rumore gaussiano aggiunto. In questo esempio, si osserva che il rumore è 
%   particolarmente pronunciato nelle alte frequenze e pertanto azzeriamo qualsiasi coefficiente di Fourier 
%   al di fuori di un dato raggio contenente basse frequenze.

A = imread('dog.jpg');      % Lettura dell'immagine
B = rgb2gray(A);            % Trasformazione dell'immagine in scala di grigi
imshow(B)                   % Plot image
title('Original image')

% Introduciamo del rumore gaussiano
Bnoise = B + uint8(30*randn(size(B))); 

% Mostrare immagine con rumore
figure 
imshow(Bnoise)
title('Noisy image')

%% Trasformata di Fourier
Bt = fft2(double(Bnoise));

% Introdurre una griglia della dimensione della matrice B
[nx,ny] = size(B);
[X,Y] = meshgrid(-ny/2+1:ny/2,-nx/2+1:nx/2); 
% Questo comando mette le frequenze basse al centro della matrice
Btshift = fftshift(Bt);

% Calcolare un raggio al di fuori del quale azzerare le frequenze
R2 = X.*2 + Y.*2;

% Mettere uguale a zero gli indici con frequenze maggiori di un certo raggio
ind = R2 < 60^2;

% Azzerare le frequenze che corrispondono all'indice ind
Btshiftfilt = Btshift .* ind;

% Riordiniamo le frequenze come erano prima
Btfilt = ifftshift(Btshiftfilt);

%% Ritorniamo nello spazio fisico
Bfilt = ifft2(double(Btshift));

figure
imagesc(uint8(real(Bfilt)))
title('Filtered image')
colormap gray
set(gcf,'Position',[100 100 600 800])