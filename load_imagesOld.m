% This procedure loads a sequence of images
%
% Arguments:
%   'path', refers to a directory which contains a sequence of JPEG or PPM
%   images
%   'reduce' is an optional parameter that controls downsampling, e.g., reduce = .5
%   downsamples all images by a factor of 2.
%
% tom.mertens@gmail.com, August 2007
%

function I = load_images(path)


% find all JPEG or PPM files in directory
files = dir([path '/*.tif']);
N = length(files);
if (N == 0)
    files = dir([path '/*.jpg']);
    N = length(files);
    if (N == 0)
    files = dir([path '/*.gif']);
    N = length(files);
         if (N == 0)
    files = dir([path '/*.bmp']);
    N = length(files);
          if (N == 0)
              files = dir([path '/*.png']);
    N = length(files);
       if (N == 0)
            error('no files found');
       end
          end
         end
    end
end
%% 


% allocate memory
sz = size(imread([path '/' files(1).name]));
r = floor(sz(1));
c = floor(sz(2));
I = zeros(r,c,3,N);
%% 

% read all files
for i = 1:N
    
    % load image
    filename = [path '/' files(i).name];
    OrigImg = im2double(imread(filename));
    
    im = enhnc(OrigImg);
  %im=enhnc(im1);
    if (size(im,1) ~= r || size(im,2) ~= c)
       im = imresize(im, [r c]);
    %  error('images must all have the same size');
    end
    
    
    if size(im,3)==1
    I(:,:,:,i) = cat(3,im,im,im);
    else
    I(:,:,:,i) = im;
    end
%     I=uint8(I);
end
