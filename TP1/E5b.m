clear;
clc;

N = 15; %matriz de N*N

T = 5:-0.001:0; %valores de temperatura decreciendo linealmente

k = 1; %constante de Boltzman

R = 50; %cantidad de actualizaciones antes de un nuevo cambio de energia

%% Bidimensional

S = signo(rand(N,N)-0.5); %patron aleatorio de partida

%fuerzo a cero los extremos de la red
S(1,:) = zeros(1,N);
S(end,:) = zeros(1,N);
S(:,1) = zeros(N,1);
S(:,end) = zeros(N,1);

H1 = (-1/2) * sum (sum (S(2:end-1,2:end-1).*...
    (S(3:end,2:end-1) + S(1:end-2,2:end-1) +...
    S(2:end-1,3:end)' + S(2:end-1,1:end-2)')));

M = zeros(1,length(T));

for i = 1:length(T);
    
    for r = 1 : R;
        
        n = round(rand*N);
        m = round(rand*N);
        
        if (n == 0) 
            n = 1; 
        end
        
        if (m == 0)
            m = 1;
        end
        
        S(n,m) = S(n,m)*(-1);
        
        H2 = (-1/2) * sum (sum (S(2:end-1,2:end-1).*...
                (S(3:end,2:end-1) + S(1:end-2,2:end-1) +...
                S(2:end-1,3:end)' + S(2:end-1,1:end-2)')));
        
        p = exp(-(H2-H1)/(k*T(i)));
        
        if p < rand
            S(n,m) = S(n,m)*(-1);
        else
            H1 = H2;
        end
        
        %imagesc(S(2:end-1,2:end-1));
        %colormap(gray);
        %drawnow;
    end
    M(i) = sum(sum(S));
end

plot(T,M);
title('Magnetizaci?n Vs Temperatura');
xlabel('Temperatura');
ylabel('Magnetizaci?n');
axis([T(end) T(1) -N*N+4*(N-1) N*N-4*(N-1)]);

