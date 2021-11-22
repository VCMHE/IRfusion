%% image fusion using coupled dictionary learning
close all
clear ;
addpath('couple_dictionary_learning_codes')
load('20pair_p8_500.mat');

for i=1:21
index =i;
path1 = ['IVdataset/IR',num2str(index),'.png'];
path2 = ['adaptive_VIS/denoiseVIS',num2str(index),'.png'];
%% input images
im1 = im2double(imread(path1));
im2 = im2double(imread(path2));

%% Fusion
tic
[imf,weightmap] = fusion(im1,im2,Df,Db);
toc

%%
dir1='';%you path to store the prefusion image
path3 = [dir1,'PF',num2str(index),'.png'];
imwrite(imf,path3);
%figure,imshow(imf);
%figure,imshow(weightmap);
%% 
dir2='';%you path to store the weight map
path4 = [dir2,'20pair_P8_iter500_',num2str(index),'.png'];
imwrite(weightmap,path4);
end