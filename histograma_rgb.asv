clc; clear; close all;

ruta = '/home/yessica-trujillo/Documentos/Proyecto_IC/Proyecto-IC---Framework-para-cifrado-y-ocultamiento-en-imagenes/MBS/out/stego_msb_elgamal_p257_K123.png';

img = imread(ruta);

if ndims(img) ~= 3 || size(img, 3) ~= 3
    error('La imagen seleccionada no es a color (RGB).');
end

if ~isa(img, 'uint8')
    img = im2uint8(img);
end

R = img(:,:,1);   % Canal rojo
G = img(:,:,2);   % Canal verde
B = img(:,:,3);   % Canal azul

edges = 0:256;
bins  = 0:255;

hR = histcounts(R(:), edges);
hG = histcounts(G(:), edges);
hB = histcounts(B(:), edges);

figure;
subplot(2,1,1);
imshow(img);
title('Imagen original');

subplot(2,1,2);
hold on; grid on;
plot(bins, hR, 'r', 'LineWidth', 1.2);     % Rojo
plot(bins, hG, 'g', 'LineWidth', 1.2);     % Verde
plot(bins, hB, 'b', 'LineWidth', 1.2);     % Azul
xlim([0 255]);
xlabel('Nivel de intensidad');
ylabel('Frecuencia');
title('Histograma de frecuencias');
legend('R', 'G', 'B', 'Location','northeast');
hold off;