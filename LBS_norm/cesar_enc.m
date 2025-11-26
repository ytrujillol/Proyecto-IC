function out = cesar_enc(plain, k)
% CESAR_ENC  Cifra con César sobre A–Z (convierte a mayúsculas).
%   OUT = CESAR_ENC(PLAIN, K)

    if nargin < 2, k = 3; end
    k = mod(k, 26);                   % normaliza la clave a [0,25]
    abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    plain = upper(char(plain));       % asegura tipo char y mayúsculas

    n = numel(plain);
    out = blanks(n);                  % preasigna

    for i = 1:n
        ch = plain(i);
        idx = find(abc == ch, 1);     % primera coincidencia
        if ~isempty(idx)
            out(i) = abc(mod(idx - 1 + k, 26) + 1);
        else
            out(i) = ch;              % deja espacios, números, signos, tildes, etc.
        end
    end
end