classdef Tracer < handle
    % This is a class that stores the relavent parameters for a given video
    % It will call other static function to ahieve query about the given
    % video
    
    properties
        OriginalVid;    % The original video
        Threshold;      % The threshold for filtering out the bright spot
        MonoVid;        % The video in mono.  
        Item;           % The item in frame, which contain the object(the moving can) in mono vid.
        InitialPosition % The initial top top left corner of the frame. 
        StartingPosition; 
                        % Staring position, will get refreshed.
        SearchRange;    % The range to search for the next hot spot. 
        Box;
    end
    
    methods
        function this = Tracer(video, box, startingPosi, searchRange, threshold)
            % video: w x d x 3 x f RGB video
            % box: w x d, the box containing the can on the mono vid
            % threshold: What kind of threshold for filtering out the
            % bright spot from the gray scale image. 
            
            this.OriginalVid = video;
            this.MonoVid     = ThresholdMono(video, threshold);
            this.Threshold   = threshold;
            this.Item = this.MonoVid(startingPosi(1): startingPosi(1) + box(1),...
                                     startingPosi(2): startingPosi(2) + box(2), 1);
            this.Box = box;
            this.StartingPosition = startingPosi;
            this.InitialPosition = startingPosi;
            this.SearchRange = searchRange;
        end
        
        function fig = firstFrame(this)
           % Plot the first frame
           FirstFrameColored = this.OriginalVid(:, :, :, 1);
           FirstFrameMono = this.MonoVid(:, :, 1);
           fig = figure;
           x1 = this.InitialPosition(1);
           y1 = this.InitialPosition(2);
           x2 = x1 + this.Box(1) - 1; y2 = y1 + this.Box(2) - 1;
           subplot(2, 2, 1); imshow(FirstFrameColored);
           subplot(2, 2, 2); imshow(FirstFrameMono);
           subplot(2, 2, 3); imshow(FirstFrameColored(x1:x2, y1:y2, :, 1));
           subplot(2, 2, 4); imshow(FirstFrameMono(x1:x2, y1:y2, :, 1));
        end
        
        function coords = traceRoute(this)
            MonoV = this.MonoVid;
            coords = zeros(2, size(MonoV, 3));
            coords(:, 1) = [this.InitialPosition(1); this.InitialPosition(2)];
            for II = 2: size(MonoV, 3)
                Frame = MonoV(:, :, II);
                Displacement = FrameSearch(Frame, ...
                    this.Item, ...
                    this.StartingPosition(1), ...
                    this.StartingPosition(2), ...
                    this.SearchRange(1), ... 
                    this.SearchRange(2)...
                    );
                
                disp(strcat("Frame: ", num2str(II), " Displacement: ", num2str(Displacement)));
                
                coords(:, II) = coords(:, II - 1) + Displacement';
                NewX = coords(1, II); NewY = coords(2, II);
                this.StartingPosition(1) = NewX;
                this.StartingPosition(2) = NewY;
                Height = size(this.Item, 1); Width = size(this.Item, 2);
                this.Item = Frame(NewX: NewX + Height - 1, NewY: NewY + Width - 1);
            end
        end
        
        
    end
end

