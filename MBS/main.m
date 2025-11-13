% Cargar imagen base
%orig = imread('/home/yessica-trujillo/Documentos/Procesamiento-de-imagenes/Images/Ajedrez.png');
orig1 = imread('/home/yessica-trujillo/Documentos/Procesamiento-de-imagenes/Images/Subexpuesta.jpg');
orig = rgb2gray(orig1);

% Mensaje a ocultar
msg = 'On the other hand, we denounce with righteous indignation and dislike men ... (texto largo)...';

% Métodos a evaluar
methods = { ...
    "cesar/cesar_enc",       "cesar/cesar_dec"; ...
    "vigenere/vig_enc",      "vigenere/vig_dec"; ...
    "sustitucion/sust_enc",  "sustitucion/sust_dec"; ...
    "elgamal/elgamal_enc",   "elgamal/elgamal_dec" ...
};

% Claves simples para las funciones (puedes ajustarlas)
keys = { 3, 'KEY', [], 5 };

fprintf('\n===== PRUEBA DE MSB STEGANOGRAPHY CON 4 MÉTODOS CRIPTO =====\n');

for i = 1:size(methods,1)

    enc_path = methods{i,1};
    dec_path = methods{i,2};
    key = keys{i};

    fprintf('\n--------------------------------------\n');
    fprintf('Método: %s\n', enc_path);
    fprintf('--------------------------------------\n');

    % ---- Cifrado ----
    try
        if isempty(key)
            enc_msg = feval(str2func(enc_path), msg);
        else
            enc_msg = feval(str2func(enc_path), msg, key);
        end
    catch e
        warning(['Error en cifrado: ' e.message]);
        continue;
    end

    % ---- Esteganografía MSB ----
    try
        stego_msb = msb_encode(orig, enc_msg);
        imwrite(stego_msb, ['stego_msb_' num2str(i) '.png']);
    catch e
        warning(['msb_encode error: ' e.message]);
        continue;
    end

    % ---- Decodificación MSB ----
    try
        recuperado = msb_decode(['stego_msb_' num2str(i) '.png']);
    catch e
        warning(['msb_decode error: ' e.message]);
        continue;
    end

    % ---- Descifrado ----
    try
        if isempty(key)
            dec_msg = feval(str2func(dec_path), recuperado);
        else
            dec_msg = feval(str2func(dec_path), recuperado, key);
        end
    catch e
        warning(['Error en descifrado: ' e.message]);
        continue;
    end

    % ---- Evaluación ----
    fprintf('Mensaje recuperado OK: %d\n', strcmp(msg, dec_msg));

    % Error de Frobenius
    try
        [E_F, E_rel] = frobenius_error(orig, stego_msb);
        fprintf('Error Frobenius absoluto = %.4f\n', E_F);
        fprintf('Error relativo = %.6f\n', E_rel);
    catch fe
        warning(['frobenius_error: ' fe.message]);
    end

end

fprintf('\n===== FIN DE PRUEBAS =====\n');
