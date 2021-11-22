clear;clc;
%% Parameters
lambda1 = 0.006;  
lambda2 = lambda1*0.01;
lambda3 = 0.1;

%% read files

for i=1:21
index = i;
path1 = ['IVdataset/VIS',num2str(index),'.png'];
hdr=im2double(imread(path1));
[hei,wid,channel] = size(hdr);

%% transformation
hdr=log(hdr+0.0001);
hdr = nor(hdr);


%%  decomposition
[D1,D2,B2] = Layer_decomp(hdr,lambda1,lambda2,lambda3);

%% Scaling
sigma_D1 = max(D1(:));
D1s = R_func(D1,0,sigma_D1,0.8,1);
B2_n= compress(B2,2.2,1);
hdr_lnn = 0.8*B2_n + D2 + 1.2*D1s;
%figure(2),imshow(hdr_lnn,[]);
%% postprocessing
hdr_lnn = nor(clampp(hdr_lnn,0.005,0.995));
%% brightness adjustment
path_orimage= ['IVdataset/VIS',num2str(index),'.png'];
orig_image=im2double(imread(path_orimage));

lambda_tuine=0.00001;% in this paper the value of lambda is changed from 0.00001 to 10000
R = abs(orig_image);
Emax = max(R(:));
P = R/Emax;
C = atan(lambda_tuine*P)/atan(lambda_tuine);
hdr_lnn_new=(C.*oimage) + ((1-C).*hdr_lnn);
dir5='your path to store the enhanced images with different lambda';
path5 = [dir5,'VIS_0.00001_',num2str(index),'.png'];
imwrite(hdr_lnn_new,path5);
end

