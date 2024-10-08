clear;
clc;
close;

dim = 2;
umbral = 100;  % Umbral de distancia

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

            % Verificar si la distancia es menor que el umbral
            [minDist, idx] = min(distancias);
            if minDist < umbral
                fprintf("El vector (" + vx + ", " + vy + ") corresponde a la clase " + idx + " (Euclidiana) \n");
            else
                fprintf("El vector está muy lejos :( (Euclidiana)\n");
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

            % Verificar si la distancia es menor que el umbral
            [minDist, idx] = min(distancias);
            if minDist < umbral
                fprintf("El vector (" + vx + ", " + vy + ") corresponde a la clase " + idx + " (Mahalanobis)\n");
            else
                fprintf("El vector está muy lejos :( (Mahalanobis)\n");
            end

        elseif metodo == 3
            n = nClases;  % Número de clases
            medias = zeros(2, n);  % Media de cada clase
            sigmas = cell(1, n);   % Matriz de covarianza de cada clase
            distanciasM = zeros(n, 1);  % Distancias de Mahalanobis
            probabilidadesM = zeros(n, 1);  % Probabilidades de cada clase

            % Calcular medias y matrices de covarianza
            for i = 1:n
                % Media de la clase i
                medias(:, i) = mean(c(:, :, i), 2); 
        
                % Matriz de covarianza para la clase i
                Xmedias = c(:, :, i) - medias(:, i);  % Centro de los datos
                sigmas{i} = (Xmedias * Xmedias') / mRepresentantes;  % Matriz de covarianza
        
                % Distancia de Mahalanobis para el vector
                diff = v2 - medias(:, i);
                distanciasM(i) = diff' * inv(sigmas{i}) * diff;  % Cálculo de la distancia

                % Probabilidad de la clase i
                probabilidadesM(i) = (1 / (2 * pi * sqrt(det(sigmas{i})))) * exp(-0.5 * distanciasM(i))
            end

            % Clasificación por Máxima Probabilidad
            [maxProbabilidad, idx] = max(probabilidadesM);  % Obtener la clase con mayor probabilidad

            % Comprobamos si la distancia es menor que el umbral
            if min(distanciasM) < umbral
                fprintf("El vector (" + vx + ", " + vy + ") corresponde a la clase " + idx + " con una probabilidad de %.4f (Máxima Probabilidad)\n", maxProbabilidad);
            else
                fprintf("El vector está muy lejos :( (Máxima Probabilidad)\n");
            end
        end

        flag2 = input("Desea probar otro vector? 1 = sí, 0 = no\n");
    end

    hold off;
    flag1 = input("Desea probar otro conjunto de datos? 1 = sí, 0 = no\n");
end
