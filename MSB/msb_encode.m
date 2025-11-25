function stego = msb_encode(coverImg, message)
    % MSB sequential encoder (bit 8) with simple format: [32-bit length][data bits]
    if ischar(coverImg) || isstring(coverImg)
        cover = imread(coverImg);
    else
        cover = coverImg;
    end

    if ~isa(cover, 'uint8')
        error('La imagen debe ser uint8 (8 bits por canal).');
    end

    % flatten
    pixels = cover(:);

    % message -> bytes -> bits
    msgBytes = uint8(message);
    msgLen = uint32(numel(msgBytes));            % length in bytes

    lenBytes = typecast(msgLen, 'uint8');       % 4 bytes (little-endian)
    bitsLen  = bytes2bits(lenBytes);            % 32 bits
    bitsMsg  = bytes2bits(msgBytes);            % 8*msgLen bits

    bitstream = [bitsLen; bitsMsg];
    nbits = numel(bitstream);
    capacity = numel(pixels);

    if nbits > capacity
        error('Capacidad insuficiente: %d bits requeridos, %d disponibles.', nbits, capacity);
    end

    % --- sequential embedding (positions 1:nbits) ---
    positions = 1:nbits;
    pixels(positions) = bitset(pixels(positions), 8, bitstream);

    stego = reshape(pixels, size(cover));
end


function bits = bytes2bits(u8)
    % LSB-first inside each byte (same convention as user's original)
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
