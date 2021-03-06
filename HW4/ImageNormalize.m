function FlattendImagesStd = ImageNormalize(images)
    FlattendImages = ... 
        reshape(images, [size(images, 1)*size(images, 2), size(images, 3)]);
    FlattendImages = double(FlattendImages);
    FlattendImagesStd = FlattendImages - mean(FlattendImages, 1); 
    FlattendImagesStd = FlattendImagesStd./std(FlattendImagesStd, 1);
end

