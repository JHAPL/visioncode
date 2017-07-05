%% test
clear
clc
%%
% assigining the camera a value
camR = webcam(1);
% lowering camera resolution
camR.Resolution = '352x288';
snapshot(camR);

%%
while(true)
    
    %taking a snapshot of the camera
    ball = snapshot(camR);
    % ball = imread('ball.jpeg');
    %seperatings the colors from the original picture
    red = ball(:,:,1); green = ball(:,:,2); blue = ball(:,:,3);
    %ball2 = impixel(ball); finds rgb values in the balloon
    
    %narrows the picture to that spisific color of red
    out = red>110 & green>8 & green<45 & blue>14 & blue<86; %in control 1 meter away
    %out = red>250 & green>90 & green<150 & blue>40 & blue<115; %with interference ~11 meter away
    %out = red>190 & green>25 & green<205 & blue>55 & blue<218; %done with balloon picture
    %fills in all the holes
    out = imfill(out,'holes');
    %makes ballon look like a balloon
    out = bwmorph(out,'dilate',3);
    %fills in all the holes
    out = imfill(out,'holes');
    %finds the centroid
    center = regionprops(out,'centroid');
    
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
    threshold = .65;  %go back to
    
    bip = 0;
    
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
          center = regionprops(out,'centroid')
          mapcenter = [176,144];
          %final = center.Centroid - mapcenter
          bip = 1;
          
          break 
        end
        
        %text(Boundary(1,2)-35,Boundary(1,1)+13,metric_string,'color','r','fontSize',14,'fontWeight','bold');
    end
    if bip == 0
      
    end
    
     %disp(bip)
%     toc
    
end
%dont klnow why it is outputing centroid with not value 
%getting error when centering 