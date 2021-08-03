function [ F ] = fuseImage(I,scale)


addpath('Pyramid_Decomposition');
addpath('Guided_Filter');
addpath('Dense_SIFT');

tic
%%
[H, W, C, N]=size(I);
imgs=im2double(I);
IA=zeros(H,W,C,N);
for i=1:N
IA(:,:,:,i)=enhnc(imgs(:,:,:,i));

end
%%
imgs_gray=zeros(H,W,N);
for i=1:N
    imgs_gray(:,:,i)=rgb2gray(IA(:,:,:,i));
end
%
% %dense sift calculation
dsifts=zeros(H,W,32,N, 'single');
for i=1:N
    img=imgs_gray(:,:,i);
    ext_img=img_extend(img,scale/2-1);
    [dsifts(:,:,:,i)] = DenseSIFT(ext_img, scale, 1);
    
end
%%
%local contrast
contrast_map=zeros(H,W,N);
for i=1:N
    contrast_map(:,:,i)=sum(dsifts(:,:,:,i),3);

end


%winner-take-all weighted average strategy for local contrast

[x, labels]=max(contrast_map,[],3);
clear x;
for i=1:N
    mono=zeros(H,W);
    mono(labels==i)=1;
    contrast_map(:,:,i)=mono;

end



%% Structure 
h = [1 -1];
structure_map=zeros(H,W,N);

for i=1:N
structure_map(:,:,i) = abs(conv2(imgs_gray(:,:,i),h,'same')) + abs(conv2(imgs_gray(:,:,i),h','same')); %EQ 13

   
end


%winner-take-all weighted average strategy for structure

[a, label]=max(structure_map,[],3);
clear x;
for i=1:N
    monoo=zeros(H,W);
    monoo(label==i)=1;
    structure_map(:,:,i)=monoo;
     
end

%%
weight_map=structure_map.*contrast_map;




%weight map refinement using Guided Filter
for i=1:N
    
    weight_map(:,:,i) = fastGF(weight_map(:,:,i),12,0.25,2.5);
 
end



% normalizing weight maps
%
weight_map = weight_map + 10^-25; %avoids division by zero
weight_map = weight_map./repmat(sum(weight_map,3),[1 1 N]);

%% Pyramid Decomposition

% create empty pyramid
pyr = gaussian_pyramid(zeros(H,W,3));
nlev = length(pyr);

% multiresolution blending
for i = 1:N
    % construct pyramid from each input image
    pyrW = gaussian_pyramid(weight_map(:,:,i));

    pyrI = laplacian_pyramid(imgs(:,:,:,i));
    
    % blend
    for b = 1:nlev
        w = repmat(pyrW{b},[1 1 3]);
        
        pyr{b} = pyr{b} + w .*pyrI{b};
    end
    
end

% reconstruct
F = reconstruct_laplacian_pyramid(pyr);

toc

end

