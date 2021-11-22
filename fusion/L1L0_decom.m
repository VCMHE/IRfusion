function [B,D] = L1L0_decom(img)
lambda1 = 0.3;  
lambda2 = lambda1*0.01;
lambda3 = 0.1;

[B,D]=Layer_decomp(img,lambda1,lambda2,lambda3);


end

