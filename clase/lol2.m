clc
clear all
close all
warning off all

%leyendo una imagen
h = imread('playa.jpg');
[m,n]= size(h);

%pasando al mundo real de coordenadas en el dominio de las imagenes
dato=imref2d(size(h)); %imref2d---> hace el cambio de dominio
figure(2)
imshow(h,dato)

%graficando las clases presentes en la imagen
c1x=randi([330,1600],1,2000);
c1y=randi([1,400],1,2000);

c2x=randi([0,320],1,2000);
c2y=randi([0,600],1,2000);

c3x=randi([0,1600],1,2000);
c3y=randi([650,900],1,2000);

[x, y] = ginput(1);  % El usuario selecciona un punto (x, y)
P = [x; y];  % Coordenadas del punto seleccionado


z1=impixel(h,c1x(1,:),c1y(1,:))
z2=impixel(h,c2x(1,:),c2y(1,:))
z3=impixel(h,c3x(1,:),c3y(1,:))
P1 = impixel(h, P(1), P(2)); 

%ploteando los puntos aleatorios sobre la imagen
grid on
hold on
plot(c1x(1,:),c1y(1,:),'og','MarkerSize',10) 
plot(c2x(1,:),c2y(1,:), 'or', 'MarkerSize',10)
plot(c3x(1,:),c3y(1,:), 'or', 'MarkerSize',10)
plot(P(1),P(2),'oy','MarkerSize',10,'MarkerFaceColor','k')
legend('cielo','roca','arena', 'punto')

%calculando los parámetros
media1=mean(z1,'omitnan')
media2=mean(z2,'omitnan')
media3=mean(z3,'omitnan')


%calculando las distancias de 
dist1=norm(P1-media1)
dist2=norm(P1-media2)
dist3=norm(P1-media3)

% Determinando a qué clase pertenece el punto en función de la distancia mínima
[min_dist, clase] = min([dist1, dist2, dist3]);
% Mostrando la clase a la que pertenece el punto
if clase == 1
    disp('El punto pertenece a la clase "Cielo".');
elseif clase == 2
    disp('El punto pertenece a la clase "Roca".');
elseif clase == 3
    disp('El punto pertenece a la clase "Arena".');
end

disp('fin de proceso..,')