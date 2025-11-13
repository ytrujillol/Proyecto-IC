function out = cesar_dec(cipher, k)
    if nargin < 2, k = 3; end
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    cipher = upper(cipher);
    out = '';
    for i = 1:length(cipher)
        idx = find(abc == cipher(i));
        if ~isempty(idx)
            out(i) = abc(mod(idx - 1 - k, 26) + 1);
        else
            out(i) = cipher(i);
        end
    end
end
