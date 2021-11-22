 
% If our thesis ideas are helpful to you, please help us light up the stars in Github, Thank you!
% If you use these code in your research, please cite:
% @conference{
%	author = {Guofa Li,Yongjie Lin,Xingda Qu},
%	title  = {An infrared and visible image fusion method based on Multi-scale Transformation and Norm Optimization},
%	booktitle = {Information Fusion},
%	year = {2021}
% }
function [fusion] = main1_L1L0(ImgIr, ImgVis,FusionPath,PreFusion_img,WeightFusionPath)
    % Parameter Description
    % ImgIr:  Infrared image to be fused
    % ImgVis: Visible image to be fused
    % FusionPath: Fusion image storage path
    % BalanceParameters: Controls the balance of infrared image contrast fidelity and infrared visible gradient
    %% Prefusion
    
    % Modify the image shape to fit the function requirements
    %Vis = shrink(H,W,ImgVis,2);
    
    % From 'https://www.mathworks.com/matlabcentral/fileexchange/36278-split-bregman-method-for-total-variation-denoising?s_tid=srchtitle'
    % Modify function input port
    % Inverse transformation back to original shape
   PreFusion=double(PreFusion_img);

    %% Decompose infrared image, visible image and pre-fusion image

    A=cell(1,3);
    A{1} = ImgVis;    %   Visible image
    A{2} = ImgIr;     %   Infrared image
    A{3} = PreFusion; %   Pre-fusion of the image for two purposes
                      %   1¡¢The low frequency layer is decomposed from MDLatLRR as the low frequency layer of the final fusion image.
                      %   2¡¢Assisted final image detail layer fusion (SSIM).

    % Decomposition of 4 scale: One Base layer and Four Detail layers

    Lrr_img=cell(1,3);
    Sal_img=cell(1,3);
    
    
    parfor i = 1:3
        [Lrr_img{i},Sal_img{i}] = L1L0_decom(A{i});
    end

    %% Fusion of detail layers
    
    Lrr = Lrr_img{3};

    [CAscore,CBscore] = Relevancy(A{1}, A{2}, A{3});
    %Weaken the interfering information and enhance the effective information
    offset = CAscore-CBscore ; 
    Weight = 0.5 + offset;
    Weight(Weight>1) = 1;
    Weight(Weight<0) = 0;
   % imwrite(mat2gray(Weight),WeightFusionPath);

    SalImg_A = Sal_img{1};% Visible image datail
    SalImg_B = Sal_img{2};% Infared image datail
    Sal1 = detail_fusion2_l1l0( SalImg_A, SalImg_B, Weight );
    %% Inverse transformation
    image = Lrr+Sal1;
    fusion = max(min(image,255), 0);
    figure,imshow(fusion,[]);title('fused');
  % imwrite(mat2gray(fusion),FusionPath);

end