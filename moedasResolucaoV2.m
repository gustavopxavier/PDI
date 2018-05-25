pkg load image

clear all
close all

im = imread('/home/gustavo/Documentos/TADS/PDI/trabalhoMoedas/imagens/11.jpg');
%figure('Name','Imagem original: Moedas')
%imshow(im)

%figure('Name','Histograma Moedas');
%imhist(im)

f = rgb2gray(im);

figure('Name','Imagem Moedas - Escala de cinzas');
imshow(f);

%figure('Name','Histograma Moedas - Escala de Cinzas');
%imhist(f)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%% MOEDAS CINZAS REDUZIDAS %%%%%%%%%%%%%%%%%%%%%

x=1;
for i=1:2:size(f,1)
    y=1;
    for j=1:2:size(f,2)
        fReduzida(x,y) = f(i,j);
        y=y+1;
    end
    x=x+1;
end
figure('Name','Moedas Cinzas Reduzidas');
imshow(fReduzida)

f = fReduzida;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%% MOEDAS CINZAS - LIMIARIZAÇÃO %%%%%%%%%%%%%%%%%%%%

%imFLimiar = zeros(size(f,1), size(f,2));
%imFLimiar(f>65) = 1;

%figure('Name','Moedas Limiarizadas');
%imshow(imFLimiar);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%% MOEDAS - FILTRO PASSA BAIXA %%%%%%%%%%%%%%%%%%%

%preenchimento com zeros
%f2 = zeros(size(f,1)+6,size(f,2)+6);
%f2(4:size(f2,1)-3, 4:size(f2,2)-3) = f(:,:);

%figure('Name','Moedas - Passa Baixa');
%imshow(f2, [min(min(f2)) max(max(f2))]);

%g = zeros(size(f2,1),size(f2,2));

%pesos w
% filtro passa-baixa: máscara 1/25
%w = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1];

%for x=3:size(f2,1)-2
%    for y=3:size(f2,2)-2
%        g(x,y) = (w(1,1)*f2(x-2,y-2) + w(1,2)*f2(x-2,y-1) + w(1,3)*f2(x-2,y) + w(1,4)*f2(x-2,y+1) + w(1,5)*f2(x-2,y+2) + ...
%                w(2,1)*f2(x-1,y-2) + w(2,2)*f2(x-1,y-1) + w(2,3)*f2(x-1,y) + w(2,4)*f2(x-1,y+1) + w(2,5)*f2(x-1,y+2) + ...
%                w(3,1)*f2(x,y-2) + w(3,2)*f2(x,y-1) + w(3,3)*f2(x,y) + w(3,4)*f2(x,y+1) + w(3,5)*f2(x,y+2) + ...
%                w(4,1)*f2(x+1,y-2) + w(4,2)*f2(x+1,y-1) + w(4,3)*f2(x+1,y) + w(4,4)*f2(x+1,y+1) + w(4,5)*f2(x+1,y+2) + ...
%                w(5,1)*f2(x+2,y-2) + w(5,2)*f2(x+2,y-1) + w(5,3)*f2(x+2,y) + w(5,4)*f2(x+2,y+1) + w(5,5)*f2(x+2,y+2))/25;
%    end
%end

%g2(:,:) = g(3:size(g,1)-6, 3:size(g,2)-6);

%figure('Name','Moedas - Filtrada');
%imshow(g, [min(min(g)) max(max(g))])

%figure('Name','Moedas - Filtrada Final ');
%imshow(g2, [min(min(g2)) max(max(g2))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%% MOEDAS - LIMIARIZAÇÃO %%%%%%%%%%%%%%%%%%%%

imLimiar = zeros(size(f,1), size(f,2));
imLimiar(f>65) = 1;

figure('Name','Moedas Limiarizadas');
imshow(imLimiar);

imwrite(imLimiar,'/home/gustavo/projetosGit/PDI/imLimiar.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%% MOEDAS - EROSÃO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
A = imLimiar;

B = [1 1 1; 1 1 1; 1 1 1];
EE = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1];

imMoedasOpen = imopen(A, EE);

imwrite(imMoedasOpen,'/home/gustavo/projetosGit/PDI/imMoedasOpen.jpg');

figure('Name','Imagem Moedas Abertura');
imshow(imMoedasOpen);

C = A;

for i=2:size(A,1)-1
  for j=2:size(A,2)-1
    if(A(i,j)==1) %se o pixel central da vizinhança de A = 1, deve ser analizado
      vizA = [A(i-1,j-1) A(i-1,j) A(i-1,j+1);...
            A(i,j-1) A(i,j) A(i,j+1);...
            A(i+1,j-1) A(i+1,j) A(i+1,j+1)];
      if (sum(sum(vizA==B))!=9) % se todos os pixels são iguais entre a vizinhança de A e B
        C(i,j)=0;
      end    
    end
  end
end

figure('Name','Imagem Moedas Erodida')
imshow(C)

imwrite(C,'/home/gustavo/projetosGit/PDI/imMoedasErodidas.jpg');