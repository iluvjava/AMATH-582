mat = dir('data\*.mat'); 
for q = 1:length(mat) 
    load(strcat(mat(q).folder(), "\", mat(q).name)); 
end

%%
figure(1);
subplot;
%%
figure;
Vid = vidFrames3_4; 
for II = 1: size(Vid, 4)
   imshow(Vid(:, :, :, II));
   drawnow
end

%%
figure(2)
subplot(1, 2, 1); 
imshow(vidFrames1_1(:, :, :, 1))
subplot(1, 2, 2);
imshow(vidFrames1_1(:, :, :, 10))


%% HOW THE FUCK WE GET THE MOVING OBJECTS??!!
Vid = vidFrames1_2;
Vid = mean(Vid, [3]);
size(Vid)

Vid = reshape(Vid, [size(Vid, 1), size(Vid, 2), size(Vid, 4)]);
Vid = Vid/255;

figure(2); 
for II = 2: 10
    imshow(Vid(:, :, II) - Vid(:, :, II - 1))
    drawnow
end

%% The frames are out of sync 
%  1. Need to sync them 
%  2. With derivative information to look for the extreme first stationay
%  point and then use that information to sync them
%
