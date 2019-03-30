%%
%Main program for mosaicing two images

clear
close all

f = 'Indoor';                                  %Base file name
ext = 'bmp';                                %Extension of image file

img1 = imread([f '1.' ext]);                %First component image
img2 = imread([f '2.' ext]);                %Second component image

img0 = imMosaic(img2,img1,1);               %The final concatenated/mosaiced image

figure;
imshow(img0);
imwrite(img0,['mosaic_' f '.' ext],ext);    %Saving the final mosaiced image