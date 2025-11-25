%% Ejemplo: Representación de una imagen en escala de grises con valores 0 a 255

% Definimos la matriz A (valores de intensidad entre 0 y 255)
A = [56 65 21 125 78;
     95 240 9 26 22;
     2 120 9 6 200;
     5 27 97 204 28];

% Mostramos la matriz en la consola
disp('Matriz A:');
disp(A);

% Mostramos la imagen en escala de grises
figure;
imshow(uint8(A));       % Convertimos a uint8 para usar rango [0,255]
colormap gray;          % Aplicamos mapa de color en escala de grises
title('Imagen representada por la matriz A');

% Información adicional
disp('Los valores de A están en el rango [0, 255]');
disp('0 representa el negro (ausencia de luz) y 255 el blanco (máxima intensidad).');