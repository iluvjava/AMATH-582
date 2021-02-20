function displacement = FrameSearch(background, searchFrame, positionX, ...
    positionY, rangeX, rangeY)
    %   This is a method that meant to be apply on images filter by the
    % ThresholdMono Function. 
    %
    %   given a background, a searchFrame, a starting position positionX,
    % positionY, a range to search near it, rangeX, rangeY, the method will
    % slide the box around on the background and search for a displacement
    % vector such that the intensity is maximal. 
    %
    % background: 
    %   A matrix. 
    % searchFrame: a vector denoting the width and height of the frame
    %   [width, height]
    % positionX, PositionY:
    %   The topleft corner of the search frame will be placed on this
    %   position.
    
    FrameH = size(searchFrame, 1);
    FrameW = size(searchFrame, 2);
    % Intensity = zeros(rangeX, rangeY);
    MinVal = inf; 

    for II = -rangeX: rangeX - 1 
        for JJ = -rangeY: rangeY - 1
            Xstart = positionX + II;
            Ystart = positionY + JJ;
            Xend = Xstart + FrameH - 1;
            Yend = Ystart + FrameW - 1;
            if Xstart < 1 || Ystart < 1 || Xend > size(background, 1) || Yend > size(background, 2)
                % ItemFrame Outside of the background, go back. 
                continue;
            end
            SliceBackground = background(Xstart: Xend, Ystart: Yend);
            MinValCandidate = sum(abs(SliceBackground - searchFrame), "all");
            
            if MinValCandidate < MinVal
                displacement = [II, JJ];
                MinVal = MinValCandidate;
            end
        end
    end
    
end

