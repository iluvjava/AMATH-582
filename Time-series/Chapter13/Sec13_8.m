clear all; close all; clc

A=imread('photo.jpeg'); 

Abw2=rgb2gray(A); 
Abw=double(Abw2);
[nx,ny]=size(Abw);
figure(1), subplot(2,2,1), imshow(Abw2)

[C,S]=wavedec2(Abw,2,'db1');

xw=(1:nx*ny)/(nx*ny); 
th=[0 50 100 200];
for j=1:4
  count=0;
  C2=C;
  for jj=1:length(C2); 
      if abs(C2(jj)) < th(j)
        C2(jj)=0;
        count=count+1;
      end
  end
  percent=count/length(C2)*100
  figure(2), subplot(4,1,j),plot(xw,C2,'k',[0 1],[th(j) th(j)],'k:') 
  figure(3), subplot(4,1,j),plot(xw,C2,'k',[0 1],[th(j) th(j)],'k:')
  set(gca,'Xlim',[0.045 0.048])
  Abw2_sparse=waverec2(C2,S,'db1'); 
  Abw2_sparse2=uint8(Abw2_sparse);
  figure(1), subplot(2,2,j), imshow(Abw2_sparse2)
end

        
        
        