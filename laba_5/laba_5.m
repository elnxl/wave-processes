clear;
close all;
clc;

D = 1e-2; % диаметр
Rad = D/2; % радиус
mu_r = 1; % относительная проницаемость
rho = 1.75e-8; % удельное сопротивление
sigma = 1/rho; % удельная проводимость
freq = 1e4; % частота
mu0 = 4*pi*1e-7; % магнитная постоянная
I = 1.2; % текущая сила тока в проводнике
mu = mu0 * mu_r;
counter = length(freq);
size = 300;
Fi = zeros(size,size);
N = 1024;
Larr = zeros(N,N);
cords = zeros(N,2);
coef = zeros(N,N);
N2 = sqrt(N);
step = size/N2;
b = step/100;
Rsp = Fi;
leng = 1; %m
S = b^2;
cnttmp = 1;
L = (leng/pi)*((mu0/2)*(log(2*leng/(0.5902*b))-1)+sqrt(mu0/(2*sigma*2*pi*freq))/b);
depth = sqrt(2/(2*pi*freq*sigma*mu));
R = leng/(sigma*(b*b-pi*(b-2*depth)*(b-2*depth)/4));

for i=1:N2
    for j=1:N2
        cords(cnttmp,1) = step*j/2;
        cords(cnttmp,2) = step*i/2;
        cnttmp = cnttmp + 1;
    end
end

for p = 1:N
    for k = 1:N
        if p ~= k
            h = sqrt((cords(p,1)/100-cords(k,1)/100)^2+(cords(p,2)/100-cords(k,2)/100)^2);
            Larr(p,k) = (mu0*leng/2/pi)*(log(2*leng/h)-1+h/leng - (h^2)/4/leng^2 + (h^4)/32/leng^4);
        else
            Larr(p,k) = L;
        end
    end
end
for p = 2:N
    for k = 1:N
        coef(p-1,k) = Larr(p-1,k) - Larr(p,k);
    end
        coef(p-1,p) = coef(p-1,p) - R;
        coef(p-1,p-1) = coef(p-1,p-1) + R;
end
coef(N,:) = 1;
B = zeros(N);
B(N) = I;

x = coef\B;
res = zeros(N,1);
for cnt = 1:N
    res(cnt) = abs(x(cnt))/S;
end

for i=1:N
    Rsp(cords(i,1)-4:cords(i,1)+5,cords(i,2)-4:cords(i,2)+5) = res(i);
end

figure('Color', [1 1 1]);
surf(Rsp);
colormap(jet);
shading interp;
axis square
view([0 0 90]);
title (['Распределение при N = ', num2str(N), ' подпроводников, f = ', num2str(freq), ' Гц']);
for l = 1:counter
	f = freq(l);
	w = 2*pi*f;
	k = (2/(w*mu*sigma))^0.5;
	K_ = (1+1i)/k;
	dr = min(k, Rad)/100;
	minR = max(0, Rad-10*k);
	r = (Rad-dr/2) : -dr : (minR+dr/2);
	J = (I/(2*pi)) * K_^2 / ( exp(-K_*Rad) + K_*Rad - 1 )* exp(K_*(r-Rad));
	absJ = J;
end
Jdc = I/(pi * Rad^2);
if (f==0)
	absJ = Jdc*(r.^0);
end

figure;
plot(r/Rad,absJ,'r-');
xlim([0.58 1]);
xlabel('Радиус [мм]');
ylabel('J [A/м^2]');
title(['Распределение ', num2str(Rad), ' м, I = ',num2str(I),' A, f = ', num2str(freq), ' Гц' ]);
dr = 500;
[X,Y] = meshgrid(-Rad: Rad/(dr-1) :Rad , -Rad: Rad/(dr-1) :Rad);
r = sqrt(X.^2+Y.^2);

A = sqrt(-1j*2*pi*freq*sigma*mu0*mu_r); 
[J0] = besselj (0, A.* r); 
[J1] = besselj (1, A.*Rad);
Jarr = A.*I.*1./(2.*pi.*Rad).*J0./J1; 
Jarr((X.^2+Y.^2) >= Rad^2) = NaN;
X(isnan(Jarr)) = NaN;
Y(isnan(Jarr)) = NaN;
figure('Color',[1 1 1]);
surf(X,Y,real(Jarr),'LineStyle','none');
colormap(jet);
shading interp;
colorbar;
axis square
view([0 0 90]);
title (['Распределение R = ', num2str(Rad), ' м, I = ',num2str(I),' A, f = ', num2str(freq), ' Гц']);
figure;
plot(Y(X==0), Jarr(X==0));
grid on;
xlabel('Радиус [мм]');
ylabel('J [A/м^2]');
title (['Распределение R = ', num2str(Rad), ' м, I = ',num2str(I),' A, f = ', num2str(freq), ' Гц']);
