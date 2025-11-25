function stego = lsb_encode(coverImg, message)
    % Leer imagen
    if ischar(coverImg) || isstring(coverImg)
        cover = imread(coverImg);
    else
        cover = coverImg;
    end

    cover = uint8(cover);
    pixels = cover(:);

    % Convertir mensaje a bytes
    msgBytes = uint8(message);
    msgLen   = uint32(numel(msgBytes));

    % Convertir longitud a bits
    lenBytes = typecast(msgLen, 'uint8');
    bitsLen  = bytes2bits(lenBytes);

    % Convertir mensaje a bits
    bitsMsg  = bytes2bits(msgBytes);

    % Construir flujo de bits total
    bitstream = [bitsLen; bitsMsg];
    nbits = numel(bitstream);

    % Chequeo de capacidad
    if nbits > numel(pixels)
        error("Mensaje demasiado grande para la imagen.");
    end

    % ★ Secuencial: posiciones 1..nbits
    pixels(1:nbits) = bitset(pixels(1:nbits), 1, bitstream);

    % Reconstruir imagen
    stego = reshape(pixels, size(cover));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Helper: bytes → bits (LSB-first) ----------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
