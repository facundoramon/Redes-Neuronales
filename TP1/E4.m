
clear;

%% importar imagenes
I1 = imread('im1.tiff');
I2 = imread('im2.tiff');
I3 = imread('im3.tiff');

%descartar tomar s?lo R del RGB
i1 = I1(:,:,1);
i2 = I2(:,:,1);
i3 = I3(:,:,1);

%obtener nro de neuronas
N = prod(size(i1));

%nro de patrones ense?ados
p = 3;

%pasar de matriz a vector columna con 1 para positivos y -1 para negativos
s1 = signo(double(i1(:))-1);
s2 = signo(double(i2(:))-1);
s3 = signo(double(i3(:))-1);
s4 = s1*(-1);
s5 = s2*(-1);
s6 = s3*(-1);
s7 = signo(s1+s2+s3); %000
s8 = signo(s1+s2+s6); %001
s9 = signo(s1+s5+s3); %010
s10 = signo(s1+s5+s6); %011
s11 = signo(s4+s2+s3); %100
s12 = signo(s4+s2+s6); %101
s13 = signo(s4+s5+s3); %110
s14 = signo(s4+s5+s6); %111


%borrar variables que ya no se usan
clear('I1','I2','I3');

%armar matriz de patrones, los 3 primeros son ense?ados
S = [s1 s2 s3... 
    s4 s5 s6...
    s7 s8 s9...
    s10 s11 s12...
    s13 s14];

Si = reshape(S,40,40,14);

%{
for i = 1:14
    
    a = 3;
    b = 5;
    
    subplot(a,b,i), subimage(Si(:,:,i));

end
%}

%% Calculo de matriz de pesos sinapticos
%
prod = zeros (N,N);

for i = 1:p
    prod = prod + S(:,i)*S(:,i)';
end

W = (1/N)*(prod-p*eye(N));

%% testeo de matriz

%numero de patr?n ingresado para testear
%1,2,3 Imagen original

%defino actualizacion sincronica o asincronica
asincronico = 1;

%maximo numero de actualizaciones para el caso asincronico
MAX = N;

%elijo imagen
j = 14;

%actualizacion sincronica
if  ~asincronico
    
    Sp = signo(W*S(:,j));
    
%actualizacion asincronica
else
    
    %fuerzo el estado de la red a la imagen j
    Sp = S(:,j);
    Spi = Sp;
    
    %defino orden de actualizacion
    m = randperm(N);
    
    for n = 1:MAX
        
        k = mod(n,N);
        if k==0
            k=N;
        end
        
        Spi(m(k)) = signo(W(m(k),:)*Sp);
        
        Sp = Spi;
        
    end
end

dH = [sum((S(:,1)-Sp).^2)/4 
    sum((S(:,2)-Sp).^2)/4
    sum((S(:,3)-Sp).^2)/4];

[~ ,i] = min(dH);

subplot(2,2,1), subimage(Si(:,:,j)), title('Patron Ingresado');
subplot(2,2,2), subimage(reshape(Sp,40,40)), title('Patron Resultante');
subplot(2,2,3:4), subimage(Si(:,:,i)), title('Patron Mas Cercano');
%}
