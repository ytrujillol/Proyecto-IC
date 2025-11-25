%% Visualización de los canales RGB por separado

% Canal rojo
Red_color = cat(3, ones(100,100), zeros(100,100), zeros(100,100));

% Canal verde
Green_color = cat(3, zeros(100,100), ones(100,100), zeros(100,100));

% Canal azul
Blue_color = cat(3, zeros(100,100), zeros(100,100), ones(100,100));

% Mostramos los tres canales uno al lado del otro
figure;
imshow([Red_color, Green_color, Blue_color]);
title('Canales Rojo, Verde y Azul respectivamente');