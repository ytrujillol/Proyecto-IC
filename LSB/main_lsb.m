cover_path = '/Users/marcos/Desktop/HelloWorld/U/Proyecto-IC/ImgTest/guiza.png';
%/home/yessica-trujillo/Documentos/Procesamiento-de-imagenes/Images/guiza.png
outdir = fullfile(pwd, 'results_XXX');
if ~exist(outdir, 'dir'), mkdir(outdir); end

cover = imread(cover_path);

%% Mensaje comun para todas las pruebas
MSG = 'LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. EXCEPTEUR SINT OCCAECAT CUPIDATAT NON PROIDENT, SUNT IN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. EXCEPTEUR SINT OCCAECAT CUPIDATAT NON PROIDENT, SUNT IN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. EXCEPTEUR SINT OCCAECAT CUPIDATAT NON PROIDENT, SUNT EN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR INCIDIDUNT UT LABORE ET DOLORE MAGNA ALIQUA. UT ENIM AD MINIM VENIAM, QUIS NOSTRUD EXERCITATION ULLAMCO LABORIS NISI UT ALIQUIP EX EA COMMODO CONSEQUAT. DUIS AUTE IRURE DOLOR IN REPREHENDERIT IN VOLUPTATE VELIT ESSE CILLUM DOLORE EU FUGIAT NULLA PARIATUR. EXCEPTEUR SINT OCCAECAT CUPIDATAT NON PROIDENT, SUNT EN CULPA QUI OFFICIA DESERUNT MOLLIT ANIM ID EST LABORUM. LOREM IPSUM... (etc)';

%% Caso A: LSB sin cifrado
msg_A = MSG;

stego_A = lsb_encode(cover, msg_A);
file_A  = fullfile(outdir, 'stego_lsb_sin_cifrado.png');
imwrite(stego_A, file_A, 'png');

rec_A = lsb_decode(file_A);
fprintf('Recuperado (sin cifrado): %s\n', rec_A);

[E_F_A, E_rel_A] = frobenius_error(cover, stego_A);

%% Caso B: LSB + Cesar
k = 3;                                
msg_B_plain = MSG;                    
msg_B_cif   = cesar_enc(msg_B_plain, k);   

stego_B = lsb_encode(cover, msg_B_cif);    
file_B  = fullfile(outdir, sprintf('stego_lsb_cesar_k%d.png', k));
imwrite(stego_B, file_B, 'png');

rec_B_cif = lsb_decode(file_B);            
rec_B     = cesar_dec(rec_B_cif, k);       
fprintf('Recuperado (Cesar k=%d): %s\n', k, rec_B);

[E_F_B, E_rel_B] = frobenius_error(cover, stego_B);

%% Caso C: LSB + ElGamal (mod 257)
p = 257;                          
K = 123;                          
msg_C_plain = MSG;                

cbytes_C = elgamal_enc(msg_C_plain, K, p);           
stego_C  = lsb_encode(cover, cbytes_C);              
file_C   = fullfile(outdir, sprintf('stego_lsb_elgamal_p%d_K%d.png', p, K));
imwrite(stego_C, file_C, 'png');

rec_C_cif = uint8(lsb_decode(file_C));               
rec_C     = elgamal_dec(rec_C_cif, K, p, true);       
fprintf('Recuperado (ElGamal p=%d, K=%d): %s\n', p, K, rec_C);

[E_F_C, E_rel_C] = frobenius_error(cover, stego_C);  

%% Caso D: LSB + Sustitucion monoalfabetica
msg_D_plain = MSG;                         
msg_D_cif   = sust_enc(msg_D_plain);       

stego_D = lsb_encode(cover, msg_D_cif);    
file_D  = fullfile(outdir, 'stego_lsb_sustitucion.png');
imwrite(stego_D, file_D, 'png');

rec_D_cif = lsb_decode(file_D);            
rec_D     = sust_dec(rec_D_cif);           
fprintf('Recuperado (Sustitucion): %s\n', rec_D);

[E_F_D, E_rel_D] = frobenius_error(cover, stego_D);  

%% Caso E: LSB + Vigenere
keyV = 'CLAVE';                             
msg_E_plain = MSG;                         
msg_E_cif   = vig_enc(msg_E_plain, keyV);  

stego_E = lsb_encode(cover, msg_E_cif);    
file_E  = fullfile(outdir, sprintf('stego_lsb_vigenere_key_%s.png', keyV));
imwrite(stego_E, file_E, 'png');

rec_E_cif = lsb_decode(file_E);            
rec_E     = vig_dec(rec_E_cif, keyV);      
fprintf('Recuperado (Vigenere key=%s): %s\n', keyV, rec_E);

[E_F_E, E_rel_E] = frobenius_error(cover, stego_E);  

%% Caso F: LSB + RSA
e = 17;
d = 2753;
n = 3233;

msg_F_plain = MSG;
msg_F_cif   = RSA_enc(msg_F_plain, e, n);

% Convertir a string para poder insertar en LSB
msg_F_bytes = uint8(msg_F_cif);

stego_F = lsb_encode(cover, msg_F_bytes);
file_F  = fullfile(outdir, 'stego_lsb_rsa.png');
imwrite(stego_F, file_F, 'png');

rec_F_cif = lsb_decode(file_F);
rec_F_int = uint64(rec_F_cif);

rec_F     = RSA_dec(rec_F_int, d, n);
fprintf('Recuperado (RSA): %s\n', rec_F);

[E_F_F, E_rel_F] = frobenius_error(cover, stego_F);

%% Tabla de errores (Frobenius absoluto y relativo)
Metodo = [ ...
    "LSB sin cifrado"; ...
    sprintf("LSB + Cesar (k=%d)", k); ...
    sprintf("LSB + ElGamal (p=%d, K=%d)", p, K); ...
    "LSB + Sustitucion (monoalfabetica)"; ...
    sprintf("LSB + Vigenere (key=%s)", keyV); ...
    "LSB + RSA" ...
];
Error_F   = [E_F_A; E_F_B; E_F_C; E_F_D; E_F_E; E_F_F];
Error_rel = [E_rel_A; E_rel_B; E_rel_C; E_rel_D; E_rel_E; E_rel_F];

T = table(Metodo, Error_F, Error_rel)
