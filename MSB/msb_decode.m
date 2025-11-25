function message = msb_decode(stegoImg)

    % --- load image ---
    if ischar(stegoImg) || isstring(stegoImg)
        stego = imread(stegoImg);
    else
        stego = stegoImg;
    end

    if ~isa(stego, 'uint8')
        error('Stego image must be uint8.');
    end

    pixels = stego(:);
    capacity = numel(pixels);

    % ===============================
    % 1) FIXED POSITIONS → READ SEED
    % ===============================
    seedPos = 1:32;
    lenPos  = 33:64;

    seedBits = uint8(bitget(pixels(seedPos), 8));
    seedBytes = bits2bytes(seedBits);
    rngSeed = typecast(uint8(seedBytes), 'uint32');

    % ===============================
    % 2) READ MESSAGE LENGTH
    % ===============================
    lenBits = uint8(bitget(pixels(lenPos), 8));
    lenBytes = bits2bytes(lenBits);
    msgLen = double(typecast(uint8(lenBytes), 'uint32'));

    msgBitsCount = msgLen * 8;

    % sanity
    if 64 + msgBitsCount > capacity
        error("Corrupted header: msgLen too large.");
    end

    % ===============================
    % 3) REBUILD SAME RANDOM POSITIONS
    % ===============================
    rng(double(rngSeed));

    available = 65:capacity;
    msgPos = available(randperm(numel(available), msgBitsCount));

    % ===============================
    % 4) READ MESSAGE BITS
    % ===============================
    msgBits = uint8(bitget(pixels(msgPos), 8));
    msgBytes = bits2bytes(msgBits);

    message = char(msgBytes(:)).';

end

function u8 = bits2bytes(bits)
    nbits = numel(bits);
    if mod(nbits,8) ~= 0
        error('bits2bytes: number of bits must be divisible by 8.');
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