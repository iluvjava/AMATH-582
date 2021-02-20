%% MONO THRESHOLDED

mat = dir('data\*.mat'); 
for q = 1:length(mat) 
    load(strcat(mat(q).folder(), "\", mat(q).name)); 
end


%% 
M = 20; N = 21;
vid = vidFrames1_1;
monoVid = ThresholdMono(vid, 0.95);
monoFrame1 = monoVid(:, :, M);
monoFrame2 = monoVid(:, :, N);

figure(1);
subplot(1, 2, 1);
imshow(monoFrame1);
subplot(1, 2, 2);
imshow(monoFrame2);


PositionX = 270; 
PositionY = 300;
box = [80, 60];

figure(2);
subplot(1, 2, 1);
imshow(monoFrame1(PositionX: PositionX + box(1), PositionY: PositionY + box(2)));
subplot(1, 2, 2);
imshow(monoFrame2(PositionX: PositionX + box(1), PositionY: PositionY + box(2)));

target = monoFrame1(PositionX: PositionX + box(1), PositionY: PositionY + box(2));

% Frame search range
rangeX = 30;
rangeY = 30;
displacement = FrameSearch(monoFrame2, target, PositionX, ...
    PositionY, rangeX, rangeY);

%% TESTING GROUND
close all;
vid = vidFrames3_4;
PositionX = 180;
PositionY = 350;
box = [60, 80];
threshold = 0.0;
searchRange = [30, 30];
searcher = Tracer(vid, box, [PositionX, PositionY], searchRange, threshold); 
searcher.firstFrame();
%%
coords = searcher.traceRoute();
figure; 
subplot(2, 1, 1);
plot(coords(1, :));
subplot(2, 1, 2);
plot(coords(2, :));

%% CASE 1 SVD AND PCA











