%%Nettoyer l'environnement
clc
clear
close all
%% 1. POUR DEBUTER : LECTURE ET VISIONNAGE DE SEQUENCES DYNAMIQUE

% vidObj = VideoReader('xylophone.mp4');
% vidObj.CurrentTime = 0.5;
% currAxes = axes;
%
% while hasFrame(vidObj)
%     vidFrame = readFrame(vidObj);
%     image(vidFrame, 'Parent', currAxes);
%     currAxes.Visible = 'off';
%     pause(1/vidObj.FrameRate);
% end
%
% for cnt = 1:5:vidObj.NumFrames
%     vidFrame = read(vidObj, cnt);
% end
%

%% 2. FORMAT VIDEO : CREATION DE SEQUENCES D’IMAGES
% Créer une séquence d’images PIETON.avi à partir des images données dans le dossier DATA
writeObj= VideoWriter('PIETON.avi');
writeObj.FrameRate= 1;
open(writeObj);
se1=strel('disk', 10);% créer l'élément strel sur l'image qui épouse la forme de l'image 

for i=1:15
    fic=strcat('PIETON',num2str(i),'.bmp');
    frame=imread(fic);
    writeVideo(writeObj, frame)
end


%% 3) 4) Detection de mouvement, segmentation des objet et tracé de trajectoire

for i=1:15 % boucle pour parcourir tout l'image
    fic=strcat('PIETON',num2str(i),'.bmp');
    frame=imread(fic);% lire l'image
    level=0.4;
    frame_traite=imbinarize(frame,level);% binarisé l'image
    frame_traite=imcomplement(frame_traite);% inversé l'image binarisé
    frame_traite=imerode(frame_traite,se1);% eroder l'image pour diminuer le bruit du fond
    frame_traite=imdilate(frame_traite,se1);%dilaté image irosé
    bw=bwlabel(frame_traite);
    stats=regionprops(bw,'Centroid');% cré un centroid sur l'image
    C = cat(1, stats.Centroid);% concatené le centroid dans un matrice

    figure()
    imshow(frame_traite);
    
    A1=stats(1).Centroid;
    A2=stats(2).Centroid;

    x1= A1(1);
    y1=A1(2);
    x2=A2(1);
    y2=A2(2);
    
    hold on
    %plot(x1, y1)
    plot(C(:,1), C(:,2),'r*' );
    hold off
end













%% 4) Tracé de trajectoire sur l'image originale
figure

%Initialisation des matrice
X1=[];
Y1=[];
X2=[];
Y2=[];

for i = 1:15
    fic=strcat('PIETON',num2str(i),'.bmp');
    im0=imread(fic);
    im=imread(fic);% lire l'image
    im=imbinarize(im,0.4); % convertir image en noir et blanc 
    im=imcomplement(im); % en inverse l'image
    SE=strel('disk',9); % 9 côté
    im=imerode(im, SE); % on nétoie le bruit
    SE2=strel('disk',6);
    frame=imdilate(im,SE2);

    s = regionprops(frame,'centroid'); % on récupère les coordonnées des centroides
    x1=s(1).Centroid(1);%centroide 1 1
    y1=s(1).Centroid(2);%centroide 1 2
    x2=s(2).Centroid(1);%centroide 2 1
    y2=s(2).Centroid(2);%centroide 2 2

  
    

    X1=[X1, x1];
    Y1=[Y1, y1];
    X2=[X2, x2];
    Y2=[Y2, y2];

    imshow(im0)
    hold on % plot sur l'objet
    plot(x1,y1,'m*');
    plot(x2,y2,'m*');
    plot(X1,Y1,'y','LineWidth',2);
    plot(X2,Y2,'y','LineWidth',2);
    hold off
    pause(0.002)
end





