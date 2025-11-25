function cipher = rsa_enc(plain, e, n)
    plain = uint64(plain(:));   
    
    cipher = zeros(size(plain), 'uint64');

    % Para cada carácter: c = m^e mod n
    for i = 1:numel(plain)
        m = plain(i);
        cipher(i) = powermod(m, e, n);
    end
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
