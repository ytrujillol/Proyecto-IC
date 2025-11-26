cover_path = '/home/yessica-trujillo/Documentos/Proyecto_IC/Proyecto-IC---Framework-para-cifrado-y-ocultamiento-en-imagenes/ImgTest/chess.png';
outdir = fullfile(pwd, 'results_chess');
if ~exist(outdir, 'dir'), mkdir(outdir); end

cover = imread(cover_path);

%% Mensaje comun para todas las pruebas
MSG = ['LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. ' ...
       'UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. ' ...
       'DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. ' ...
       'EXCEPTEUR SINT OCCAECAT CUPIDAT NON PROIDENT, SUNT IN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. ' ...
       'LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. ' ...
       'UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. ' ...
       'DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. ' ...
       'EXCEPTEUR SINT OCCAECAT CUPIDAT NON PROIDENT, SUNT IN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. ' ...
       'LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. ' ...
       'UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. ' ...
       'DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. ' ...
       'EXCEPTEUR SINT OCCAECAT CUPIDAT NON PROIDENT, SUNT IN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. ' ...
       'LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. ' ...
       'UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. ' ...
       'DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. ' ...
       'EXCEPTEUR SINT OCCAECAT CUPIDAT NON PROIDENT, SUNT IN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. ' ...
       'LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. ' ...
       'UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. ' ...
       'DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA'];

%% Caso A: MSB sin cifrado
msg_A = MSG;

stego_A = msb_encode(cover, msg_A);
file_A  = fullfile(outdir, 'stego_msb_sin_cifrado.png');
imwrite(stego_A, file_A, 'png');

rec_A = msb_decode(file_A);
fprintf('Recuperado (MSB sin cifrado): %s\n', rec_A);

[E_F_A, E_rel_A] = frobenius_error(cover, stego_A);

%% Caso B: MSB + Cesar
k = 3;
msg_B_plain = MSG;
msg_B_cif   = cesar_enc(msg_B_plain, k);

stego_B = msb_encode(cover, msg_B_cif);
file_B  = fullfile(outdir, sprintf('stego_msb_cesar_k%d.png', k));
imwrite(stego_B, file_B, 'png');

rec_B_cif = msb_decode(file_B);
rec_B     = cesar_dec(rec_B_cif, k);
fprintf('Recuperado (MSB + Cesar k=%d): %s\n', k, rec_B);

[E_F_B, E_rel_B] = frobenius_error(cover, stego_B);

%% Caso C: MSB + ElGamal (mod 257)
p = 257;
K = 123;
msg_C_plain = MSG;

cbytes_C = elgamal_enc(msg_C_plain, K, p);
stego_C  = msb_encode(cover, cbytes_C);
file_C   = fullfile(outdir, sprintf('stego_msb_elgamal_p%d_K%d.png', p, K));
imwrite(stego_C, file_C, 'png');

rec_C_cif = uint8(msb_decode(file_C));
rec_C     = elgamal_dec(rec_C_cif, K, p, true);
fprintf('Recuperado (MSB + ElGamal p=%d, K=%d): %s\n', p, K, rec_C);

[E_F_C, E_rel_C] = frobenius_error(cover, stego_C);

%% Caso D: MSB + Sustitucion monoalfabetica
msg_D_plain = MSG;
msg_D_cif   = sust_enc(msg_D_plain);

stego_D = msb_encode(cover, msg_D_cif);
file_D  = fullfile(outdir, 'stego_msb_sustitucion.png');
imwrite(stego_D, file_D, 'png');

rec_D_cif = msb_decode(file_D);
rec_D     = sust_dec(rec_D_cif);
fprintf('Recuperado (MSB + Sustitucion): %s\n', rec_D);

[E_F_D, E_rel_D] = frobenius_error(cover, stego_D);

%% Caso E: MSB + Vigenere
keyV = 'CLAVE';
msg_E_plain = MSG;
msg_E_cif   = vig_enc(msg_E_plain, keyV);

stego_E = msb_encode(cover, msg_E_cif);
file_E  = fullfile(outdir, sprintf('stego_msb_vigenere_key_%s.png', keyV));
imwrite(stego_E, file_E, 'png');

rec_E_cif = msb_decode(file_E);
rec_E     = vig_dec(rec_E_cif, keyV);
fprintf('Recuperado (MSB + Vigenere key=%s): %s\n', keyV, rec_E);

[E_F_E, E_rel_E] = frobenius_error(cover, stego_E);

%% Caso F: MSB + RSA
e = 17;
d = 2753;
n = 3233;

msg_F_plain = MSG;

msg_F_cif   = RSA_enc(msg_F_plain, e, n);

msg_F_bytes = typecast(uint16(msg_F_cif), 'uint8');

stego_F = msb_encode(cover, msg_F_bytes);
file_F  = fullfile(outdir, 'stego_msb_rsa.png');
imwrite(stego_F, file_F, 'png');

rec_F_bytes = msb_decode(file_F);

rec_F_u16 = typecast(uint8(rec_F_bytes), 'uint16');

rec_F_int = uint64(rec_F_u16);

rec_F = RSA_dec(rec_F_int, d, n);

fprintf('Recuperado (MSB + RSA): %s\n', rec_F);

% Error de Frobenius para el caso F
[E_F_F, E_rel_F] = frobenius_error(cover, stego_F);

%% Tabla de errores (Frobenius absoluto y relativo)
Metodo = [ ...
    "MSB sin cifrado"; ...
    "MSB + Cesar (k=" + k + ")"; ...
    "MSB + ElGamal (p=" + p + ", K=" + K + ")"; ...
    "MSB + Sustitucion (monoalfabetica)"; ...
    "MSB + Vigenere (key=" + keyV + ")"; ...
    "MSB + RSA" ...
];

Error_F   = [E_F_A; E_F_B; E_F_C; E_F_D; E_F_E; E_F_F];
Error_rel = [E_rel_A; E_rel_B; E_rel_C; E_rel_D; E_rel_E; E_rel_F];

T = table(Metodo, Error_F, Error_rel);