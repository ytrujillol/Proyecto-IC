function message = lsb_decode(stegoImg)
    % Leer imagen
    if ischar(stegoImg) || isstring(stegoImg)
        stego = imread(stegoImg);
    else
        stego = stegoImg;
    end

    pixels = stego(:);

    % ------------------ Longitud (32 bits) -------------------
    lenBits = uint8(bitget(pixels(1:32), 1));
    lenBytes = bits2bytes(lenBits);
    msgLen = typecast(uint8(lenBytes),'uint32');

    totalMsgBits = double(msgLen) * 8;

    % ------------------ Datos del mensaje ---------------------
    msgBits = uint8(bitget(pixels(33 : 32+totalMsgBits), 1));

    msgU8 = uint8(bits2bytes(msgBits));

    % Convertir a texto
    message = char(msgU8(:)).';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Helper: bits → bytes (LSB-first) ----------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u8 = bits2bytes(bits)
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
            if bits(idx)
                val = bitset(val, bit+1);
            end
            idx = idx + 1;
        end
        u8(k) = val;
    end
end
