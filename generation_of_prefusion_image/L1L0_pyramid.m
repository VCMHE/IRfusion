function pyr = L1L0_pyramid(img,nlev)
I=img;
r = size(I,1);
c = size(I,2);

% recursively build pyramid
pyr = cell(nlev,1);
J = I;
for l = 1:nlev - 1
    I = downsample_L1L0(J);
    odd = 2*size(I) - size(J);  % for each dimension, check if the upsampled version has to be odd
    % in each level, store difference between image and upsampled low pass version
    pyr{l} = J - upsample_L1L0(I,odd);
    J = I; % continue with low pass image
   
end
pyr{nlev} = J; % the coarest level contains the residual low pass image
end

