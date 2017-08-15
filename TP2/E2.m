
clear;

e = 4; %cantidad de entradas
n = 6; %cantidad de neuronas 1er capa
m = 1; %cantidad de neuronas 2da capa
c = 1; %constante de aprendizaje

beta = 1; %pendiente de la tangente hiperbolica

X = 2^e-1:-1:0;
X = de2bi(X); %matriz de todos los patrones posibles (binario)

Sd = xor(X(:,1),X(:,2)); %defino salida deseada (XOR)

for i = 3:e; %por si e > 2
    
    Sd = xor(Sd,X(:,i));
    
end

Sd = bi2de(Sd); %convierto Sd a decimal

X = cat(2,ones(2^e,1),X); %agrego una entrada constante en 1

w = randn(e+1,n); %matriz de pesos primer capa
W = randn(n+1,m); %matriz de pesos segunda capa

%Aprendizaje

Sr1 = (1+exp(-2*beta*(X*w))).^-1; %calculo salida primera capa
Sr1 = cat(2,ones(2^e,1),Sr1); %agrego entrada constante de 1
Sr2 = (1+exp(-2*beta*(Sr1*W))).^-1; %calculo salida segunda capa

E_1 = 1/2*sum((Sd-Sr2).^2); %calculo error

salida = 0; %escape de while
SALIDA = 10000;
E = zeros(1,SALIDA);

while E_1 > 10^(-2) %itero hasta que E se reduce
    
    I = randperm(2^e); %index aleatorio para las entradas
    
    for i = 1:2^e
        
        %delta ultima capa
        delta_2 = 2*beta*Sr2(I(i))*(1-Sr2(I(i)))*(Sd(I(i))-Sr2(I(i)));
        
        %delta propagado hacia capa intermedia con W
        delta_1 = 2*beta*Sr1(I(i),:).*(1-Sr1(I(i),:))*delta_2.*W';
        
        %modificacion de W en base a delta_2
        W = W' + c * delta_2 * Sr1(I(i),:);
        
        W = W';
        
        %modficacion de w en base a delta_1
        w = w' + c * delta_1(1,2:end)' * X(I(i),:);
          
        w = w';
    
    end
    
    Sr1 = ((1+exp(-2*beta*(X*w))).^-1); %calculo salida primera capa
    Sr1 = cat(2,ones(2^e,1),Sr1); %agrego entrada constante de 1
    Sr2 = ((1+exp(-2*beta*(Sr1*W))).^-1); %calculo salida segunda capa
    
    E_1 = 1/2*sum((Sd-Sr2).^2); %vuelvo a calcular error
    
    E(salida+1) = E_1; %histograma de error
    
    %escape
    if salida>=SALIDA
        break
    else
        salida = salida+1;
    end
end

%plot error
stem(E);
title('Histograma de errores')
