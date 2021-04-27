clear;
close all;
clc;

size = 250;
eps = 0.001;
counter = 0;
max_iterations = 1E10;
x_in = 75;
y_in = 150;
value = 125;
FI = zeros(size,size);
xx = 1 : size;
yy = 1 : size;
FI(x_in,y_in) = value;

while(counter <= max_iterations)
    counter = counter + 1;
    summa = sum(sum(FI))/(size*size);
    for i=1:size
        for j=1:size
            if ~((i == 1)||(j == 1)||(i == size)||(j == size)) && ~((i == x_in)&&(j == y_in))
                FI(i,j) = (FI(i-1,j)+FI(i+1,j)+FI(i,j-1)+FI(i,j+1))*0.25;
            end
        end
    end
    if abs(sum(sum(FI))/(size*size) - summa) < eps
        break;
    end
end

figure('Color', [1 1 1]);
LevelCon =[10 20 40 60 90 100];
contour(FI,'ShowText','on','LineWidth',2, ...
    'LineStyle',':','LineColor',[1 0 0],'LevelList', ...
    LevelCon);
grid on;
ylabel('\ity','fontsize',14);
xlabel('\itx','fontsize',14);

figure('Color',[1 1 1]);
surf(FI);
colormap(jet);
shading interp;
colorbar;
ylabel('\ity','fontsize',14);
xlabel('\itx','fontsize',14);

figure('Color',[1 1 1]);
[dx,dy] = gradient(-FI);
quiver(xx,yy,dx,dy,5);
ylabel('\ity','fontsize',14);
xlabel('\itx','fontsize',14)