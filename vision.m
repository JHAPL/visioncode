%% test
clear
clc
%%
% assigining the camera a value
camR = webcam(1);
camL = webcam(2);
% lowering camera resolution
camR.Resolution = '352x288';
camL.Resolution = '352x288';

q = 0;
while(true)
    picR = snapshot(camR);
    picL = snapshot(camL);
    r = calc(picR)  
    l = calc(picL)
    q = q + 1;
    if r(1) == 1 & l(1) == 1
       girlz(r(2), r(3), l(2), l(3));
    end
end
%%
function centerPoint = calc(ball)
    red = ball(:,:,1); green = ball(:,:,2); blue = ball(:,:,3);
    out = red./(green)>1.9 & red./(blue)>1.9; 
    out = imfill(out,'holes');
    out = bwmorph(out,'dilate',3);
    out = imfill(out,'holes');
    [B,L] = bwboundaries(out,'noholes');
    
    stats = regionprops(L,'Area','centroid');
    threshold = .65;  %go back to
    foundOne = false;
    largestArea = 0;
    center = zeros(2);
    for k = 1:length(B)
        Boundary = B{k};
        delta_sq = diff(Boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq,2)));
        area = stats(k).Area;
        metric = 4*pi*area/perimeter^2;
        metric_string = sprintf('%2.2f',metric);
        if metric > threshold
            foundOne = true;
            centroid = stats(k).Centroid;
            mapcenter = [-176,-144];
            if(area > largestArea)
                largestArea = area;
                center = centroid + mapcenter;
                center(2) = -1 * center(2);
            end            
        end
    end
     centerPoint = [foundOne, center(1), center(2)];
end
%%