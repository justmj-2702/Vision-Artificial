clc
clear all
close all
warning off all

%leyendo una imagen
h = imread('playa.jpg');
figure(1)
imshow(h)
[m,n, ~]= size(h);

%pasando al mundo real de coordenadas en el dominio de las imagenes
dato=imref2d(size(h)); %imref2d---> hace el cambio de dominio
figure(2)
imshow(h,dato)

%graficando las clases presentes en la imagen
c1x=randi([330,1600],1,100);
c1y=randi([0,400],1,100);
c1=[c1x;c1y]

c2x=randi([100,710],1,1000);
c2y=randi([150,300],1,1000);

c3x=randi([200,750],1,1000);
c3y=randi([300,450],1,1000);

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
plot(c2x(1,:),c2y(1,:),'or','MarkerSize',10)
plot(c3x(1,:),c3y(1,:),'ob','MarkerSize',10)
plot(P(1),P(2),'oy','MarkerSize',10,'MarkerFaceColor','k')
legend('cielo','roca','agua','punto')

%calculando los parámetros
media1=mean(z1,'omitnan')
media2=mean(z2,'omitnan')
media3=mean(z3,'omitnan')

%calculando las distancias de 
dist1=norm(P1-media1)
dist2=norm(P2-media2)
dist3=norm(P3-media3)

disp('fin de proceso..,')
