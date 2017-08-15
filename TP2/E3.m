
clear;

e = 3; %cantidad de entradas
n = 20; %cantidad de neuronas 1er capa
m = 1; %cantidad de neuronas 2da capa
c = .5; %constante de aprendizaje

beta = .01; %pendiente de la tangente hiperbolica

X = (0:2*pi/9:2*pi)'; %dominio de X
Y = X; %dominio de Y
Z = (-1:2/9:1)'; %dominio de Z

IN = ones(1000,4); %matriz de todas las combinaciones con entrada constante en 1

IN(:,2) = repmat(X,100,1);
IN(:,3) = reshape(repmat(Y(:)',10,10),[],1);
IN(:,4) = reshape(repmat(Z(:)',100,1),[],1);

scatter3(IN(:,2),IN(:,3),IN(:,4)); %dibujar grilla de puntos

Sd = sin(IN(:,2))+cos(IN(:,3))+IN(:,4); %Salida deseada
Sd = Sd/3; %salida normalizada a +/- 1

w = randn(e+1,n)-0.5; %matriz de pesos primer capa
W = randn(n+1,m)-0.5; %matriz de pesos segunda capa

%Aprendizaje

Sr1 = tanh(beta*IN*w); %calculo salida primera capa
Sr1 = cat(2,ones(1000,1),Sr1); %agrego entrada constante de 1
Sr2 = tanh(beta*Sr1*W); %calculo salida segunda capa

E_1 = 1/2*sum((Sd-Sr2).^2); %error

salida = 0; %contador para escapar del while
SALIDA = 5000;
E = zeros(1,SALIDA); %histograma de errores

h = waitbar(0,'Aprendiendo...');

while E_1 > 2 %itero hasta que E se reduce
    
    I = randperm(1000); %orden aleatorio de aprendizaje
    
    for i = 1:1000
        
        %back propagation
        
        delta_2 = beta*(1-Sr2(I(i)).^2)*(Sd(I(i))-Sr2(I(i))); 
        
        delta_1 = beta*(1-Sr1(I(i),:).^2)*delta_2.*W';
        
        W = W' + c * delta_2 * Sr1(I(i),:);
        
        W = W';
        
        w = w' + c * delta_1(1,2:end)' * IN(I(i),:);
          
        w = w';
    
    end
    
    Sr1 = tanh(beta*IN*w); %calculo salida primera capa
    Sr1 = cat(2,ones(1000,1),Sr1); %agrego entrada constante de 1
    Sr2 = tanh(beta*Sr1*W); %calculo salida segunda capa
    
    E_1 = 1/2*sum((Sd-Sr2).^2);
    
    E(salida+1) = E_1;
    
    E_1
    
    waitbar(salida/SALIDA);
    
    %escape
    if salida>=SALIDA
        break
    else
        salida = salida+1;
    end
end

close(h);

subplot(2,3,1:3)
stem(E(1:salida));

%testeo de red

x = (0:2*pi/99:2*pi)'; %entrada con valores no ense?ados
y = x;
z = (-1:2/99:1)';

%Var?o de una variable por vez y comparo Sd con Sr
IN_test = ones(100,4);
IN_test(:,2) = x;
sdx = sin(IN_test(:,2))+cos(IN_test(:,1))+IN_test(:,1);

Sr1 = tanh(beta*IN_test*w); %calculo salida primera capa
Sr1 = cat(2,ones(100,1),Sr1); %agrego entrada constante de 1
srx = tanh(beta*Sr1*W)*3; %calculo salida segunda capa

IN_test = ones(100,4);
IN_test(:,3) = y;
sdy = sin(IN_test(:,1))+cos(IN_test(:,3))+IN_test(:,1);

Sr1 = tanh(beta*IN_test*w); %calculo salida primera capa
Sr1 = cat(2,ones(100,1),Sr1); %agrego entrada constante de 1
sry = tanh(beta*Sr1*W)*3; %calculo salida segunda capa

IN_test = ones(100,4);
IN_test(:,4) = z;
sdz = sin(IN_test(:,1))+cos(IN_test(:,1))+IN_test(:,4);

Sr1 = tanh(beta*IN_test*w); %calculo salida primera capa
Sr1 = cat(2,ones(100,1),Sr1); %agrego entrada constante de 1
srz = tanh(beta*Sr1*W)*3; %calculo salida segunda capa

subplot(2,3,4)
plot(srx);
hold on
plot(sdx,'r');
hold off

subplot(2,3,5)
plot(sry);
hold on
plot(sdy,'r');
hold off

subplot(2,3,6)
plot(srz);
hold on
plot(sdz,'r');
hold off