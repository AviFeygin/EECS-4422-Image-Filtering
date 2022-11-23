% Tilt Photography
f1 = figure('Name', "Toronto Skyline Final");
toronto = myTiltImage(imread('toronto.jpg')); 
imshow(toronto);
pause;

% toy gondor
f2 =figure('Name',"Gondor Final");
gondor = myTiltImage( imread('Gondor.jpg'));
imshow(gondor);
pause;

%toy rotated toronto
f3 = figure('Name', "Toronto Skyline Final");
toronto = myTiltImage2(imread('toronto.jpg')); 
imshow(toronto);
pause;

%mycanny edge detection
delta = 1;
tau1 = .02;
tau2 = .1;
f4 = figure('Name',"bowl of fruit edges mycanny");
image = imread("bowl-of-fruit.jpg");
image = rgb2gray(image);
bowl = MyCanny(image,delta, tau1, tau2);
imshow(bowl,[]);
pause;

% %canny edge detection on fruit bowl
delta = 1;
tau1 = .02;
tau2 = .2;
f5 = figure('Name',"stormtrooper");
image = imread("Anovos_Stormtrooper.png");
image = rgb2gray(image);
bowl = MyCanny(image,delta, tau1, tau2);
imshow(bowl,[]);
pause;

%seam carving couldn't figure this one out.