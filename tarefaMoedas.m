pkg load image

clear all
close all

im = imread('/home/gustavo/Documentos/TADS/PDI/trabalhoMoedas/1.jpg');
%figure('Name','Imagem original: Grãos')
%imshow(im)

%figure('Name','Histograma Grãos');
%imhist(im)

r(:,:) = im(:,:,1);
g(:,:) = im(:,:,2);
b(:,:) = im(:,:,3);

macarrao = uint8(zeros(size(im,1), size(im,2), size(im,3)));
feijao = uint8(zeros(size(im,1), size(im,2), size(im,3)));
verd = uint8(zeros(size(im,1), size(im,2), size(im,3)));

for i=1:size(im,1)
  for j=1:size(im,2)
    if((r(i,j)>100)&&(g(i,j)>100)&&(b(i,j)<60))
      macarrao(i,j,:) = im(i,j,:);
    else
      macarrao(i,j,:) = 255;
    end
  end
end

%figure('Name','Macarrão');
%imshow(macarrao)

%figure('Name','Histograma - Macarrão');
%imhist(macarrao)
imMacarraoGray = rgb2gray(macarrao);

%figure('Name','Macarrao - Escala de Cinzas')
%imshow(imMacarraoGray)

%figure('Name','Histograma Macarrão em Escala de Cinzas');
%imhist(imMacarraoGray);

%-----------------------------Binarização macarrão
macarraoCont = 0;
for i=1:size(im,1)
  for j=1:size(im,2)
    if ((imMacarraoGray(i,j)<135) || (imMacarraoGray(i,j)>240))
      imMacarraoBW(i,j) = 1;
      macarraoCont = macarraoCont + 1;
    else
      imMacarraoBW(i,j)=0;
    end
  end
end

areaTotal = (size(im,1)*size(im,2))
percMacarrao = (macarraoCont * 100) / areaTotal

figure('Name','Macarrão')
imshow(imMacarraoBW)
title(strcat('Macarrão - Porcentagem: ',mat2str(percMacarrao), '%'))

%-----------------------------FEIJÃO-----------------------------
imFeijaoGray = rgb2gray(im);

%figure('Name','Imagem Feijão Gray')
%imshow(imFeijaoGray)

%figure('Name','Imagem Gray')
%imhist(imFeijaoGray)
feijaoCont = 0;

for i=1:size(imFeijaoGray,1)
  for j=1:size(imFeijaoGray,2)
    if(imFeijaoGray(i,j)<96)
      feijaoBW(i,j) = 0;
      feijaoCont = feijaoCont + 1;
    else
      feijaoBW(i,j) = 1;
    end
  end
end

percFeijao= (feijaoCont * 100) / areaTotal;

figure('Name','Feijão');
imshow(feijaoBW)

title(strcat('Feijão - Porcentagem: ',mat2str(percFeijao), '%'));

%-----------------------------ARROZ-----------------------------
arrozCont = 0;
imArrozGray = rgb2gray(im);

areaTotalArroz = (size(imArrozGray,1)*size(imArrozGray,2));

for i=1:size(imArrozGray,1)
  for j=1:size(imArrozGray,2)
    if((imArrozGray(i,j)>185) && (imArrozGray(i,j)<220))
      arrozBW(i,j) = 0;
      arrozCont = arrozCont + 1;
    else
      arrozBW(i,j) = 1;
    end
  end
end

percArroz = (arrozCont * 100) / areaTotalArroz;

figure('Name','Arroz');
imshow(arrozBW)
%title(strcat('Arroz - Quantidade de pixels: ',int2str(arrozCont)))
title(strcat('Arroz - Porcentagem: ',mat2str(percArroz), '%'))