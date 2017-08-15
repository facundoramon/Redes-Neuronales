
clear;

N = 100:100:500; %cantidades de neuronas posibles

iteraciones = 10; %cantidad de iteraciones para obtener probabilidad

P_error = [0.001 0.0036 0.01 0.05 0.1]; %errores m?ximos permitidos

P = 10:30:200; %cantidades de patrtones a ense?ar

Error = zeros(length(N),length(P),iteraciones); %almacenamiento de resultados brutos

Tabla = zeros(length(N),length(P)); %porcentaje de error en funcion de P y N

for n = 1:length(N); %vario cantidad de neuronas
    
    for p = 1:length(P) %con N fijo, se prueban distintas cantidades de patrones
        
        for i = 1:iteraciones; %para cada caso se hacen varias iteraciones
            
            S = signo(rand(N(n),P(p))-0.5); %matriz de patrones a ense?ar
            
            prd = zeros (N(n),N(n)); %sumador para matriz de pesos
            
            for j = 1:P(p)  %calculo matriz de pesos
                prd = prd + S(:,j)*S(:,j)';
            end
            
            W = (1/N(n))*(prd-P(p)*eye(N(n)));
            
            % testeo de matriz con actualizacion sincronica
            
            Sp = zeros(N(n),P(p));
            dist_H = zeros(P(p),1);
            
            for k = 1:P(p)
                
                Sp(:,k)=signo(W*S(:,k)); %actualizacion sincr?nica
                Delta = S(:,k)-Sp(:,k); %obtengo distancia hamming
                Delta = Delta.^2;
                dist_H (k,1) = sum(Delta)/4;
                
            end
            Error(n,p,i) = sum(dist_H);
        end
        Tabla (n,p) = mean(Error(n,p,:))/(P(p)*N(n));
    end
end

c = contour(N,P,Tabla',P_error);
xlabel('Cantidad de neuronas')
ylabel('Cantidad de patrones aprendidos')
clabel(c,P_error)

%generar tabla con c

idx1 = 2;
a = c(2,idx1-1);
idx2 = idx1+a;
P_N = zeros(length(P_error),1);

for i = 1:length(P_error);
    
    m = polyfit(c(1,idx1:idx2-1),c(2,idx1:idx2-1),1);
    P_N(i) = m(1);
    
    idx1 = idx2+1;
    if i < 5
        a = c(2,idx2);
    end
    idx2 = idx1+a;

end

T = table(P_error',P_N, 'VariableNames',{'P_error' 'Pmax_N'})