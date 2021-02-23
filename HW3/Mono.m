function Converted = Mono(vid)
    % rgbVid: 
    %   A 4D tensor representing a video, in the shape of w x d 3 x l, 
    %   type: int8
    %   
    % thresshold: 
    %   A scaler in between 0 and 1 that filter out all piexels with an
    %   intensity that is less than it for the whole video
    
    Converted = zeros(size(vid, 1), size(vid, 2), size(vid, 4));
    for II = 1: size(vid, 4)
        Frame = vid(:, :, :, II);
        Frame = double(rgb2gray(Frame))/255; % to gray standardization
        Converted(:, :, II) = Frame;
    end
end

