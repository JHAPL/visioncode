%% test
clear
clc
%%
% assigining the camera a value
camR = webcam(2);
% lowering camera resolution
camR.Resolution = '352x288';


%%

xPoints = zeros(1);
yPoints = zeros(1);
i = 1;
h = figure;
ax = gca;
hold(ax, 'on');

while(true)
    %taking a snapshot of the camera
    ball = snapshot(camR); %outside
    % ball = imread('ball.jpeg');
    %seperatings the colors from the original pictur
    red = double(ball(:,:,1)); green = double(ball(:,:,2)); blue = double(ball(:,:,3));
    %ball2 = impixel(ball); finds rgb values in the balloon
    
    %narrows the picture to that spesific color of red
    out = red./(green)>2.7 & red./(blue)>2.7 & red>20;
    %fills in all the holes
    out = imfill(out,'holes');
    %makes ballon look like a balloon
    out = bwmorph(out,'dilate',3);
    %fills in all the holes
    out = imfill(out,'holes');
    %finds the centroid
    
    
    %solidifies borders of the object
    [B,L] = bwboundaries(out,'noholes');
    cla
    %outlines matrix
    imshow(label2rgb(L, @jet, [.5 .5 .5]))
    
    hold on
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'w', 'lineWidth',2)
    end
    
    % estimates area and the centroid
    stats = regionprops(L,'Area','centroid');
    
    %tests ecentricity
    threshold = .5;  %go back to
    
    foundOne = false;
    largestArea = 0;
    center = zeros(2);
    %loops over the boundaries created
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
                plot(centroid(1),centroid(2),'ko', 'MarkerSize', 10);
                largestArea = area;
                center = centroid + mapcenter;
                center(2) = -1 * center(2);
            end            
        end
        
        %text(Boundary(1,2)-35,Boundary(1,1)+13,metric_string,'color','r','fontSize',14,'fontWeight','bold');
    end
    %foundOne
     if(foundOne)
        center
        xPoints(i) = center(1);
        yPoints(i) = center(2);
        i = i + 1;
    end
    hold on
    scatter(center(1),center(2),10,'r');
    %plot(xPoints, yPoints, 'lineWidth', 4);

        
    
    
    %disp(bip)
    %     toc
  
end
