function   tilted_image = myTiltImage2(input)
    
    [original_y, original_x,~] = size(input)
    f2 = figure("Name","original");
    imshow(input);
    [xmin,y] = ginput(1);
    [x2, y2] = ginput(1);

    xmin = round(xmin);
    y = round(y);
    x2 = round(x2);
    y2 = round(y2);
     a = round(abs(x2-xmin));
     b = round(abs(y-y2));
     c = round(sqrt(a^2+b^2));

     %find the angle direction
     if ((x2<xmin & y2<y)|| (xmin<x2 & y<y2))
        angle_sign = 1;
     else
        angle_sign = -1;
     end

    %angle of rotation calculation
    angle_of_rotation = asind(b/c);

    %percent from chosen area to shmear over
    distance_from_center = 40;
    
    %do some math
    input = imrotate(input,angle_sign*angle_of_rotation);
    input = round(input);
    [nrows, ncolumns]= size(input);
    blurred_image = zeros(size(input),"uint8");
%     montage({input,blurred_image})
%     title('Original Image rotated (Left), blank blurred_image (right)')
%     pause;

    %far field
    field_max = round((nrows/2)-40);
    %near field
    field_min = round((nrows/2)+40);
    std_change = .8;

%     imshow(input(field_max:field_min,:,:));
%     pause;
    input = round(input);
    blurred_image(field_max:field_min,:,:) = round(input(field_max:field_min,:,:));
    blurred_image = round(blurred_image);
    %add the unblured middle
%     fig4 = figure("Name","middle added");
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
   
    %unrotate
   blurred_image = imrotate(blurred_image,angle_of_rotation*-(angle_sign));
   %crop
   [uncroped_y, uncroped_x,~] = size(blurred_image);
   ymin = round((uncroped_y - original_y) /2);
   xmin = round(((uncroped_x - original_x) /2));
   blurred_image = imcrop(blurred_image,[xmin ymin original_x original_y]);
%    imshow(blurred_image);
%    pause;
   
%    montage({input,blurred_image})
%    title('Original Image (Left), Gaussian Filtered Image(Right)')
%    pause;
   %make toy image, according to online sources the easiest way to do this
   %is via hsv conversion
   %change saturation_percentage to make it more vivid
    saturation_percentage = 3.2;
    hsv_converted_image = rgb2hsv(blurred_image);
    saturation_matrix = hsv_converted_image(:,:,2);
    hsv_converted_image(:,:,2) = saturation_matrix * saturation_percentage;
    tilted_image = hsv2rgb(hsv_converted_image); 
%     f2 = figure;
%     montage({input,blurred_image,tilted_image})
%     title('Original Image (Top Left), Gaussian Filtered Image (Top Right), Saturated Image (Bottom Left)')
%     pause;
end