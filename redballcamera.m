camR = webcam(1);
camL = webcam(2);

camR.Resolution = '352x288';
camL.Resolution = '352x288';

%defines the image as a ball
Lball = snapshot(camL);
Rball = snapshot(camR);

%seperatings the colors from the original picture
Lred = Lball(:,:,1); Lgreen = Lball(:,:,2); Lblue = Lball(:,:,3); 
Rred = Rball(:,:,1); Rgreen = Rball(:,:,2); Rblue = Rball(:,:,3);


%ball2 = impixel(ball); finds rgb values in the ballon


% narrows the picture to that spisific color of red 
Lout = Lred>250 & Lgreen>90 & Lgreen<150 & Lblue>40 & Lblue<115; 
Rout = Rred>250 & Rgreen>90 & Rgreen<150 & Rblue>40 & Rblue<115;

%fills in all the holes
outL = imfill(outL,'holes'); 
outR = imfill(outR,'holes');

%makes ballon look like a ballon
outL = bwmorph(outL,'dilate',2);
outR = bwmorph(outR,'dilate',2);

%fills in all the holes
outL = imfill(outL,'holes'); 
outR = imfill(outR,'holes');
%%
%finds the centroid
%center = regionprops(out3,'centroid')  

%solidifies borders of the object
[B,L] = bwboundaries(out3,'noholes');

%outlines matrix
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'lineWidth',2)
end

% estimates area and the centriod
stats = regionprops(L,'Area','centroid');

%tests ecentricity 
threshold = .79;  %go back to 

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
    end
    
    text(Boundary(1,2)-35,Boundary(1,1)+13,metric_string,'color','r','fontSize',14,'fontWeight','bold');
end