function stego = lsb_encode(coverImg, message)
    
    % Carga imagen
    if ischar(coverImg) || isstring(coverImg)
        cover = imread(coverImg);
    else
        cover = coverImg;
    end

    cover = uint8(cover);
    pixels = cover(:);
    capacity = numel(pixels);

    % Mensaje a bits
    msgBytes = uint8(message);
    msgLen   = uint32(numel(msgBytes));

    lenBytes = typecast(msgLen, 'uint8');
    bitsLen  = bytes2bits(lenBytes);
    bitsMsg  = bytes2bits(msgBytes);

    rngSeed = uint32(randi([0 2^32-1]));
    seedBytes = typecast(rngSeed, 'uint8');
    bitsSeed  = bytes2bits(seedBytes);

    headerBits = 32 + 32;
    msgBitsCount = numel(bitsMsg);
    totalNeeded = headerBits + msgBitsCount;

    if totalNeeded > capacity
        error("Capacidad faltante: %d bits son necesarios, hay %d", totalNeeded, capacity);
    end

    % Header
    seedPos = 1:32;
    lenPos  = 33:64;

    for i = 1:32
        pixels(seedPos(i)) = bitset(pixels(seedPos(i)), 1, bitsSeed(i));
    end

    for i = 1:32
        pixels(lenPos(i)) = bitset(pixels(lenPos(i)), 1, bitsLen(i));
    end

    % Distribución uniforme
    rng(double(rngSeed));

    available = 65:capacity;

    msgPos = available(randperm(numel(available), msgBitsCount));

    for i = 1:msgBitsCount
        pixels(msgPos(i)) = bitset(pixels(msgPos(i)), 1, bitsMsg(i));
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