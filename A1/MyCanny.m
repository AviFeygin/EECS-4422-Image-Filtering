function output = MyCanny(image, sigma, tau1, tau2)

%blur the image
blurred_image = imgaussfilt(image,sigma);

%xaxis and y axis filters
%transpose gradient
x_axis = imfilter(double(blurred_image),fspecial('sobel'),'conv');
y_axis =  imfilter(double(blurred_image),transpose(fspecial('sobel')),'conv');

magnitude = sqrt(x_axis.^2 + y_axis.^2);

%direction matrix of the filters
slope = atan(y_axis./x_axis);

% imshow(magnitude,[]);
% pause;

%max suppression
[nrows, ncolumns] = size(image);
suppresion_matrix = zeros(nrows,ncolumns);
directions_degrees = slope * 180 / pi;
directions_degrees(directions_degrees < 0) = directions_degrees(directions_degrees < 0) + 180;

for x = 2:nrows-1
        for y = 2:ncolumns-1  
            previous = 0;
            next = 0;
            angle = directions_degrees(x,y);
            %pi/8
            if (((0 <= angle) && (angle < 180/8))  || (((7/8)*180) <= angle) && (angle <= 180))
                next = magnitude(x+1, y);
                previous = magnitude(x-1, y);
            elseif ((180/8 <= angle) && (angle < 180*(3/8)))
                next = magnitude(x+1, y+1);
                previous = magnitude(x-1, y-1);
            elseif ((180*(3/8) <= angle && angle < 180*(5/8)))
                next = magnitude(x, y + 1);
                previous = magnitude(x, y - 1);
            elseif ((180*(5/8) <= angle && angle < 180*(7/8)))   
                next = magnitude(x-1, y+1);
                previous = magnitude(x+1, y-1);
            end

            if ((magnitude(x,y) >= previous) && (magnitude(x,y) >= next))
               suppresion_matrix(x,y) = magnitude(x,y);
            end
        end
end
%     f2 = figure('Name',"suppresion_matrix");
%     imshow(suppresion_matrix, []);
%     pause;

    %  Double Threshold
    max_value = max(suppresion_matrix,[],'all');
    low_threshold = tau1 * max_value;
    high_threshold = tau2 * max_value;

    post_threshold = ones(size(image));
    strong_matrix = suppresion_matrix >= high_threshold;
    zero_matrix = suppresion_matrix < low_threshold;
    weak = (low_threshold < post_threshold) & (post_threshold < high_threshold);

    strong_value = 255;
    weak_value = 255-230;
    
    post_threshold(strong_matrix) = strong_value;
    post_threshold(weak) = weak_value;
    post_threshold(zero_matrix) = 0;

%     f3 = figure('Name',"post_threshold");
%     imshow(post_threshold,[]);
%     pause;

   %hysterisis
    original = post_threshold;
    final = zeros(size(image));
    [x_size, y_size] = size(image);
    

    for x = 1:x_size
        for y = 1:y_size
            if original(x,y) == strong_value
               hysterysize(x, y, strong_value);
            end
        end
    end

    function hysterysize(x, y, strong_value)
        [maximum_x,maximum_y] = size(original); 
        if ((x < 1) || (x > maximum_x))
             return;
        elseif (y < 1) || (y > maximum_y)
             return;
            elseif (original(x,y) == 0)
                return;
        end
        
        final(x,y) = strong_value;
        original(x,y) = 0;
        for i= 1:-1
            for j=1:-1
                if(~(i==j))
        hysteresis(x + i, y + j, strong_val);

                end
            end
        end
   end

%     f4 = figure('Name',"hysterical");
%     imshow(final)
%     pause;
output = final;
% output = post_threshold;
end