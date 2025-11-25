function message = msb_decode(stegoImg)
    % MSB sequential decoder with safety checks
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

    % --- read length (32 bits) from positions 1..32 ---
    nLenBits = 32;
    if capacity < nLenBits
        error('Imagen demasiado pequeña para contener la cabecera.');
    end

    lenBits = uint8(bitget(pixels(1:nLenBits), 8));
    lenBytes = bits2bytes(lenBits);
    msgLen = double(typecast(uint8(lenBytes), 'uint32')); % bytes, as double for checks

    % Sanity checks: ensure message can fit
    totalMsgBits = msgLen * 8;
    totalBits = nLenBits + totalMsgBits;
    if totalBits > capacity
        error('Cabecera inválida o corrupta: msgLen = %d bytes -> requiere %d bits, capacidad %d.', ...
              msgLen, totalBits, capacity);
    end

    % Additional guard: avoid absurd sizes (optional threshold)
    maxAllowedBytes = floor((capacity - nLenBits) / 8);
    if msgLen > maxAllowedBytes
        error('Cabecera inválida: msgLen (%d) excede máximo razonable (%d).', msgLen, maxAllowedBytes);
    end

    % --- read message bits sequentially ---
    msgBits = uint8(bitget(pixels(nLenBits+1 : nLenBits+totalMsgBits), 8));
    msgU8 = uint8(bits2bytes(msgBits));

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
