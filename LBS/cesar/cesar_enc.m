function out = cesar(text, k)
    if nargin < 2, k = 3; end % default shift
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    text = upper(text);
    out = '';
    for i = 1:length(text)
        idx = find(abc == text(i));
        if ~isempty(idx)
            out(i) = abc(mod(idx - 1 + k, 26) + 1);
        else
            out(i) = text(i);
        end
    end
end
