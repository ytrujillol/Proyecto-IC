function out = sust_enc(plain)
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    key = 'QWERTYUIOPASDFGHJKLZXCVBNM';  % misma clave que en decifrado

    % (opcional) validación de clave:
    if numel(key) ~= 26 || numel(unique(key)) ~= 26
        error('La clave debe ser una permutación de 26 letras.');
    end

    plain = upper(char(plain));             % aceptar string/char
    n = numel(plain);
    out = blanks(n);                        % preasigna

    for i = 1:n
        ch = plain(i);
        idx = find(abc == ch, 1);          % busca en abecedario
        if ~isempty(idx)
            out(i) = key(idx);             % mapea abecedario -> clave
        else
            out(i) = ch;                   % deja espacios, números, signos, etc.
        end
    end
end