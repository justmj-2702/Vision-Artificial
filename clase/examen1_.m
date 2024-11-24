clc;
clear;
close all;

% Solicitar los intervalos para números primos y no primos
min_val_primos = input('Dame el valor mínimo del intervalo para los números primos: ');
max_val_primos = input('Dame el valor máximo del intervalo para los números primos: ');

min_val_no_primos = input('Dame el valor mínimo del intervalo para los números no primos: ');
max_val_no_primos = input('Dame el valor máximo del intervalo para los números no primos: ');

% Verificar que los intervalos sean válidos
if min_val_primos >= max_val_primos
    error('El valor mínimo de los primos debe ser menor al valor máximo.');
end
if min_val_no_primos >= max_val_no_primos
    error('El valor mínimo de los no primos debe ser menor al valor máximo.');
end

% Función para verificar si un número es primo
is_prime_num = @(n) all(n > 1 & mod(n, 2:n-1) ~= 0);

% Encontrar los números primos en el intervalo de los primos
primos = [];
for num = min_val_primos:max_val_primos
    if is_prime_num(num)
        primos = [primos, num];
    end
end

% Encontrar los números no primos en el intervalo de los no primos
no_primos = [];
for num = min_val_no_primos:max_val_no_primos
    if ~is_prime_num(num)
        no_primos = [no_primos, num];
    end
end

% Crear coordenadas alrededor del punto (0,0) para los primos
theta_primos = linspace(0, 2*pi, length(primos));
radio_primos = ones(1, length(primos));  % Mantener los puntos a una distancia constante del centro
x_primos = radio_primos .* cos(theta_primos);
y_primos = radio_primos .* sin(theta_primos);
clase1 = [x_primos; y_primos];

% Crear coordenadas alrededor del punto (10,0) para los no primos
theta_no_primos = linspace(0, 2*pi, length(no_primos));
radio_no_primos = ones(1, length(no_primos));  % Mantener los puntos a una distancia constante del centro
x_no_primos = 10 + radio_no_primos .* cos(theta_no_primos);
y_no_primos = radio_no_primos .* sin(theta_no_primos);
clase2 = [x_no_primos; y_no_primos];

% Graficar las clases en 2D
figure;
hold on;

% Graficar la clase 1 (primos) alrededor del punto (0,0)
plot(clase1(1,:), clase1(2,:), 'ro', 'MarkerSize', 8, 'DisplayName', 'Clase 1: Primos');

% Graficar la clase 2 (no primos) alrededor del punto (10,0)
plot(clase2(1,:), clase2(2,:), 'bo', 'MarkerSize', 8, 'DisplayName', 'Clase 2: No Primos');

% Configuración final de la gráfica
legend('show');
grid on;
xlabel('Eje X (Números)');
ylabel('Eje Y');
title('Clasificación de números primos y no primos en 2D');
hold off;

% Bucle para preguntar si se desea clasificar otro número
while true
    % Solicitar un número para clasificar
    num_clasificar = input('Dame un número para clasificar: ');

    % Verificar si el número está en alguno de los intervalos
    if (num_clasificar < min_val_primos || num_clasificar > max_val_primos) && ...
       (num_clasificar < min_val_no_primos || num_clasificar > max_val_no_primos)
        fprintf('El número %d está fuera de los intervalos dados y no pertenece a ninguna clase.\n', num_clasificar);
    else
        % Calcular la media y la matriz de covarianza de cada clase
        media_clase1 = mean(clase1, 2);  % Media de la clase 1
        media_clase2 = mean(clase2, 2);  % Media de la clase 2

        cov_clase1 = cov(clase1');  % Covarianza de la clase 1
        cov_clase2 = cov(clase2');  % Covarianza de la clase 2

        % Evitar problemas con matrices de covarianza singulares
        if det(cov_clase1) == 0
            cov_clase1 = cov_clase1 + eye(size(cov_clase1)) * 1e-5;
        end
        if det(cov_clase2) == 0
            cov_clase2 = cov_clase2 + eye(size(cov_clase2)) * 1e-5;
        end

        % Definir la probabilidad para clase 1 y clase 2
        coord_clasificar = [num_clasificar; 0];  % Vector para el número a clasificar
        prob_clase1 = (1 / sqrt((2*pi)^2 * det(cov_clase1))) * exp(-0.5 * (coord_clasificar - media_clase1)' * inv(cov_clase1) * (coord_clasificar - media_clase1));
        prob_clase2 = (1 / sqrt((2*pi)^2 * det(cov_clase2))) * exp(-0.5 * (coord_clasificar - media_clase2)' * inv(cov_clase2) * (coord_clasificar - media_clase2));

        % Normalizar las probabilidades
        total_prob = prob_clase1 + prob_clase2;
        prob_clase1_normalizada = prob_clase1 / total_prob;
        prob_clase2_normalizada = prob_clase2 / total_prob;

        % Mostrar las probabilidades normalizadas
        fprintf('Probabilidad normalizada para Clase 1 (Primos): %.4f\n', prob_clase1_normalizada);
        fprintf('Probabilidad normalizada para Clase 2 (No Primos): %.4f\n', prob_clase2_normalizada);

        % Determinar la clase a la que pertenece el número y mostrar la probabilidad
        if prob_clase1_normalizada > prob_clase2_normalizada
            fprintf('El número %d pertenece a la Clase 1 (Primos) con una probabilidad normalizada de %.4f\n', num_clasificar, prob_clase1_normalizada);
        else
            fprintf('El número %d pertenece a la Clase 2 (No Primos) con una probabilidad normalizada de %.4f\n', num_clasificar, prob_clase2_normalizada);
        end

        % Graficar el número clasificado
        hold on;
        plot(coord_clasificar(1), coord_clasificar(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Número clasificado');
        hold off;
    end

    % Preguntar si desea probar otro número
    opcion = input('¿Quieres clasificar otro número? (s/n): ', 's');
    if strcmpi(opcion, 'n')
        disp('Fin del programa.');
        break;  % Terminar el bucle
    end
end

