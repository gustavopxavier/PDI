pkg load image

clear all
close all

im = imread('/home/gustavo/Documentos/TADS/PDI/trabalhoMoedas/imagens/11.jpg');
%figure('Name','Imagem original: Moedas')
%imshow(im)

%figure('Name','Histograma Moedas');
%imhist(im)

r(:,:) = im(:,:,1);
g(:,:) = im(:,:,2);
b(:,:) = im(:,:,3);

moedas = uint8(zeros(size(im,1), size(im,2), size(im,3)));
moedasBW = uint8(zeros(size(im,1), size(im,2), size(im,3)));
moedasPratas = uint8(zeros(size(im,1), size(im,2), size(im,3)));

for i=1:size(im,1)
  for j=1:size(im,2)
    if((r(i,j)>45)&&(g(i,j)>45)&&(b(i,j)>45))
      moedas(i,j,:) = im(i,j,:);
      %moedasBW(i,j,:) = 1;
    else
      moedas(i,j,:) = 255;
      %moedasBW(i,j,:) = 255;
    end
  end
end

%figure('Name','Moedas');
%imshow(moedas);

imMoedasGray = rgb2gray(moedas);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%% MOEDAS - IMAGEM BINARIZADA %%%%%%%%%%%%%%%%%%%

for i=1:size(im,1)
  for j=1:size(im,2)
    if (imMoedasGray(i,j)<250)
      imMoedasBW(i,j) = 1;
    else
      imMoedasBW(i,j) = 0;
    end
  end
end

figure('Name','Moedas binarizada');
imshow(imMoedasBW, [0 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%% MOEDAS - REDUÇÃO DA IMAGEM BINARIZADA %%%%%%%%%%%%%%%%

x=1;
for i=1:2:size(imMoedasBW,1)
    y=1;
    for j=1:2:size(imMoedasBW,2)
        imBW(x,y) = imMoedasBW(i,j);
        y=y+1;
    end
    x=x+1;
end
figure('Name','Moedas binarizada pequena');
imshow(imBW)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%% MOEDAS - EROSÃO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
A = imBW;

B = [1 1 1; 1 1 1; 1 1 1];

%imMoedasOpen = imopen(imBW, B);

%figure('Name','Imagem Moedas Abertura');
%imshow(imMoedasOpen);

C = A;

cont = 0;
while (cont < 3)
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
  cont = cont + 1;
end
figure('Name','Imagem Moedas Erodida')
imshow(C)



imBW = C;

%matriz = [1,1,1,1,1; 1,1,1,1,1; 1,1,1,1,1; 1,1,1,1,1; 1,1,1,1,1];
%matriz = [1,1,1; 1,1,1; 1,1,1];

%for i = 1:i<6
%  imBW = imopen(imBW, matriz);
  %imMoedasErode = imerode(imMoedasBW, matriz);
  %debug = i
%end

%figure('Name','Abertura');
%imshow(imBW);

%imMoedasErode = imerode(imMoedasBW, matriz);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%% MOEDAS - ROTULANDO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

rotulo = 2;
rotulosIguais(1,1) = 0;
%rotulosIguais(2,1) = 0;
r = 1; %indice do vetor rotulos Iguais
imRotulo = imBW; %imagem cópia para armazenar os rotulos
for(i=2:size(imBW,1))
  for(j=2:size(imBW,2))
    if(imBW(i,j)==1)
      if((imBW(i-1,j)==0)&&(imBW(i,j-1)==0))
        rotulo+=20; % novo rotulo (soma de 10 em 10)
        imRotulo(i,j)=rotulo;
      else
        if((imBW(i-1,j)==1)&&(imBW(i,j-1)==0))
          imRotulo(i,j)=imRotulo(i-1,j);
        else
          if((imBW(i-1,j)==0)&&(imBW(i,j-1)==1))
            imRotulo(i,j)=imRotulo(i,j-1);
          else
            if(((imBW(i-1,j)==1)&&(imBW(i,j-1)==1))&&(imRotulo(i-1,j)==imRotulo(i,j-1)))
              imRotulo(i,j)=imRotulo(i-1,j);
            else
              if(((imBW(i-1,j)==1)&&(imBW(i,j-1)==1))&&(imRotulo(i-1,j)!=imRotulo(i,j-1)))
                %os vizinhos são rotulados e os rotulos são diferentes...
                imRotulo(i,j)=imRotulo(i-1,j); %insere o rotulo de um dos vizinhos
                eq1 = imRotulo(i-1,j); 
                eq2 = imRotulo(i,j-1);
                % guardar rotulos equivalentes - erro
                ultimaLinha = size(rotulosIguais,1);
                ultimaColuna = size(rotulosIguais,2);
                [l1,c1]=find(rotulosIguais==eq1); %busca o 1o elemento
                [l2,c2]=find(rotulosIguais==eq2); %busca o 2o elemento
                if ((isempty(l1))&&(isempty(l2))) %não achou nenhum dos elementos
                  rotulosIguais(ultimaLinha+1,1) = eq1;
                  rotulosIguais(ultimaLinha+1,2) = eq2;
                else
                  if ((!isempty(l1))&&(isempty(l2))) %não achou o 1o elemento
                    rotulosIguais(l1,ultimaColuna+1) = eq2;
                  else
                    if ((isempty(l1))&&(!isempty(l2))) %não achou o 2o elemento
                      rotulosIguais(l2,ultimaColuna+1) = eq1;
                    end
                  end
                end
              end  
            end
          end
        end
      end
    end
  end
end

figure('Name','Imagem Rotulada com erros')
imshow(uint8(imRotulo), [min(min(imRotulo)), max(max(imRotulo))])

%retirar erros de equivalências de rótulos
for(i=2:size(imRotulo,1))
  for(j=2:size(imRotulo,2))
    if(imRotulo(i,j)!=0)
      [l,c]=find(rotulosIguais==imRotulo(i,j)); %procura o elemento nos erros
      if(!isempty(l))
        imRotulo(i,j) = rotulosIguais(l,1);
      end
    end
  end
end

qtdRegioes =  size(unique(imRotulo),1)-1; %-1 para desconsiderar o fundo
imRotulo = uint8(imRotulo);
figure('Name','Imagem Rotulada 2')
imshow(imRotulo, [min(min(imRotulo)) max(max(imRotulo))])
title(strcat('Quantidade de Moedas: ',int2str(qtdRegioes)))