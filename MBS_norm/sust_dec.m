function out = sust_dec(cipher)
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    key = 'QWERTYUIOPASDFGHJKLZXCVBNM';  % misma clave que en cifrado

    % (opcional) validación de clave:
    if numel(key) ~= 26 || numel(unique(key)) ~= 26
        error('La clave debe ser una permutación de 26 letras.');
    end

    cipher = upper(char(cipher));            % aceptar string/char
    n = numel(cipher);
    out = blanks(n);                         % preasigna

    for i = 1:n
        ch = cipher(i);
        idx = find(key == ch, 1);           % busca en la clave
        if ~isempty(idx)
            out(i) = abc(idx);              % mapea clave -> abecedario
        else
            out(i) = ch;                    % deja espacios, números, signos, etc.
        end
    end
end