function out = vig_dec(cipher, key)
    abc    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    cipher = upper(char(cipher));          % robustez: string/char
    key    = upper(char(key));

    % validación simple de clave: solo letras A–Z
    if any(~ismember(key, abc))
        error('La clave debe contener solo letras A–Z.');
    end

    n   = numel(cipher);
    out = blanks(n);                        % preasigna
    L   = numel(key);

    for i = 1:n
        ch  = cipher(i);
        idx = find(abc == ch, 1);
        if ~isempty(idx)
            k   = find(abc == key(mod(i-1, L) + 1), 1) - 1; % 0..25
            out(i) = abc(mod(idx - 1 - k, 26) + 1);
        else
            out(i) = ch;                    % preserva no-alfabéticos
        end
    end
end