function stego = msb_encode(coverImg, message)

    % --- load image ---
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

    % --- message to bits ---
    msgBytes = uint8(message);
    msgLen   = uint32(numel(msgBytes));

    lenBytes = typecast(msgLen, 'uint8');        % 4 bytes
    bitsLen  = bytes2bits(lenBytes);             % 32 bits
    bitsMsg  = bytes2bits(msgBytes);             % msgLen*8 bits

    % --- RNG SEED (4 bytes) ---
    rngSeed  = uint32(randi([0 2^32-1]));
    seedBytes = typecast(rngSeed, 'uint8');
    bitsSeed  = bytes2bits(seedBytes);           % 32 bits

    % --- Total needed bits ---
    msgBitsCount = numel(bitsMsg);
    headerBits = 32 + 32; % seed + length
    totalBits = headerBits + msgBitsCount;

    if totalBits > capacity
        error("Not enough capacity: need %d bits, have %d", totalBits, capacity);
    end

    % ===============================
    % 1) FIXED POSITIONS FOR HEADER
    % ===============================
    seedPos = 1:32;
    lenPos  = 33:64;

    % embed seed
    for i = 1:32
        pixels(seedPos(i)) = bitset(pixels(seedPos(i)), 8, bitsSeed(i));
    end

    % embed length
    for i = 1:32
        pixels(lenPos(i)) = bitset(pixels(lenPos(i)), 8, bitsLen(i));
    end

    % ===============================
    % 2) DISTRIBUTE MSG BITS RANDOMLY
    % ===============================
    rng(double(rngSeed)); % fixed seed generates reproducible randomization

    % available positions excluding the 64 header bits
    available = 65:capacity;

    % choose unique scattered positions
    msgPos = available(randperm(numel(available), msgBitsCount));

    for i = 1:msgBitsCount
        pixels(msgPos(i)) = bitset(pixels(msgPos(i)), 8, bitsMsg(i));
    end

    % output
    stego = reshape(pixels, size(cover));

end

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