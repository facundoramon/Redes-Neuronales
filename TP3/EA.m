clear; clc;

e = 10000; %cantidad de muestras
n = 100; %cantidad de neuronas
alpha = 2; %probabilidad x^alpha
etha = .1; %constante de aprendizaje

Y = rand(e,1); %vector con entradas en distribucion uniforme
X = Y.^(1/(alpha+1)); %entradas con distribucion p(x) = x^alpha

W = rand(n,1); %matriz de pesos inicial

V = abs(-n+1:n-1); %distancia a neurona ganadora

t = (e:-1:1)*n/e+1;

for i = 1:e;
    
    [~, idx] = min((W-X(i)).^2); %busca neurona ganadora
    ventana = wshift('1d',V,n-idx);
    ventana = ventana(1:n);
    ventana = e.^(-(ventana.^2/(2*t(i)^2)));
    W = W + etha.*(X(i)-W).*ventana';
    
end

beta = 1/(1+alpha*2/3);

Z = (0:1/n:1).^beta;

figure;

plot(W);
hold on;
plot(Z,'r');


