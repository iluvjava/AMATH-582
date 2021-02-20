function searcher = TracerSettings(cam, instance, originalVid)
   % Gave the camera, and the instance of the tesst, and the mono video
   % This functeion will return a tracer Setting

    switch cam
        case 1
            switch instance 
                case 1
                    PositionX = 220;
                    PositionY = 310;
                    box = [80, 60];
                    threshold = 0.0;
                    searchRange = [30, 30];
                case 2
                    PositionX = 300;
                    PositionY = 310;
                    box = [80, 60];
                    threshold = 0.0;
                    searchRange = [30, 30];
                case 3
                    PositionX = 280;
                    PositionY = 310;
                    box = [50, 60];
                    threshold = 0.0;
                    searchRange = [30, 30];
                case 4
                    PositionX = 260;
                    PositionY = 370;
                    box = [60, 50];
                    threshold = 0.0;
            end
        case 2
            switch instance 
                case 1
                    PositionX = 270;
                    PositionY = 260;
                    box = [90, 70];
                    threshold = 0.0;
                    searchRange = [30, 30];
                case 2
                    PositionX = 350;
                    PositionY = 290;
                    box = [50, 70];
                    threshold = 0.0;
                    searchRange = [50, 50];
                case 3
                    PositionX = 290;
                    PositionY = 220;
                    box = [80, 80];
                    threshold = 0.0;
                    searchRange = [50, 50];
                case 4
                    PositionX = 240;
                    PositionY = 220;
                    box = [100, 80];
                    threshold = 0.0;
                    searchRange = [50, 50];
            end
        case 3
            switch instance 
                case 1
                    PositionX = 260;
                    PositionY = 310;
                    box = [60, 70];
                    threshold = 0.0;
                    searchRange = [30, 30];
                case 2
                    PositionX = 240;
                    PositionY = 340;
                    box = [50, 60];
                    threshold = 0.0;
                    searchRange = [30, 30];
                case 3
                    PositionX = 210;
                    PositionY = 340;
                    box = [60, 80];
                    threshold = 0.0;
                case 4
                    PositionX = 180;
                    PositionY = 350;
                    box = [60, 80];
                    threshold = 0.0;
            end
    end
    
    searcher = Tracer(originalVid, box, [PositionX, PositionY], searchRange, threshold);
end

