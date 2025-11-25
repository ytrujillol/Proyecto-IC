function message = msb_decode(stegoImg)

    % Carga imagen
    if ischar(stegoImg) || isstring(stegoImg)
        stego = imread(stegoImg);
    else
        stego = stegoImg;
    end

    if ~isa(stego, 'uint8')
        error('La imagen debe ser uint8');
    end

    pixels = stego(:);
    capacity = numel(pixels);

    % Inicialización
    seedPos = 1:32;
    lenPos  = 33:64;

    seedBits = uint8(bitget(pixels(seedPos), 8));
    seedBytes = bits2bytes(seedBits);
    rngSeed = typecast(uint8(seedBytes), 'uint32');

    % Mensaje
    lenBits = uint8(bitget(pixels(lenPos), 8));
    lenBytes = bits2bytes(lenBits);
    msgLen = double(typecast(uint8(lenBytes), 'uint32'));

    msgBitsCount = msgLen * 8;
    if 64 + msgBitsCount > capacity
        error("Header erroneo");
    end

    % Recalcular posiciones del encoder
    rng(double(rngSeed));

    available = 65:capacity;
    msgPos = available(randperm(numel(available), msgBitsCount));

    % Descifrar el mensaje
    msgBits = uint8(bitget(pixels(msgPos), 8));
    msgBytes = bits2bytes(msgBits);

    message = char(msgBytes(:)).';

end

% Helper
function u8 = bits2bytes(bits)
    nbits = numel(bits);
    if mod(nbits,8) ~= 0
        error('Fallo en convertir bits a bytes. No es divisible entre 8');
    end

    nbytes = nbits/8;
    u8 = zeros(1,nbytes,'uint8');
    idx = 1;

    for k = 1:nbytes
        v = uint8(0);
        for bit = 0:7
            if bits(idx)
                v = bitset(v, bit+1);
            end
            idx = idx + 1;
        end
        u8(k) = v;
    end
end