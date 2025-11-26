function [E_F, E_rel] = frobenius_error(imgA, imgB)
% FROBENIUS_ERROR Calcula ||A-B||_F y el error relativo ||A-B||_F / ||A||_F.
% imgA, imgB: matriz uint8/uint16/single/double, MxN o MxNx3 (mismo tamaño)

    if ~isequal(size(imgA), size(imgB))
        error('Las imágenes deben tener exactamente el mismo tamaño.');
    end

    A = double(imgA);
    B = double(imgB);

    diff = A - B;
    E_F  = norm(diff(:), 'fro');        % norma de Frobenius absoluta
    denom = norm(A(:), 'fro');
    if denom == 0
        E_rel = NaN;                    % indeterminado si A es todo ceros
    else
        E_rel = E_F / denom;            % error relativo (adimensional)
    end
end