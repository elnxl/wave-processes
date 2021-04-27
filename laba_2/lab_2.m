clear;
close all;
clc;

tint = 0.2;                     % интервал, c
dt = 1E-6;                      % шаг, с
C0 = 0.025E-6;                  % емкость, Ф
L0 = 1.2E-3;                    % идуктивность, Гн
Z1 = 15;                        % сопративление источника, Ом
Z2 = 75;                        % сопративление нагрузки, Ом
W0 = 5;                         % частота источника
A0 = 1;                         % амплитуда ЭДС
XC = 1/(1j*C0*W0);              % сопротивление конденсатора
XL = 1j*L0*W0;                  % сопротивление катушки
nst = int32(tint/dt)+1;         % число шагов
I11 = zeros (1,nst,'single');   % ток в 1 контуре
I22 = zeros (1,nst,'single');   % ток в 2 контуре
I33 = zeros (1,nst,'single');   % ток в 3 контуре
KI = zeros (1,nst,'single');    % импульсная характеристика
EDS = zeros (1,nst,'single');   % ЭДС
num = 1;


while (num < nst)
    I11(num+1) = I11(num) - (-EDS(num) + I11(num)*Z1)*dt/L0;
    I22(num+1) = I22(num) - (-I22(num)*XL - I11(num + 1)*XL)*dt/L0;
    I33(num+1) = I33(num) - (I33(num)*Z2 - I22(num + 1)*XL)*dt/L0;
    W0 = W0 + 0.00005;
    A0 = A0 + 0.2; 
    EDS(num+1) = A0*cos(W0*2*pi/tint*num*dt);
    KI(num+1) = abs(I33(num+1)/I11(num+1));
    num = num + 1;
end

time = 0:dt:tint+dt/2;

figure();
subplot(2, 1, 1); plot(time, I11); grid on
xlabel('t, мс');
ylabel('I11, A');

subplot(2, 1, 2); plot(time, I33); grid on
xlabel('t, мс');
ylabel('I33, A');

figure();
plot(time, KI); grid on
xlabel('t, мс');
ylabel('KI');