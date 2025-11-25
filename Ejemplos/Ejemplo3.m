I = imread('/home/yessica-trujillo/Documentos/Procesamiento-de-imagenes/Images/Bandera_Seychelles.jpg');

% Extraemos los tres canales de color
R = I(:,:,1);   % Canal rojo
G = I(:,:,2);   % Canal verde
B = I(:,:,3);   % Canal azul

% Mostramos la imagen original y los canales separados
figure;

% Canal rojo
subplot(1,3,1);
imshow(cat(3, R, zeros(size(R)), zeros(size(R))));
title('R');

% Canal verde
subplot(1,3,2);
imshow(cat(3, zeros(size(G)), G, zeros(size(G))));
title('G');

% Canal azul
subplot(1,3,3);
imshow(cat(3, zeros(size(B)), zeros(size(B)), B));
title('B');