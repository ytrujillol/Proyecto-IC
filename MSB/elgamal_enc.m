function c_bytes = elgamal_enc(msg, K, p)
    if nargin < 3 || isempty(p), p = 257; end
    if nargin < 2
        error('Debes proporcionar K (clave compartida).');
    end
    % Asegura bytes 0..255
    m_bytes = uint8(char(msg));     % si ya es uint8, no se altera

    % Mapear a 1..256 y multiplicar mod p
    m1 = double(m_bytes) + 1;       % 1..256
    c  = mod(m1 .* double(K), p);   % 1..p-1 (para p=257 -> 1..256)
    c_bytes = uint8(c - 1);         % 0..255
end