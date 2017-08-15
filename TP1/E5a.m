clear;
clc;

N = 50; %matriz N neuronas unidimensional

T = 5:-0.01:0; %valores de temperatura decreciendo linealmente

k = 1; %constante de Boltzman

R = 50; %cantidad de actualizaciones antes de un nuevo cambio de T

%% Unidimensional

S = signo(rand(1,N)-0.5); %patron aleatorio de partida

H1 = (-1/2)*sum(S(2:end-1).*(S(3:end)+S(1:end-2)));

M = zeros(1,length(T));

for i = 1:length(T);
    
    for r = 1 : R;
        
        n = round(rand*N);
        
        if (n == 0) 
            n = 1; 
        end
        
        S(n) = S(n)*(-1);
        
        H2 = (-1/2)*sum(S(2:end-1).*(S(3:end)+S(1:end-2)));
        
        p = exp(-(H2-H1)/(k*T(i)));
        
        if p < rand
            S(n) = S(n)*(-1);
        else
            H1 = H2;
        end
        
    end
    M(i) = sum(S(2:end-1));
end

plot(T,M);
title('Magnetizaci?n Vs Temperatura');
xlabel('Temperatura');
ylabel('Magnetizaci?n');
axis([T(end) T(1) -N+1 N-1]);

