clear; clc;

e = 2; %cantidad de entradas
f = 50000; %cantidad de muestras por entrada
n = 11; %cantidad de neuronas = n^2
alpha = .5; %constante de ventana
etha = .1; %constante de aprendizaje

Y = rand(f,e); %vector con entradas en distribucion uniforme
Y(:,1) = Y(:,1).^(1/2); %radios con distribucion proporcional al area
Y(:,2) = Y(:,2).*2*pi; %angulos con distribucion uniforme de 0 a 2pi

IN(:,1) = Y(:,1).*cos(Y(:,2)); %transformacion de coordenadas
IN(:,2) = Y(:,1).*sin(Y(:,2)); %transformacion de coordenadas

W = rand(n,n,e)-.5; %matriz de pesos inicial

V = abs(-n:n)+1; %distancia entre neuronas 1D

M=V'*V-1; %distancia entre neuronas 2D

D = zeros(n,n); %matriz ventana

t = exp(1).^(0:-alpha/f:-alpha);

CIRC = ones(200,2);
CIRC(:,2) = 0:2*pi/199:2*pi;
CIR(:,1) = CIRC(:,1).*cos(CIRC(:,2)); %transformacion de coordenadas
CIR(:,2) = CIRC(:,1).*sin(CIRC(:,2)); %transformacion de coordenadas


for i = 1:f;
    
    w = reshape(W,n^2,2); %reordeno pesos en matriz de 2xN
    
    in = [IN(i,1),IN(i,2)]; %vector entrada para restar a w
    in = repmat(in,n*n,1);
    
    w = in - w; %diferencia entre in y w
    w_norm = sqrt(w(:,1).^2+w(:,2).^2); %norma de la diferencia
    
    [~,idx] = min(w_norm(:)); %busco neurona ganadora
    
    C = ceil(idx/n);  %calculo posicion de neurona ganadora
    F = (idx-(C-1)*n);
    
    D = M(n+2-F:2*n+1-F,n+2-C:2*n+1-C); %muevo ventana a neurona ganadora
    D = e.^(-(D.^2/(2*t(i)^2))); %calculo ventana con t(i)
    
    W(:,:,1) = W(:,:,1) + etha.*(IN(i,1)-W(:,:,1)).*D; %actualizo pesos
    W(:,:,2) = W(:,:,2) + etha.*(IN(i,2)-W(:,:,2)).*D;
    %{
    plot(W(:,:,1),W(:,:,2),'bo');
    hold on
    plot(W(:,:,1),W(:,:,2));
    plot(W(:,:,1)',W(:,:,2)');
    plot(CIR(:,1),CIR(:,2),'k');
    hold off
    drawnow;
    %}
    
end

figure;

plot(W(:,:,1),W(:,:,2),'bo');
hold on
plot(W(:,:,1),W(:,:,2));
plot(W(:,:,1)',W(:,:,2)');
plot(CIR(:,1),CIR(:,2),'k');
hold off
drawnow;


