mat = dir('data\*.mat'); 
for q = 1:length(mat) 
    load(strcat(mat(q).folder(), "\", mat(q).name)); 
end

%%
figure(1);
subplot;
%%
for II = 2: size(vidFrames1_1, 4) - 1
    subplot(2, 2, 1);
    imshow(abs(vidFrames1_1(:, :, :, II) - vidFrames1_1(:, :, :, II - 1)));
    
    subplot(2, 2, 2); 
    imshow(abs(vidFrames2_1(:, :, :, II) - vidFrames2_1(:, :, :, II - 1)));
    
    subplot(2, 2, 3);
    imshow(abs(vidFrames3_1(:, :, :, II) - vidFrames3_1(:, :, :, II - 1)));
    
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

imshow(Vid(:, :, II) - Vid(:, :, II - 2))


function res = BoxBlur(m)
    % Given a matrix, treat it as an image and give it a box blur
    res = convn(m, ones(10, 10)/100);
end

function FFTBlur(m, stepSize)
    
end

%% The frames are out of sync 
%  1. Need to sync them 
%  2. With derivative information to look for the extreme first stationay
%  point and then use that information to sync them
%
