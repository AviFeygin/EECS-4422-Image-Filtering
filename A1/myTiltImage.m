function   tilted_image = myTiltImage(input)
    disp(size(input))
    imshow(input);
    [x,y] = ginput(1);
    disp([y,x]);
    x = round(x);
    y = round(y);
    
    %percent from chosen area to shmear over
    distance_from_center = 40;
    

    % get dimensions
    [nrows, ncolumns]= size(input);
    tilted_image = input;
    blurred_image = zeros(size(input),"uint8");

    %define your field
    field_min = min(y+distance_from_center, nrows) ;
    field_max = max(y-distance_from_center,1) ;
    std_change = .8;

    %add the unblured middle
%     imshow(blurred_image);
%     pause;
    blurred_image = round(blurred_image);
    blurred_image(field_max:field_min,:,:) = input(field_max:field_min,:,:);
%     imshow(input(field_max:field_min,:,:));
%     pause;
%     imshow(blurred_image);
%     pause;

    temp = input;
    %blur the top;
    for i = field_max:-1:1
        temp = imgaussfilt(temp, std_change);
        blurred_image(i,:,:) = temp(i,:,:);
    end
%     imshow(blurred_image);
%     pause;
    temp = input;
    %blur the bottom
    for i = (field_min): nrows
        temp = imgaussfilt(temp, std_change);
        blurred_image(i,:,:) = temp(i,:,:);
    end
   
%    montage({input,blurred_image})
%    title('Original Image (Left), Gaussian Filtered Image(Right)')
%    pause;
   %make toy image, according to online sources the easiest way to do this
   %is via hsv conversion
    saturation_percentage = 2.2;
    hsv_converted_image = rgb2hsv(blurred_image);
    saturation_matrix = hsv_converted_image(:,:,2);
    hsv_converted_image(:,:,2) = saturation_matrix * saturation_percentage;
    tilted_image = hsv2rgb(hsv_converted_image); 
    f2 = figure;
%     montage({input,blurred_image,tilted_image})
%     title('Original Image (Top Left), Gaussian Filtered Image (Top Right), Saturated Image (Bottom Left)')
%     pause;
end