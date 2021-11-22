
clc;
close all;

tic;
 for i = 1:21
     index=i;
%      % Path setting
      PathVis             = [ 'input_ad_IV\denoiseVIS' ,        num2str(index) ,        '.png' ]; 
       PathIr             = [ 'input_ad_IV\IR' ,        num2str(index) ,       '.png' ];
     FusionPath       = [ '',   num2str(index) ,          '.png' ];%your path to store the fusion image
     PreFusion    = [ 'p8_500\PF',   num2str(index) ,          '.png' ];
      WeightFusionPath = [ '',   num2str(index) ,          '.png' ];%your path to store the weightmap
%         
     % Read images
     ImgIr  = imread(PathIr);  
     ImgVis = imread(PathVis);
     
     PreFusion_img=imread(PreFusion);
     
     
     %%
     % Convert to single channel
     if size(ImgIr, 3)~=1
         ImgIr  = rgb2gray(ImgIr);
     end
     if size(ImgVis, 3)~=1
         ImgVis = rgb2gray(ImgVis);
     end
     
     % Start fusion
     image = main1_L1L0(double(ImgIr),double(ImgVis),FusionPath,PreFusion_img,WeightFusionPath);
     %figure,imshow(image,[]),title('fused');
end
toc;
