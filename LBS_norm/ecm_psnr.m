function [ECM, PSNR_val] = ecm_psnr(I, R)
%ECM_PSNR Calcula el ECM (MSE) y PSNR entre dos imágenes I y R.
%
%   ECM(I,R)  = (1/N) * sum( (I - R).^2 )
%   PSNR(I,R) = 10 * log10( MAX^2 / ECM ), con MAX = 255
%

    % Convertir a double para operar
    I = double(I);
    R = double(R);

    % Diferencia pixel a pixel
    D = I - R;

    % Número total de elementos (funciona para gris o RGB)
    N = numel(I);

    % ECM según definición
    ECM = sum(D(:).^2) / N;

    % PSNR con MAX = 255 (8 bits)
    MAX = 255;

    if ECM == 0
        PSNR_val = Inf;  % Imágenes idénticas
    else
        PSNR_val = 10 * log10((MAX^2) / ECM);
    end
end