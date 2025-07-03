%% Compressione immagini con decomposizione SVD
clear; close all; clc;

% Lettura immagine e sistemazione dati in una matrice
A=imread('dog.jpg');

% Trasforma l'immagine in scale di grigi
X=double(rgb2gray(A));

% Numero di righe, Numero di colonne
nx = size(X,1);
ny = size(X,2);

% Fare il plot dell'immagine in scala di grigi comando imagesc
figure
imagesc(X);
axis off;
colormap gray; 
title('Original image');

%% Fare la decomposizione SVD comando svd
[U, S, V] = svd(X);

% Scegliere dei valori del rango r=[]
r = [5, 20, 50, 100];

for i = 1:length(r)
    % Calcolare l'approssimazione colonne da 1:r
    Xapprox = U(:,1:r(i)) * S(1:r(i), 1:r(i)) * V(:, 1:r(i))';

    % Plot dell'immagine approssimata
    figure
    imagesc(Xapprox);
    axis off;
    colormap gray;
    title(['Rank= ', num2str(r(i))]);

    % Calcolo del costo computazionale (nx*ny costo totale)
    memoria(i) = r(i) * (nx + ny +1);
end

%% Plot dei valori singolari in scala semilogaritmica
figure 
semilogy(diag(S), 'o-');
grid on;
xlabel('r');
ylabel('Singular values, \sigma_r');
title('Singular values graphic');