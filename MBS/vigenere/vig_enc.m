function out = vigenere(text, key)
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    text = upper(text);
    key = upper(key);
    out = '';
    for i = 1:length(text)
        idx = find(abc == text(i));
        if ~isempty(idx)
            k = find(abc == key(mod(i-1, length(key)) + 1)) - 1;
            out(i) = abc(mod(idx - 1 + k, 26) + 1);
        else
            out(i) = text(i);
        end
    end
end
