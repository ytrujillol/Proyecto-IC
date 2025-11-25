function message = lsb_decode(stegoImg)

    % Carga imagen
    if ischar(stegoImg) || isstring(stegoImg)
        stego = imread(stegoImg);
    else
        stego = stegoImg;
    end

    stego = uint8(stego);
    pixels = stego(:);
    capacity = numel(pixels);

    % Lee la semilla
    seedPos = 1:32;
    seedBits = uint8(bitget(pixels(seedPos), 1));
    seedBytes = bits2bytes(seedBits);
    rngSeed = typecast(uint8(seedBytes), 'uint32');

    % Lee el tamaño
    lenPos = 33:64;
    lenBits = uint8(bitget(pixels(lenPos), 1));
    lenBytes = bits2bytes(lenBits);
    msgLen = double(typecast(uint8(lenBytes), 'uint32'));

    msgBitsCount = msgLen * 8;

    if 64 + msgBitsCount > capacity
        error("Header erróneo");
    end

    % Recrea la distrubición del encoder
    rng(double(rngSeed));

    available = 65:capacity;
    msgPos = available(randperm(numel(available), msgBitsCount));

    % Descifra el mensage
    msgBits = uint8(bitget(pixels(msgPos), 1));
    msgBytes = bits2bytes(msgBits);

    message = char(msgBytes(:)).';
end

% Helper
function u8 = bits2bytes(bits)
    nbits = numel(bits);
    if mod(nbits,8) ~= 0
        error('Fallo en bits2bytes. Debe ser divisible por 8');
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