function message = lsb_decode(stegoImg)
    % Leer imagen si se entregó ruta
    if ischar(stegoImg) || isstring(stegoImg)
        stego = imread(stegoImg);
    else
        stego = stegoImg;
    end

    if ~isa(stego,'uint8')
        error('La imagen debe ser uint8 (8 bits por canal).');
    end

    pixels = stego(:);

    % Recuperar longitud (primeros 32 bits)
    if numel(pixels) < 32
        error('Imagen demasiado pequeña para contener cabecera.');
    end
    lenBits = uint8(bitget(pixels(1:32),1));
    lenBytes = bits2bytes(lenBits);
    msgLen = typecast(uint8(lenBytes),'uint32');  % bytes de mensaje

    % Recuperar mensaje
    totalMsgBits = double(msgLen) * 8;
    startIdx = 32 + 1;
    endIdx   = 32 + totalMsgBits;

    if endIdx > numel(pixels)
        error('La imagen no contiene suficientes bits para el mensaje indicado.');
    end

    msgBits = uint8(bitget(pixels(startIdx:endIdx),1));
    msgU8   = uint8(bits2bytes(msgBits));

    % Convertir a texto (interpreta como UTF-8/ASCII)
    message = char(msgU8(:)).';
end

% ------- Helpers --------
function u8 = bits2bytes(bits)
% Convierte columna de bits (LSB primero por byte) -> vector uint8
    nbits = numel(bits);
    if mod(nbits,8) ~= 0
        error('El número de bits (%d) no es múltiplo de 8.', nbits);
    end
    nbytes = nbits/8;
    u8 = zeros(1,nbytes,'uint8');
    idx = 1;
    for k = 1:nbytes
        val = uint8(0);
        for bit = 0:7
            if bits(idx) == 1
                val = bitset(val, bit+1);
            end
            idx = idx + 1;
        end
        u8(k) = val;
    end
end
