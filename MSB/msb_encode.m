function stego = msb_encode(coverImg, message)

    % Carga imagen
    if ischar(coverImg) || isstring(coverImg)
        cover = imread(coverImg);
    else
        cover = coverImg;
    end

    if ~isa(cover, 'uint8')
        error('Cover image must be uint8.');
    end

    pixels = cover(:);
    capacity = numel(pixels);

    % Convertir mensaje a bits
    msgBytes = uint8(message);
    msgLen   = uint32(numel(msgBytes));

    lenBytes = typecast(msgLen, 'uint8');
    bitsLen  = bytes2bits(lenBytes);
    bitsMsg  = bytes2bits(msgBytes);

    % Semilla RNG
    rngSeed  = uint32(randi([0 2^32-1]));
    seedBytes = typecast(rngSeed, 'uint8');
    bitsSeed  = bytes2bits(seedBytes);

    msgBitsCount = numel(bitsMsg);
    headerBits = 32 + 32;
    totalBits = headerBits + msgBitsCount;

    if totalBits > capacity
        error("Capacidad insuficiente: %d bits necesarios, hay %d", totalBits, capacity);
    end

    % Header
    seedPos = 1:32;
    lenPos  = 33:64;

    for i = 1:32
        pixels(seedPos(i)) = bitset(pixels(seedPos(i)), 8, bitsSeed(i));
    end

    for i = 1:32
        pixels(lenPos(i)) = bitset(pixels(lenPos(i)), 8, bitsLen(i));
    end

    % Distribuir unifomemente
    rng(double(rngSeed));

    available = 65:capacity;

    msgPos = available(randperm(numel(available), msgBitsCount));

    for i = 1:msgBitsCount
        pixels(msgPos(i)) = bitset(pixels(msgPos(i)), 8, bitsMsg(i));
    end

    stego = reshape(pixels, size(cover));

end

% Helper
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