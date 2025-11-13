function out = sustitucion_simple_dec(cipher)
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    key = 'QWERTYUIOPASDFGHJKLZXCVBNM'; % same key as encryption
    cipher = upper(cipher);
    out = '';
    for i = 1:length(cipher)
        idx = find(key == cipher(i));
        if ~isempty(idx)
            out(i) = abc(idx);
        else
            out(i) = cipher(i);
        end
    end
end
