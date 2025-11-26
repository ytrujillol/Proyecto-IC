clc; clear; close all;

% Rutas de las imágenes
ruta_orig  = '/home/yessica-trujillo/Documentos/Proyecto_IC/Proyecto-IC---Framework-para-cifrado-y-ocultamiento-en-imagenes/ImgTest/guiza.png';
ruta_stego = '/home/yessica-trujillo/Documentos/Proyecto_IC/Proyecto-IC---Framework-para-cifrado-y-ocultamiento-en-imagenes/MBS_norm/results_guiza/stego_msb_vigenere_key_CLAVE.png';

% Leer imágenes
img_orig  = imread(ruta_orig);
img_stego = imread(ruta_stego);

% Verificar que sean RGB
if ndims(img_orig) ~= 3 || size(img_orig, 3) ~= 3
    error('La imagen original no es a color (RGB).');
end
if ndims(img_stego) ~= 3 || size(img_stego, 3) ~= 3
    error('La imagen LSB + RSA no es a color (RGB).');
end

% Asegurar tipo uint8
if ~isa(img_orig, 'uint8')
    img_orig = im2uint8(img_orig);
end
if ~isa(img_stego, 'uint8')
    img_stego = im2uint8(img_stego);
end

% Separar canales
R1 = img_orig(:,:,1);   % Original - Rojo
G1 = img_orig(:,:,2);   % Original - Verde
B1 = img_orig(:,:,3);   % Original - Azul

R2 = img_stego(:,:,1);  % Stego - Rojo
G2 = img_stego(:,:,2);  % Stego - Verde
B2 = img_stego(:,:,3);  % Stego - Azul

% Definir bins
edges = 0:256;
bins  = 0:255;

% Histogramas de la imagen original
hR1 = histcounts(R1(:), edges);
hG1 = histcounts(G1(:), edges);
hB1 = histcounts(B1(:), edges);

% Histogramas de la imagen LSB + RSA
hR2 = histcounts(R2(:), edges);
hG2 = histcounts(G2(:), edges);
hB2 = histcounts(B2(:), edges);

% Figura con dos histogramas (sin mostrar imágenes)
figure;

% --- Histograma de la imagen original ---
subplot(2,1,1);
hold on; grid on;
plot(bins, hR1, 'r', 'LineWidth', 1.2);
plot(bins, hG1, 'g', 'LineWidth', 1.2);
plot(bins, hB1, 'b', 'LineWidth', 1.2);
xlim([0 255]);
xlabel('Nivel de intensidad');
ylabel('Frecuencia');
title('Imagen original');
legend('R', 'G', 'B', 'Location','northeast');
hold off;

% --- Histograma de la imagen LSB + RSA ---
subplot(2,1,2);
hold on; grid on;
plot(bins, hR2, 'r', 'LineWidth', 1.2);
plot(bins, hG2, 'g', 'LineWidth', 1.2);
plot(bins, hB2, 'b', 'LineWidth', 1.2);
xlim([0 255]);
xlabel('Nivel de intensidad');
ylabel('Frecuencia');
title('Imagen LSB + RSA');
legend('R', 'G', 'B', 'Location','northeast');
hold off;