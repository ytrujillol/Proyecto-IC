function message = msb_decode(stegoImg)
% MSB_DECODE Extrae mensaje oculto del MSB de 'stegoImg'.

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

    % Leer longitud (primeros 32 bits)
    lenBits = uint8(bitget(pixels(1:32), 8));
    lenBytes = bits2bytes(lenBits);
    msgLen = typecast(uint8(lenBytes), 'uint32');

    % Leer mensaje
    totalMsgBits = double(msgLen)*8;
    startIdx = 33;
    endIdx = 32 + totalMsgBits;

    if endIdx > numel(pixels)
        error('La imagen no contiene suficientes bits.');
    end

    msgBits = uint8(bitget(pixels(startIdx:endIdx), 8));
    msgU8   = uint8(bits2bytes(msgBits));
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
