function stego = lsb_encode(coverImg, message)
    % Leer imagen si se entregó ruta
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
    msgLen   = uint32(numel(msgBytes));      % longitud en bytes (32 bits)

    % Empaquetar longitud (32 bits) y datos a un flujo de bits [0/1]
    lenBytes = typecast(msgLen,'uint8');     % 4 bytes (endianness local)
    bitsLen  = bytes2bits(lenBytes);
    bitsMsg  = bytes2bits(msgBytes);
    bitstream = [bitsLen; bitsMsg];          % columna de uint8

    % Capacidad
    pixels = cover(:);
    capacity = numel(pixels);                % 1 bit por píxel
    nbits = numel(bitstream);

    if nbits > capacity
        error('Capacidad insuficiente: se requieren %d bits y hay %d.', nbits, capacity);
    end

    % Escribir LSBs
    pixels(1:nbits) = bitset(pixels(1:nbits), 1, bitstream);

    % Reconstruir imagen
    stego = reshape(pixels, size(cover));
end

% ------- Helpers --------
function bits = bytes2bits(u8)
% Convierte vector uint8 -> columna de bits (LSB primero por byte)
    n = numel(u8);
    bits = zeros(n*8,1,'uint8');
    idx = 1;
    for k = 1:n
        b = u8(k);
        for bit = 0:7
            bits(idx) = bitget(b, bit+1);  % LSB primero
            idx = idx + 1;
        end
    end
end