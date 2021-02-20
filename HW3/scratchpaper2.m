% * Select the object. 
% * Look for the object in the next frame using convolutions. 
mat = dir('data\*.mat'); 
for q = 1:length(mat) 
    load(strcat(mat(q).folder(), "\", mat(q).name)); 
end

%% FREAMES, BOX BLUR DIFF
M = 19; N = 20;
Vid = vidFrames3_1;
FirstFrameGray = rgb2gray(Vid(:, :, :, M));
SecondFrameGray = rgb2gray(Vid(:, :, :, N));
Vid = double(Vid);
Vid = Vid/255;
FirstFrame = Vid(:, :, :, M);
SecondFrame = Vid(:, :, :, N);
figure(1)
imshow(FirstFrame)

figure(2)
imshow(FirstFrame(220:300, 320:380, :))
figure(3)
imshow(SecondFrame(220:300, 320:380, :))
figure(4)
diff = abs(Diffuse(FirstFrame) - Diffuse(SecondFrame))/2;
diff = diff/max(diff, [], "all");
imshow(Diffuse(diff))

figure(5)
diff = abs(Diffuse(FirstFrameGray) - Diffuse(SecondFrameGray))/2;
diff = diff/max(diff, [], "all");
imshow(Diffuse(diff))

figure(6); 
imshow(FirstFrameGray)
%% THRESHOLD
M = 1; N = 2;
Vid = vidFrames3_1;
Frame1 = Vid(:, :, :, M); 
Frame2 = Vid(:, :, :, N);
Frame1Gray = double(rgb2gray(Frame1))/255; 
Frame2Gray = double(rgb2gray(Frame2))/255;

figure(1);
subplot(1, 2, 1);
imshow(Frame1); 
subplot(1, 2, 2);
imshow(Frame2)

figure(2); 
subplot(1, 2, 1);
imshow(Frame1Gray > 0.95);
subplot(1, 2, 2);
imshow(Frame2Gray > 0.95);

%% 
figure(3);
Vid = vidFrames3_3;
Thresholded = zeros(size(Vid, 1), size(Vid, 2), size(Vid, 4));
Threshold = 0.95;
for II = 1: size(Vid, 4)
    Frame = Vid(:, :, :, II);
    Frame = double(rgb2gray(Frame))/255;
    subplot(2, 2, 1);
    imshow(Frame);
    subplot(2, 2, 2);
    Thresholded(:, :, II) = (Frame > Threshold).*Frame;
    imshow(Thresholded(:, :, II));
    drawnow
end
figure(4);
ThresholdedVar = var(Thresholded, 0, [3]);
ThresholdedVar = ThresholdedVar/max(ThresholdedVar, [], "all");
imshow(ThresholdedVar);

%%

function res = Diffuse(m)
    % Given a matrix, treat it as an image and give it a box blur
    P = ones(5, 5);
    P = P/25;
    res = convn(m, P);
end


