
clear;

e = 2; %cantidad de entradas

c = 1; %constante de aprendizaje

X = 2^e-1:-1:0;
X = de2bi(X); %matriz de todos los patrones posibles (binario)

Sd = and(X(:,1),X(:,2)); %defino salida deseada con funcion AND o OR

for i = 3:e;
    
    Sd = and(Sd,X(:,i)); %defino salida deseada con funcion AND o OR
    
end

Sd = signo(bi2de(Sd)); %convierto ceros en -1
X = signo(X); %convierto ceros en -1

X = cat(2,ones(2^e,1),X); %agrego entrada constante

W = randn(e+1,1); %genero una matriz de pesos inicial random

%Aprendizaje

Sr = signo(X*W); %salida real random

delta = Sd-Sr; %diferencia entre deseada y real

salida = 1; %contador para salir del loop

while any(delta~=0)
    
    for M = 1:2^e;
        
        for N = 1:e+1
            
            W(N) = W(N) + (c * delta(M) * X(M,N));
            
        end
    end
    
    Sr = signo(X*W);
    delta = Sd-Sr;
    
    salida = salida + 1;
    
    if salida>100
        break;
    end
end

if(e==2)
    f = @(x)  -(W(2)*x + W(1))/W(3);
    hold on
    ezplot(f, [-2,2])
    hold on
    plotpv(sign(X(:,2:end))',sign(Sr+1)');
end