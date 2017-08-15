clear;

N = 500; %tama?o de la red

P = 30; %n?mero de patrones aprendidos

D = 0:0.01:1; %porcentajes de conexiones rotas

iteraciones = 20; %cantidad de iteraciones para obtener promedio de errores

Error = zeros(length(D),iteraciones);
Tabla = zeros(length(D),1);

%% Generacion de p patrones random y matriz W

S = signo(rand(N,P)-0.5); %matriz de patrones a ense?ar

prd = zeros (N,N); %sumador para matriz de pesos

for j = 1:P  %calculo matriz de pesos
    prd = prd + S(:,j)*S(:,j)';
end

W = (1/N)*(prd-P*eye(N));

%% testeo de matriz

for d = 1:length(D)
    
    for i = 1:iteraciones;
        
        R = rand(N,N)>D(d);
        Wtest = W.*R; %se cortan las conexiones elegidas
        
        %se calcula el error por cada iteracion
        Sp = zeros(N,P);
        dist_H = zeros(P,1);
        
        for k = 1:P
            
            Sp(:,k)=signo(Wtest*S(:,k)); %actualizacion sincr?nica
            Delta = S(:,k)-Sp(:,k); %obtengo distancia hamming
            Delta = Delta.^2;
            dist_H (k,1) = sum(Delta)/4;
            
        end
        Error(d,i) = sum(dist_H);
    end
    Tabla (d) = mean(Error(d,:))/(N*P);
end

plot(D*100,Tabla);
title('Errores Vs % de conexiones rotas');
xlabel('% de conexiones rotas');
ylabel('Error medio');