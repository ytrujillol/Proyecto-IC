function out = vig_enc(text, key)
    abc  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    text = upper(char(text));              % robustez: string/char
    key  = upper(char(key));

    if any(~ismember(key, abc))
        error('La clave debe contener solo letras A–Z.');
    end

    n   = numel(text);
    out = blanks(n);                        % preasigna
    L   = numel(key);

    for i = 1:n
        ch  = text(i);
        idx = find(abc == ch, 1);
        if ~isempty(idx)
            k   = find(abc == key(mod(i-1, L) + 1), 1) - 1; % 0..25
            out(i) = abc(mod(idx - 1 + k, 26) + 1);
        else
            out(i) = ch;                    % preserva no-alfabéticos
        end
    end
end