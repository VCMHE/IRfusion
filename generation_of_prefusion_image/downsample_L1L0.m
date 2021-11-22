% Downsampling procedure.
%
% Arguments:
%   grayscale I image
%   downsampling filter 'filter', should be a 1D separable filter.
%   'border_mode' should be 'circular', 'symmetric', or 'replicate'. See 'imfilter'.
%
% If image width W is odd, then the resulting image will have width (W-1)/2+1,
% Same for height.
%
% tom.mertens@gmail.com, August 2007
%

function R = downsample_L1L0(I)

border_mode = 'symmetric';


lambda1 = 0.006;  
%lambda1 = 0.3; %т╜ндов
lambda2 = lambda1*0.01;%lambda2 = lambda1*0.01;
lambda3 = 0.03;


% low pass, convolve with separable filter
%R = imfilter(I,filter,border_mode);     %horizontal
%R = imfilter(R,filter',border_mode);    %vertical
R=L1L0(I,lambda1,lambda2);
%R=L1(I,lambda3);
%R=L1_useto_pyr(I);
% decimate
r = size(I,1);
c = size(I,2);
R = R(1:2:r, 1:2:c, :);  
%figure,imshow(R),title('Ldownsample');
