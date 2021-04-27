clear;
close all;
clc;

tint=1;                         %интервал, с
dt=1E-6;                        %шаг
CC=0.01; 
LL=0.01;  
RR=0.05; 
nst=int32(tint/dt)+1; 
UC=zeros(1,nst,'single');       %массив напряжений на с
IL=zeros(1,nst,'single');       %массив токов на l
WRE=zeros(1,nst/2,'single');
WC=zeros(1,nst/2,'single');
WL=zeros(1,nst/2,'single');
%начальные условия
UC(1)=15;
IL(1)=0;
NN=1;
eds=50;

while (NN<nst)
  UC(NN+1)=UC(NN)+IL(NN)*dt/CC;
  IL(NN+1)=IL(NN)-(-eds+UC(NN)+IL(NN)*RR)*dt/LL;
  if mod(NN,2) == 0
      WRE(NN/2+1) = WRE(NN/2) + (RR * IL(NN-1)^2 + 4*(RR* IL(NN)^2) + RR* IL(NN+1)^2) * dt / 3;
   WC(NN/2+1) = WC(NN/2) + dt*(UC(NN-1)*CC^2/2 + 4*UC(NN)*CC^2/2 + UC(NN+1)*CC^2/2)/3;
   WL(NN/2+1) = WL(NN/2) + dt*(IL(NN-1)*LL^2/2 + 4*IL(NN)*LL^2/2 + IL(NN+1)*LL^2/2)/3;
  end
  NN=NN+1;
end

time=0:dt:tint+dt/2;
time2=0:dt:(tint+dt)/2;

figure();
plot(time,UC); grid on; xlabel('t, c'); ylabel('Uc, B');
figure();
plot(time,IL); grid on; xlabel('t, c'); ylabel('IL, A');
figure();
plot(time2,WRE); grid on; xlabel('t, c'); ylabel('Wre, Дж');
figure();
plot(time2,WC); grid on; xlabel('t, c'); ylabel('Wc, Дж');
figure();
plot(time2,WL); grid on; xlabel('t, c'); ylabel('Wl, Дж');

fftuc = fft(UC)/sqrt(tint/dt); figure(); stem(abs(fftuc(1:100)));
grid on; xlabel('freq, Гц'); ylabel('A, B');
Et = norm(UC)^2;
fprintf('Энергия сигнала во временной области: %f \n', Et);
XX = fftn(UC);
Ew = 1/(tint/dt) * norm(XX)^2;
fprintf('Энергия сигнала в частотной области: %f \n', Ew);