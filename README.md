# Image-registration-and-stitching

This repository contains my codes for the term project on Image Registration and Stitching

Steps to run the files present in the project:-

1. The main running script is mosaicTest.m. The images to be stitched together must have a common base name with some of the ending characters different. The base name must be stored in the variable f. The image extension must be specified in the variable ext. Also, the different ending characters to be updated during the 'imread' call.


2. After running the above script, the code will generate the number of keypoints found in both the images, the number of matched keypoints, the Homography matrix and finally the set of transfomed images, the appended image showing the matched Keypoints and the final image which is obtained by stitching both the images together. The final image is stored in the same folder as the input images with the mosaic_basename.ext.

