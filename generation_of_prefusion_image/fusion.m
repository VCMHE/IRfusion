function  [imgf, Mask] = fusion(im1,im2,Df,Db)


% generation of prefusion images
% Inputs: infrared and visible images(im1,im2); coupled dictionaries(Df,Db)
% Outout: fused image (imF)
%
%
img1=im1;
img2=im2;



D = [Df;Db]; D = D./sqrt(sum(D.^2));
p = sqrt(size(Df,1)); % patch size
ss = 2; % sliding step
Eps = p^2*1e-4; %approximation threshold
k = 3; % maximum sparsity
param.L = k;
param.eps = Eps;
[hei, wid] = size(im1);
%%% joint sparse approximation
X1 = mexExtractPatches(mean(im1,3),p,ss); X1 = X1 - mean(X1);
X2 = mexExtractPatches(mean(im2,3),p,ss); X2 = X2 - mean(X2);

Xj1 = [X1;X2];
Xj2 = [X2;X1];

% common sparse representation
A1 = mexOMP(Xj1,D,param);
A2 = mexOMP(Xj2,D,param);

%%% Fusion
% approximation errors
e1 = sum( (D*A1 - Xj1).^2 ); 
e2 = sum( (D*A2 - Xj2).^2 );

Mv = ones(p^2,1)*double(e1<e2); % vectorized mask
Mask = mexCombinePatches(Mv,zeros(size(im1,1),size(im1,2)),p,0,ss);
Mask(Mask>0.5)=1;
Mask(Mask<=0.5)=0;
% refining the mask
ker = 10;
Mask = conv2(Mask,ones(ker)/ker^2,'same');
Mask(Mask>.5)=1;
Mask(Mask<=.5)=0;
% masking
weightMap=Mask;
pyr = L1L0_gaussin_pyramid(zeros(hei,wid));
nlev = length(pyr);
pyrW=L1L0_gaussin_pyramid(weightMap,nlev);
    if (size(img1,3)>1) || (size(img2,3)>1)
        % the first channel
        pyrI1=L1L0_pyramid(imgIR_1,nlev);
        pyrI2=L1L0_pyramid(imgVI_1,nlev);
        for l = 1:nlev
            if l==nlev
                vis_weight{l}=pyrI2{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI1{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            elseif l==1
                 vis_weight{l}=pyrI2{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI1{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            else
                  pyr{l}=maxrule(pyrI1{l},pyrI2{l});
            end
        end

        % reconstruct
        imgf_1 = reconstruct_L1L0_pyramid(pyr);

        % the second channel
        pyrI3=L1L0_pyramid(imgIR_2,nlev);
        pyrI4=L1L0_pyramid(imgVI_2,nlev);

        for l = 1:nlev
            if l==nlev
                vis_weight{l}=pyrI4{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI3{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            elseif l==1
                 vis_weight{l}=pyrI4{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI3{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            else
                  pyr{l}=maxrule(pyrI3{l},pyrI4{l});
            end
           
        end

        % reconstruct
        imgf_2 = reconstruct_L1L0_pyramid(pyr);

        % the third channel
        pyrI5=L1L0_pyramid(imgIR_3,nlev);
        pyrI6=L1L0_pyramid(imgVI_3,nlev);

        for l = 1:nlev
           if l==nlev
                vis_weight{l}=pyrI6{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI5{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            elseif l==1
                 vis_weight{l}=pyrI6{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI5{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            else
                  pyr{l}=maxrule(pyrI5{l},pyrI6{l});
            end
        end

        % reconstruct
        imgf_3 = reconstruct_L1L0_pyramid(pyr);

        imgf(:,:,1) = imgf_1;
        imgf(:,:,2) = imgf_2;
        imgf(:,:,3) = imgf_3;

    else
       pyrI1=L1L0_pyramid(img1,nlev);
       pyrI2=L1L0_pyramid(img2,nlev);
%%
        for l = 1:nlev
            if l==nlev
                % pyr{l}=band_fuse(pyrI1{l},pyrI2{l},pyrW{l},0.6);% cdl
                vis_weight{l}=pyrI2{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI1{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            elseif l==1
                 vis_weight{l}=pyrI2{l}.*(1-pyrW{l});
                 ir_weight{l}=pyrI1{l}.*(pyrW{l});
                 new_weightmap{l}=vis_weight{l}+ir_weight{l};
                  pyr{l}= new_weightmap{l};
            else
                  pyr{l}=maxrule(pyrI1{l},pyrI2{l});
            end
        end
        % reconstruct
        imgf = reconstruct_L1L0_pyramid(pyr);
    toc;
    imgf = uint8(imgf*255);
    end
end





