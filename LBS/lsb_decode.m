function message = lsb_decode(stegoImg)
    % Leer imagen
    if ischar(stegoImg) || isstring(stegoImg)
        stego = imread(stegoImg);
    else
        stego = stegoImg;
    end

    if ~isa(stego,'uint8')
        error('La imagen debe ser uint8 (8 bits por canal).');
    end

    pixels = stego(:);
    capacity = numel(pixels);

    % ---------------------------------------------------------
    % Paso 1: Recuperar longitud del mensaje (32 bits)
    %         Usando indices igual que el encoder
    % ---------------------------------------------------------

    nLenBits = 32;

    % Obtener posiciones equiespaciadas para los 32 bits de longitud
    posLen = round(linspace(1, capacity, nLenBits));

    lenBits = uint8(bitget(pixels(posLen),1));
    lenBytes = bits2bytes(lenBits);
    msgLen = typecast(uint8(lenBytes),'uint32');

    % ---------------------------------------------------------
    % Paso 2: Recuperar los bits del mensaje usando el mismo patron
    % ---------------------------------------------------------
    totalMsgBits = double(msgLen) * 8;

    % Posiciones para el mensaje completo (cabecera + datos)
    totalBits = nLenBits + totalMsgBits;

    % Obtener todas las posiciones
    allPositions = round(linspace(1, capacity, totalBits));

    % Posiciones que corresponden al mensaje (excluyendo la cabecera)
    posMsg = allPositions(nLenBits+1 : end);

    % Extraer bits del mensaje
    msgBits = uint8(bitget(pixels(posMsg),1));

    msgU8 = uint8(bits2bytes(msgBits));

    % Convertir a texto
    message = char(msgU8(:)).';
end


% Convierte columna de bits (LSB primero por byte) -> vector uint8
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
            if bits(idx) == 1
                val = bitset(val, bit+1);
            end
            idx = idx + 1;
        end
        u8(k) = val;
    end
end
