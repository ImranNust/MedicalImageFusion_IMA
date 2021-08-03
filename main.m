clear; close all; clc; warning off
%% A Novel Multi-Modality Anatomical Image FusionMethod Based on Contrast and Structure Extraction
% F = fuseImage(I,scale)

%Inputs:
%I - a mulyi-modal anatomical image sequence

%scale - scale factor of dense SIFT, the default value is 16

%% load images from the folder that contain multi-modal image to be fused
%I=load_images('./Dataset\CT-MRI\Pair 1');
I=load_images('./Dataset\MR-T1-MR-T2\Pair 1');
%I=load_images('./Dataset\MR-Gad-MR-T1\Pair 1');
% Show source input images 
figure;
no_of_images = size(I,4);
for i = 1:no_of_images
    subplot(2,1,i); imshow(I(:,:,:,i));
end
suptitle('Source Images');


%%
F=fuseImage(I,16);
%% Output: F - the fused image

F=rgb2gray(F);
figure;
imshow(F);
