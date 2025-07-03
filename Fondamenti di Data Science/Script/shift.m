%% Funzione di shift per simulare u_{i+1} e u_{i-1}
function array_shift = shift(dir, array_init)
    n = length(array_init);
    array_shift = zeros(1, n);
    
    if dir == 1
        % shift a destra: u_{i+1}
        array_shift(1 : n-1) = array_init(2 : n);
        array_shift(n) = array_init(n-1);      % Condizione di bordo: copia il penultimo valore
    elseif dir == -1
        % shift a sinistra: u_{i-1}
        array_shift(2 : n) = array_init(1 : n-1);
        array_shift(1) = array_init(2);        % Condizione di bordo: copia il secondo valore
    end
    
end