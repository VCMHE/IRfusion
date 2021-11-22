function [B1,D] = Layer_decomp(img,lambda1,lambda2,lambda3)
%multi-scale L1L0 (ML1L0)
%% first scale decomposition
[hei,wid,~] = size(img);
[D1,B1] = L1L01(img,lambda1,lambda2);
%% second scale decomposition
scale = 4;
B1_d = imresize(B1,[round(hei/scale),round(wid/scale)],'bilinear');
[~,B2_d] = L1(B1_d,lambda3);
B2_r = imresize(B2_d,[hei,wid],'bilinear');
B2 = bilateralFilter(B2_r,nor(B1),0,1,min(wid,hei)/100,0.05);
D2 = B1 - B2; 

%% third scale decomposition
scale = 4;
B2_d = imresize(B2,[round(hei/scale),round(wid/scale)],'bilinear');
[~,B3_d] = L1(B2_d,lambda3);
B3_r = imresize(B3_d,[hei,wid],'bilinear');
B3 = bilateralFilter(B3_r,nor(B2),0,1,min(wid,hei)/100,0.05);
D3=B1-B3;
%% fourth scale decomposition
scale = 4;
B3_d = imresize(B3,[round(hei/scale),round(wid/scale)],'bilinear');
[~,B4_d] = L1(B3_d,lambda3);
B4_r = imresize(B4_d,[hei,wid],'bilinear');
B4= bilateralFilter(B4_r,nor(B3),0,1,min(wid,hei)/100,0.05);
D4=B1-B4;

D=cell(1,4);
D{1}=D1;
D{2}=D2;
D{3}=D3;
D{4}=D4;
end

