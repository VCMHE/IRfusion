%% learning coupled dictionaries from multifocus training data
clear
clc
addpath('couple_dictionary_learning_codes')
%%
training_path = 'new_dataset_20pairs\';
col = 2000;
col_smooth = 1000;
unit=16;

%% parameters
P = 50000; % max number of training patches
p = 16; % patch size
ss = 1; % sliding step
Eps = p^2*1e-4; %approximation threshold
w = 0.5; % tuning parameter omega
param.omega = w; 
opts.eps = Eps; 
opts.k = 5; % maximim number of nonzeros in sparse vectors
opts.K = 4*p^2; % number of atoms in dictionaries
opts.Nit = 5; % number of CDL iterations
opts.remMean = true; % removing mean from the samples
opts.DCatom = true; % first atom is DC atom
opts.print = true; % printing the results

%% prepairing training data
Xf = []; % detail
Xb = []; % smooth
[Xf,Xb]=training_class_b_f(training_path, unit);   
P1 = min(P,length(Xf));
Inds1 = randperm(size(Xf,2));
Xb = Xb(:,Inds1(1:P1)); 
V = var([Xf;Xb]); % make sure patches with low variance are removed from traing data
Xf(:,V<Eps) = [];
Xb(:,V<Eps) = [];
P = min(P,length(Xf));
Inds = randperm(size(Xf,2));
Xf = Xf(:,Inds(1:P)); Xf = Xf - mean(Xf);
Xb = Xb(:,Inds(1:P)); Xb = Xb - mean(Xb);
%% learning coupled dictionaries
[Df, Db] = CDL(Xf,Xb,opts);
ID1 = displayPatches(Df);
ID2 = displayPatches(Db);
%figure(2)
%subplot 121
%imshow(ID1)
%title('Df16100')
%subplot 122
%imshow(ID2)
%title('Db16100')
%save('20pair_p16_100','Df','Db')

    