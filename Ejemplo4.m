I = [50 105 110; 120 125 130; 135 140 145];
R = [52 103 108; 121 126 129; 134 139 250];

figure;
subplot(1,2,1); imagesc(I); axis image off; colormap gray; title('Imagen de prueba I');
subplot(1,2,2); imagesc(R); axis image off; colormap gray; title('Imagen de referencia R');

function ecm = calcular_ecm(I,R)
    I = double(I); R = double(R);
    ecm = mean((I(:) - R(:)).^2);
end

ecm_value = calcular_ecm(I, R)

function psnr_value = calcular_psnr(I, R, MAX)
    ecm = calcular_ecm(I, R);
    psnr_value = 10 * log10((MAX^2) / ecm);
end

psnr_result = calcular_psnr(I, R, 255)

error_relativo = norm(double(I)-double(R),'fro') / ...
                 norm(double(R),'fro') * 100