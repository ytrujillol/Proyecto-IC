function plain = elgamal_dec(cipher_bytes, K, p, return_char)
    if nargin < 3 || isempty(p), p = 257; end
    if nargin < 4, return_char = true; end

    % Asegura bytes 0..255
    c_bytes = uint8(char(cipher_bytes));  % si ya es uint8, no cambia

    % Inverso modular de K
    invK = modInverse(double(K), p);

    % Deshacer mapeo: (c+1)*K^{-1} mod p  -> 1..256  -> -1 -> 0..255
    c1     = double(c_bytes) + 1;      % 1..256
    m1     = mod(c1 .* invK, p);       % 1..256
    m_bytes = uint8(m1 - 1);           % 0..255

    if return_char
        plain = char(m_bytes(:)).';    % fila de chars
    else
        plain = m_bytes;
    end
end

% ---------- helpers locales ----------
function inv = modInverse(a, m)
    [g, x, ~] = gcd(a, m);
    if g ~= 1
        error('No existe inverso modular para K con el módulo dado.');
    end
    inv = mod(x, m);
end