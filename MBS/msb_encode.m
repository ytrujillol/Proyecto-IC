function stego = msb_encode(coverImg, message)
    % Leer imagen
    if ischar(coverImg) || isstring(coverImg)
        cover = imread(coverImg);
    else
        cover = coverImg;
    end

    if ~isa(cover, 'uint8')
        error('La imagen debe ser uint8 (8 bits por canal).');
    end

    % Convertir mensaje a bytes y bits
    msgBytes = uint8(message);
    msgLen   = uint32(numel(msgBytes));

    lenBytes  = typecast(msgLen, 'uint8');
    bitsLen   = bytes2bits(lenBytes);
    bitsMsg   = bytes2bits(msgBytes);
    bitstream = [bitsLen; bitsMsg];

    % Aplanar imagen
    pixels = cover(:);
    capacity = numel(pixels);
    nbits = numel(bitstream);

    if nbits > capacity
        error('Capacidad insuficiente: %d bits requeridos, %d disponibles.', ...
              nbits, capacity);
    end

    % ---------------------------------------------------------
    %  Distribuir bits uniformemente en toda la imagen
    % ---------------------------------------------------------
    positions = round(linspace(1, capacity, nbits));
    positions = unique(positions);

    % Añadir los índices que falten al final
    if numel(positions) < nbits 
        missing = nbits - numel(positions);
        positions = [positions, (positions(end)+1) : (positions(end)+missing)];
    end

    % ---------------------------------------------------------
    % Escribir en el MSB (bit 8)
    % ---------------------------------------------------------
    pixels(positions) = bitset(pixels(positions), 8, bitstream);

    % Reconstruir imagen final
    stego = reshape(pixels, size(cover));
end

% Convierte vector uint8 → columna de bits (LSB primero por byte)
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
