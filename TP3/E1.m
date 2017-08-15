clear; clc;

% f=50; n=100; alpha=10; etha=0.5; IT=1 FUNCIONA

e = 2; %cantidad de entradas
f = 500; %cantidad de ciudades
n = 1000; %cantidad de neuronas
alpha = 0.1; %constante de ventana
Etha = .8; %constante de aprendizaje

it = 500; %cantidad de veces que se recorren el mapa

Y = rand(f,e)*2-1; %posicion de las ciudades con distribucion uniforme

%{
dist = zeros(1,n); %matriz de distancias entre puntos
dist(1,1) = sqrt((Y(1,1)^2 + Y(2,1)^2));
dist(1,2:end) = sqrt((Y(1,2:end)-Y(1,1:end-1)).^2+(Y(2,2:end)-Y(2,1:end-1)).^2);
Li = sum(dist) %largo de camino inicial con recorrido aleatorio
%}

W = zeros(n,e); %matriz de pesos inicial, neuronas ubicadas en anillo unitario
r = (ones(n,1)-.5)*.1;
W(:,2) = 0:(2*pi)/(n-1):2*pi;
W(:,1) = (.8+r).*sin(W(:,2));
W(:,2) = (.8+r).*cos(W(:,2));


plot(W(:,1),W(:,2),'kx-');
xlim([-1,1]);
ylim([-1,1]);
hold on
plot(Y(:,1),Y(:,2),'ro')
hold off

V = zeros(n,1); %ventana entre neuronas circular
V (1:n/2+1) = 0:n/2; 
V (n/2+2:end) = n/2-1:-1:1;


for I = 1:it;
    
    F = randperm(f);
    etha = Etha+I*(Etha/it);
    t = exp(1).^(0:-alpha/it:-alpha);
    alpha = alpha+0.01;
    
for i = 1:f;
    
    in = [Y(F(i),1),Y(F(i),2)]; %vector entrada para restar a w
    in = repmat(in,n,1);
    
    w = in - W; %diferencia entre in y w
    w_norm = sqrt(w(:,1).^2+w(:,2).^2); %norma de la diferencia
    
    [~,idx] = min(w_norm(:)); %busco neurona ganadora
    
    ventana = wshift('1d',V,-idx+1);
    ventana = e.^(-(ventana.^2/(2*t(I)^2)));
    
    W(:,1) = W(:,1) + etha.*(Y(F(i),1)-W(:,1)).*ventana; %actualizo pesos
    W(:,2) = W(:,2) + etha.*(Y(F(i),2)-W(:,2)).*ventana;
    
end
%{
plot(W(:,1),W(:,2),'kx-');
xlim([-1,1]);
ylim([-1,1]);
hold on
plot(Y(:,1),Y(:,2),'ro');
hold off
drawnow;
%}
end

dist(1,1) = sqrt((W(1,1)^2 + W(2,1)^2));
dist(1,2:end) = sqrt((W(1,2:end)-W(1,1:end-1)).^2+(W(2,2:end)-W(2,1:end-1)).^2);
Lf = sum(dist); %largo de camino inicial;

figure;

plot(W(:,1),W(:,2),'kx-');
xlim([-1,1]);
ylim([-1,1]);
hold on
plot(Y(:,1),Y(:,2),'ro');
hold off