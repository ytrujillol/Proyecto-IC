function [A, B, K] = elgamal_demo()
    % Public values
    p = 23; g = 5;          % small prime and base
    a = 6; b = 15;          % private keys
    A = mod(g^a, p);        % Alice's public key
    B = mod(g^b, p);        % Bob's public key
    Ka = mod(B^a, p);       % Shared key (Alice)
    Kb = mod(A^b, p);       % Shared key (Bob)
    K = Ka;                 % Both are equal
end
