clear;
close all;
clc;

q = 1.6022E-19;   
m = 1.6726E-27;
dt = 1e-6;

%начальные значения
X(1)=0;   
Y(1)=0;
Z(1)=0;

Vx(1)=2.5E4;
Vy(1)=1.2E4;
Vz(1)=0.5E4;

fig=figure('color','white');

%Расчет траектории, отображение на графике
for i = 1:1:2500
    Bx(i) = 1E-4;
    By(i) = 0;
    Bz(i) = 0;

%Сила Лоренца
    Fx(i) = q*(Vy(i)*Bz(i)-Vz(i)*By(i));
    Fy(i) = q*(Vz(i)*Bx(i)-Vx(i)*Bz(i));
    Fz(i) = q*(Vx(i)*By(i)-Vy(i)*Bx(i));

%Скорость
    Vx(i+1) = Vx(i)+Fx(i)*dt/m;
    Vy(i+1) = Vy(i)+Fy(i)*dt/m;
    Vz(i+1) = Vz(i)+Fz(i)*dt/m;
%Расчет координат
    X(i+1) = X(i)+(Vx(i+1)+Vx(i))*dt/2;
    Y(i+1) = Y(i)+(Vy(i+1)+Vy(i))*dt/2;
    Z(i+1) = Z(i)+(Vz(i+1)+Vz(i))*dt/2;
%
plot3(X(i),Y(i),Z(i),'.b');
hold on
grid on
axis square
drawnow
end
xlabel('X') 
ylabel('Y')
zlabel('Z')

 
