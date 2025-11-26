function out = rsa_dec(cipher, d, n)
    cipher = uint64(cipher(:));
    m      = zeros(size(cipher), 'uint64');

    % Para cada bloque: m = c^d mod n
    for i = 1:numel(cipher)
        c = cipher(i);
        m(i) = powermod(c, d, n);
    end

    out = char(m.');
end

% Exponenciación rápida
function r = powermod(a, b, n)
    r = uint64(1);
    a = uint64(mod(a, n));
    b = uint64(b);

    while b > 0
        if bitand(b, 1)
            r = mod(r * a, n);
        end
        a = mod(a * a, n);
        b = bitshift(b, -1);
    end
end
