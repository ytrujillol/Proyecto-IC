function stego = lsb_encode(coverImg, message)
    % Leer imagen
    if ischar(coverImg) || isstring(coverImg)
        cover = imread(coverImg);
    else
        cover = coverImg;
    end

    if ~isa(cover,'uint8')
        error('La imagen debe ser uint8 (8 bits por canal).');
    end

    % Convertir mensaje a bytes (UTF-8/ASCII)
    msgBytes = uint8(message);
    msgLen   = uint32(numel(msgBytes));

    % Empaquetar longitud (32 bits) y mensaje en flujo de bits
    lenBytes   = typecast(msgLen,'uint8');
    bitsLen    = bytes2bits(lenBytes);
    bitsMsg    = bytes2bits(msgBytes);
    bitstream  = [bitsLen; bitsMsg];

    % Capacidad total
    pixels   = cover(:);
    capacity = numel(pixels);
    nbits    = numel(bitstream);

    if nbits > capacity
        error('Capacidad insuficiente: se requieren %d bits y hay %d.', ...
              nbits, capacity);
    end

    % Distribuir uniformemente los bits (equiespaciados desde 1 hasta
    % capacidad)
    positions = round(linspace(1, capacity, nbits));
    positions = unique(positions);

    % Si se perdieron índices por redondeo, se añaden al final
    if numel(positions) < nbits
        missing = setdiff(1:nbits, 1:numel(positions));
        positions = [positions, missing + positions(end)];
    end

    % Escribir cada bit en el LSB del píxel correspondiente
    pixels(positions) = bitset(pixels(positions), 1, bitstream);

    % Reconstruir imagen final
    stego = reshape(pixels, size(cover));
end

% Convierte vector uint8 -> columna de bits (LSB primero por byte)
function bits = bytes2bits(u8)
    n = numel(u8);
    bits = zeros(n*8,1,'uint8');
    idx = 1;
    for k = 1:n
        b = u8(k);
        for bit = 0:7
            bits(idx) = bitget(b, bit+1);
            idx = idx + 1;
        end
    end
end
