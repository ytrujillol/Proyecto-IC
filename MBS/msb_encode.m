function stego = msb_encode(coverImg, message)
% MSB_ENCODE Inserta 'message' en el bit más significativo (MSB) de coverImg.
%   stego = msb_encode(coverImg, message)

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
    msgLen   = uint32(numel(msgBytes));  % longitud en bytes (32 bits)

    lenBytes = typecast(msgLen, 'uint8');
    bitsLen  = bytes2bits(lenBytes);
    bitsMsg  = bytes2bits(msgBytes);
    bitstream = [bitsLen; bitsMsg];      % concatenamos cabecera + datos

    % Aplanar imagen
    pixels = cover(:);
    capacity = numel(pixels);
    nbits = numel(bitstream);

    if nbits > capacity
        error('Capacidad insuficiente: %d bits requeridos, %d disponibles.', nbits, capacity);
    end

    % Escribir en el bit más significativo
    pixels(1:nbits) = bitset(pixels(1:nbits), 8, bitstream);

    % Reconstruir imagen
    stego = reshape(pixels, size(cover));
end

function bits = bytes2bits(u8)
    n = numel(u8);
    bits = zeros(n*8,1,'uint8');
    idx = 1;
    for k = 1:n
        b = u8(k);
        for bit = 0:7
            bits(idx) = bitget(b, bit+1); % LSB→MSB
            idx = idx + 1;
        end
    end
end