%% Fourier: Compressione immagine 
clear; close all; clc;

%% Lettura dell'immagine
A = imread('dog.jpg');
% Trasformazione dell'immagine in scala di grigi
B = rgb2gray(A); 

%% Trasformata di fourier dell'immagine
Bt = fft2(B);
% Ordinamento per frequenza prendere il valore assolutio
Btsort = sort(abs(Bt(:)));

%% Ciclo per la compressione
perct = [.1 .05 .02 .005];
for k = 1:4
    figure

    % Percentuale delle frequenze da eliminare
    keep = perct(k);
    
    % Scegliere un valore di soglia
    thresh = Btsort(floor((1-keep)*length(Btsort))); 
    % Azzerrare gli indici che superano il valore di soglia
    ind = abs(Bt) > thresh;
    
    % Costruzione della matrice che contiene solo i valori sopra soglia
    Atlow = Bt .* ind;
    
    % Ritorno alle variabili fisiche
    Alow=uint8(ifft2(Atlow)); 
    imshow(Alow)
    title(['Immagine compressa con percentuale di frequenze elimnate= ', num2str(keep)])

end