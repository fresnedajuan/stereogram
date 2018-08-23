# Stereogram (Matlab implementation)
This is an implementation where a depth map image is taken as an input and a random dot stereogram is generated in a bitmap image in the output.

## Installation
- Clone the repository 
- Add the cloned repository and sub-folders to the matlab path
- Run the "stereogram.m"
- Load the disparity map
- Press "Start Stereogram" and select where do you want to save the image


## Algorithm and descpription of the implementation
This program generates a single image random dot stereogram using a disparity map image. The sizeof the image is resized to 800x600 pixels.
The first part generates a random (1 or 0) matrix (pattern) which size is 160x600.
The next part of the algorithm re-maps the disparity map (gray sacale image) in a new disparity map matrix with 5 levels of depth (level 0 is the background)
Then the pattern is pasted repeatedly in a new matrix 'mImage' 5 times to make the whole image.

<p align="center"> 
<img src="flowdiagram.png">
</p>

function [mOut, prevOut,rOutFlag] = pxl2stereogram(mIn, dsMap,offset)
input aguments:
	mIn: input matrix that is going to be modified, is one of the five sections of the image, in the first iteraction is the pattern that is being repeated in the whole image
	dsMap: input matrix with the disparity map of the section
	ofsset: number of positions that are going to be shifted each of the pixels according to the disparity map
output arguments:
	mOut: output martix 
	prevOut: if rOutFlag = 1, prevOut is 