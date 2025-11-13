function out = vigenere_dec(cipher, key)
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    cipher = upper(cipher);
    key = upper(key);
    out = '';
    for i = 1:length(cipher)
        idx = find(abc == cipher(i));
        if ~isempty(idx)
            k = find(abc == key(mod(i-1, length(key)) + 1)) - 1;
            out(i) = abc(mod(idx - 1 - k, 26) + 1);
        else
            out(i) = cipher(i);
        end
    end
end
