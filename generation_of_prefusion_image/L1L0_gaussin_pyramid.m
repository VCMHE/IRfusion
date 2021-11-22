function pyr= L1L0_gaussin_pyramid(I,nlev)
r = size(I,1);
c = size(I,2);

if ~exist('nlev')
    %compute the highest possible pyramid
    nlev = floor(log(min(r,c)) / log(2));
end

% start by copying the image to the finest level
pyr = cell(nlev,1);
pyr{1} = I;

% recursively downsample the image
for l = 2:nlev
    I = downsample_L1L0(I);
    pyr{l} = I;
end
end

