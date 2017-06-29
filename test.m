%% test
clear
% assigining the camera a value
camR = webcam(1);
% lowering camera resolution
camR.Resolution = '352x288';
snapshot(camR);

while(true)
    tic
    %taking a snapshot of the camera
    ball = snapshot(camR);
    toc
    % ball = imread('ball.jpeg');
    %seperatings the colors from the original picture
    red = ball(:,:,1); green = ball(:,:,2); blue = ball(:,:,3);
    toc
    %ball2 = impixel(ball); finds rgb values in the balloon
    
    %narrows the picture to that spisific color of red
    %out = red>160 & green>10 & green<70 & blue>15 & blue<90; in control 1 meter away
    out = red>250 & green>90 & green<150 & blue>40 & blue<115; %with interference ~11 meter away
    if all(out == 0)
        continue;
    end
    out
    %out = red>190 & green>25 & green<205 & blue>55 & blue<218; %done with balloon picture
    toc
    %fills in all the holes
    out = imfill(out,'holes');
    toc
    %makes ballon look like a balloon
    out = bwmorph(out,'dilate',2);
    toc
    %fills in all the holes
    out = imfill(out,'holes');
    toc
    %finds the centroid
    center = regionprops(out,'centroid')
    toc
    %solidifies borders of the object
    [B,L] = bwboundaries(out,'noholes');
    
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
    threshold = .75;  %go back to
    
    %loops over the boundaries created
    for k = 1:length(B)
        Boundary = B{k};
        delta_sq = diff(Boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq,2)));
        area = stats(k).Area;
        metric = 4*pi*area/perimeter^2;
        metric_string = sprintf('%2.2f',metric);
        if metric > threshold
            centroid = stats(k).Centroid;
            plot(centroid(1),centroid(2),'ko');
            center = regionprops(out,'centroid');
        end
        
        text(Boundary(1,2)-35,Boundary(1,1)+13,metric_string,'color','r','fontSize',14,'fontWeight','bold');
    end
end
toc