function plain = elgamal_dec(cipher, K, p)
    % toy modular decryption: m = c * K^{-1} mod p
    invK = modInverse(K, p);
    plain = mod(cipher * invK, p);
end

function inv = modInverse(a, m)
    % simple extended Euclidean algorithm
    [g, x, ~] = gcd(a, m);
    if g ~= 1
        error('No modular inverse');
    end
    inv = mod(x, m);
end
