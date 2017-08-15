
clear;

%% importar imagenes
I1 = imread('im1.tiff');
I1m = imread('im1mod.tif');
I1r = imread('im1ruido.tif');
I2 = imread('im2.tiff');
I2m = imread('im2mod.tif');
I2r = imread('im2ruido.tif');
I3 = imread('im3.tiff');
I3m = imread('im3mod.tif');
I3r = imread('im3ruido.tif');

%descartar tomar s?lo R del RGB
i1 = I1(:,:,1);
i2 = I2(:,:,1);
i3 = I3(:,:,1);
i1m = I1m(:,:,1);
i2m = I2m(:,:,1);
i3m = I3m(:,:,1);
i1r = I1r(:,:,1);
i2r = I2r(:,:,1);
i3r = I3r(:,:,1);

%obtener nro de neuronas
N = prod(size(i1));

%nro de patrones ense?ados
p = 3;

%pasar de matriz a vector columna con 1 para positivos y -1 para negativos
s1 = signo(double(i1(:)));
s2 = signo(double(i2(:)));
s3 = signo(double(i3(:)));
s1m = signo(double(i1m(:)));
s2m = signo(double(i2m(:)));
s3m = signo(double(i3m(:)));
s1r = signo(double(i1r(:)));
s2r = signo(double(i2r(:)));
s3r = signo(double(i3r(:)));
s4 = signo(rand(N,1)-0.5);
%s4 = signo(rand(N,1)-0.7);
%s4 = signo(rand(N,1)-0.3);

%borrar variables que ya no se usan
clear('I1','I2','I3',...
    'I1m','I2m','I3m',...
    'I1r','I2r','I3r');

%armar matriz de patrones, los 3 primeros son ense?ados
S = [s1 s2 s3 s1m s2m s3m s1r s2r s3r s4];
Si = reshape(S,40,40,10);

%{
for i = 1:10
    
    a = 4;
    b = 3;
    
    subplot(a,b,i), subimage(Si(:,:,i));

end

%}

%% Calculo de matriz de pesos sinapticos
%
prd = zeros (N,N);

for i = 1:p
    prd = prd + S(:,i)*S(:,i)';
end

W = (1/N)*(prd-p*eye(N));

%% testeo de matriz

%numero de patr?n ingresado para testear
%1,2,3 Imagen original
%4,5,6 Imagen modificada
%7,8,9 Imagen con ruido
%10 Imagen random

%defino actualizacion sincronica o asincronica
asincronico = 0;

%numero de actualizaciones para el caso asincronico
MAX = N;

%elijo imagen
j = 8;

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
        
        %en caso de que MAX sea mayor a N
        k = mod(n,N);
        if k==0
            k=N;
        end
        
        %tomo valor m(k) del vector Spi y lo pondero con la matriz de pesos
        Spi(m(k)) = signo(W(m(k),:)*Sp);
        
        Sp = Spi;
        
    end
end

%calculo distancia de Hamming con los tres patrones aprendidos
dH = [sum((S(:,1)-Sp).^2)/4 
    sum((S(:,2)-Sp).^2)/4
    sum((S(:,3)-Sp).^2)/4];

%obtengo el patron con menor distancia
[~ ,i] = min(dH);

%grafico los resultados
subplot(2,2,1), subimage(Si(:,:,j)), title('Patron Ingresado');
subplot(2,2,2), subimage(reshape(Sp,40,40)), title('Patron Resultante');
subplot(2,2,3:4), subimage(Si(:,:,i)), title('Patron Mas Cercano');
%}
