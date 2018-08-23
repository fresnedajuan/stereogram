# Stereogram (Matlab implementation)
This is an implementation where a depth map image is taken as an input and a random dot stereogram is generated in a bitmap image in the output.

## Installation
- Clone the repository 
- Add the cloned repository and sub-folders to the matlab path
- Run the "stereogram.m"
- Load the disparity map
- Press "Start Stereogram" and select where do you want to save the image


## Algorithm and descpription of the implementation


1. This program generates a single image random dot stereogram using a disparity map image. The sizeof the image is resized to 800x600 pixels.
2. The first part generates a random (1 or 0) matrix (pattern) which size is 160x600.
3. The next part of the algorithm re-maps the disparity map (gray sacale image) in a new disparity map matrix with 5 levels of depth (level 0 is the background).
4. Then the pattern is pasted repeatedly in a new matrix 'mImage' 5 times to make the whole image.
5. Now the program is ready to start the procces. To make the stereogram the algorithm works whith each of the 5 sections of the mImage individualy.
6. The algorithm divides vertically the disparityMap and the mImage in 5 equal parts and use the function 'pxl2stereogram' to make the shifting of the pixels in each of the 5 parts of the mImage with each part of the disparityMap.
7. To make te proccess descrived in the numeral 6, the program pass the first section of the mImage with the first part of the disparityMap through the pxl2stereogram function and paste the resulting matrix on the first part of the mImage.
8. To make the stereogram properly, the second section of the mImage neds the iformation of the first section so the the program pass the second section of the mImage with the first part of the disparityMap through the pxl2stereogram function and then uses the resulting matrix to repeat the proces but using the second section of the disparityMap. To make third section the program is going to repet the proccess 3 times using the first three parts of the disparityMap image.
9. In some cases after pass a section through the pxl2stereogram function, the function returns information (prevOut) that have to be used in the previous section, that is why at the end of the program the algorithm copy the useful information on the previous section.
10. Finaly the proces from 6 to 9 is repeated whith the diferents depths.

<p align="center"> 
<img src="flowdiagram.png">
</p>

### Function description 
This function shift the pixels in the mIn matrix using the information of the dsMap. The number of units that shift the pixels is the offset.
```
function [mOut, prevOut,rOutFlag] = pxl2stereogram(mIn, dsMap,offset)
```

#### Input aguments:
	mIn: Input matrix that is going to be modified, it's one of the five sections of the image, in the first iteraction is the pattern that is being repeated in the whole image
	dsMap: input matrix with the disparity map of the section
	offset: number of positions that are going to be shifted each of the pixels according to the disparity map
#### Output arguments:
	mOut: output martix 
	prevOut: if rOutFlag = 1, prevOut is going to return th information tha have to be used on the previous section.
	rOutFlag: 1 if there is information in the prevOut matrix, 0 if is empty.

