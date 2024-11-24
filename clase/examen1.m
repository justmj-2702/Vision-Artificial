close all; 
clear all; 
warning off all; 

numero_clases = 2;
rep = 4;
clases_rep = cell(2,1);
cov_ele = cell(2,1);

% Definir los puntos de cada clase
clases_rep{1} = [0,0,0;
    1,0,0;
    1,1,0;
    1,0,1];

clases_rep{2} = [0,1,0;
    0,0,1;
    0,1,1;
    1,1,1];

prom = zeros(numero_clases,3);

% Solicitar la entrada del usuario
x = input('Ingrese la posición en x (0-1): ');
y = input('Ingrese la posición en y (0-1): ');
z = input('Ingrese la posición en z (0-1): ');

% Validar la entrada de usuario
if x > 1 || x < 0 || y > 1 || y < 0 || z > 1 || z < 0
    disp('Este valor no es valido');
    return; % Salir del programa si los valores no son válidos
end

% Calcular los promedios y las covarianzas
for i = 1:numero_clases
    suma_pos = zeros(1,3);
    class_ = clases_rep{i};
    for j = 1:rep
        suma_pos = suma_pos + class_(j,:);
    end
    prom_vec = suma_pos / rep;
    prom(i,:) = prom_vec;

    % Calcular covarianza
    cov_ele{i} = cov(clases_rep{i});
    fprintf('La covarianza para la clase %d es:\n', i);
    disp(cov_ele{i});
end

% Graficar los puntos y los promedios
figure;
hold on;

% Colores para cada clase
colors = {'y', 'r'};

for i = 1:numero_clases
    class_ = clases_rep{i};
    
    scatter3(class_(:,1), class_(:,2), class_(:,3), 100, colors{i}, 'filled');
    
    scatter3(prom(i,1), prom(i,2), prom(i,3), 200, colors{i}, 'd', 'filled');
end


usuario = [x, y, z]; 
scatter3(usuario(1), usuario(2), usuario(3), 200, 'g', 'o', 'filled'); % Punto del usuario en verde


for i = 1:numero_clases
    mu = prom(i, :); % Media de la clase
    S = cov_ele{i};  % Matriz de covarianza de la clase
    D_M = sqrt((usuario - mu) * inv(S) * (usuario - mu)'); % Distancia de Mahalanobis
    fprintf('La distancia de Mahalanobis desde el punto de usuario a la clase %d es: %.4f\n', i, D_M);
end


view(3); 
axis equal; 
xlabel('Eje X');
ylabel('Eje Y');
zlabel('Eje Z');
title('Gráfico de puntos por clase y sus promedios');
grid on;
hold off;
