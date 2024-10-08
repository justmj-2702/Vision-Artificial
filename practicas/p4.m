clear;
clc;
close;

dim = 2;
umbral = 100;

flag1 = 1;

while flag1
    nClases = input("Ingresa el numero de clases\n");
    mRepresentantes = input("Ingresa el numero de representantes por clase\n");
    
    centroides = nan(nClases, dim);
    markerShapes = ['d', 'o', 's', '^', 'v'];
    legendLabels = cell(1, nClases);
    c = nan(2, mRepresentantes, nClases);

    figure;
    hold on;
    grid on;

    % Generación de centroides y datos aleatorios para cada clase
    for i = 1:nClases
        x = input("Ingresa el centroide en x de la clase " + i + "\n");
        y = input("Ingresa el centroide en y de la clase " + i + "\n");
        centroides(i, :) = [x y];

        dx = input("Ingresa la dispersion en x de la clase " + i + "\n");
        dy = input("Ingresa la dispersion en y de la clase " + i + "\n");

        currentData = randn(2, mRepresentantes);
        currentData(1, :) = currentData(1, :) * dx + x;
        currentData(2, :) = currentData(2, :) * dy + y;

        c(:, :, i) = currentData(:,:);

        plot(currentData(1, :), currentData(2, :), "LineStyle", "none", "Color", rand(1, 3), ...
            "Marker", markerShapes(mod(i, 5) + 1));
        legendLabels{i} = ["Clase " + i];
    end

    legend(legendLabels);

    flag2 = 1;

    % Clasificación de nuevos vectores
    while flag2
        vx = input("Ingresa la coordenada en x del vector\n");
        vy = input("Ingresa la coordenada en y del vector\n");
        plot(vx, vy, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', rand(1,3));
        v1 = [vx, vy];
        v2 = [vx; vy];

        distancias = nan(1, nClases);
        metodo = input("Elige el método de clasificación: 1 = Euclidiana, 2 = Mahalanobis, 3 = Máxima Probabilidad\n");

        if metodo == 1
            % Clasificación con distancia Euclidiana
            for j = 1:nClases
                distancias(j) = norm(v1 - centroides(j, :));
            end

        elseif metodo == 2
            % Clasificación con distancia de Mahalanobis
            Xmedias = nan(2, mRepresentantes, nClases);
            medias = nan(2, 1, nClases);

            for i = 1:nClases
                medias(:, :, i) = mean(c(:, :, i), 2);
                Xmedias(:, :, i) = c(:, :, i) - medias(:, :, i);
            end

            for i = 1:nClases
                sigma = (Xmedias(:, :, i) * Xmedias(:, :, i)') / mRepresentantes;
                distancias(i) = sqrt((v2 - medias(:, :, i))' * inv(sigma) * (v2 - medias(:, :, i)));
            end

        elseif metodo == 3
            % Clasificación con Máxima Probabilidad
            Xmedias = nan(2, mRepresentantes, nClases);
            medias = nan(2, 1, nClases);
            logLikelihoods = nan(1, nClases);

            for i = 1:nClases
                medias(:, :, i) = mean(c(:, :, i), 2);
                Xmedias(:, :, i) = c(:, :, i) - medias(:, :, i);
                sigma = (Xmedias(:, :, i) * Xmedias(:, :, i)') / mRepresentantes;
                invSigma = inv(sigma);
                diff = v2 - medias(:, :, i);
                logLikelihoods(i) = -0.5 * (diff' * invSigma * diff) - 0.5 * log(det(sigma));
            end

            [maxLikelihood, idx2] = max(logLikelihoods);
            
            if abs(maxLikelihood) < 100000
                fprintf("El vector (" + vx + ", " + vy + ") corresponde a la clase " + idx2 + " \n");
            else
                fprintf("El vector está muy lejos :( \n");
            end
            flag2 = input("Desea probar otro vector? 1 = sí, 0 = no\n");
            continue;  % Saltamos el chequeo del umbral en este método
        end

        % Verificar si la distancia es menor que el umbral
        [minDist, idx] = min(distancias);
        if minDist < umbral
            fprintf("El vector (" + vx + ", " + vy + ") corresponde a la clase " + idx + " \n");
        else
            fprintf("El vector está muy lejos :( \n");
        end

        flag2 = input("Desea probar otro vector? 1 = sí, 0 = no\n");
    end

    hold off;
    flag1 = input("Desea probar otro conjunto de datos? 1 = sí, 0 = no\n");
end
