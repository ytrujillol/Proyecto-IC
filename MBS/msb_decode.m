function message = msb_decode(stegoImg)
    % Leer imagen
    if ischar(stegoImg) || isstring(stegoImg)
        stego = imread(stegoImg);
    else
        stego = stegoImg;
    end

    if ~isa(stego, 'uint8')
        error('La imagen debe ser uint8 (8 bits por canal).');
    end

    pixels = stego(:);
    capacity = numel(pixels);

    % ---------------------------------------------------------
    % Paso 1: Recuperar longitud usando posiciones uniformes
    % ---------------------------------------------------------
    nLenBits = 32;

    posLen = round(linspace(1, capacity, nLenBits));

    lenBits = uint8(bitget(pixels(posLen), 8));
    lenBytes = bits2bytes(lenBits);
    msgLen = typecast(uint8(lenBytes), 'uint32');  % longitud en bytes

    % ---------------------------------------------------------
    % Paso 2: Recuperar bits del mensaje usando el mismo patrón
    % ---------------------------------------------------------
    totalMsgBits = double(msgLen) * 8;

    totalBits = nLenBits + totalMsgBits;

    % generar posiciones uniformes para toda la secuencia
    allPositions = round(linspace(1, capacity, totalBits));

    % posiciones correspondientes a los bits del mensaje
    posMsg = allPositions(nLenBits+1 : end);

    % extraer bits del MSB
    msgBits = uint8(bitget(pixels(posMsg), 8));

    msgU8 = uint8(bits2bytes(msgBits));

    % Convertir a texto
    message = char(msgU8(:)).';
end


function u8 = bits2bytes(bits)
    nbits = numel(bits);
    if mod(nbits,8) ~= 0
        error('Número de bits no múltiplo de 8.');
    end
    nbytes = nbits/8;
    u8 = zeros(1,nbytes,'uint8');
    idx = 1;
    for k = 1:nbytes
        val = uint8(0);
        for bit = 0:7
            if bits(idx)
                val = bitset(val, bit+1);
            end
            idx = idx + 1;
        end
        u8(k) = val;
    end
end
