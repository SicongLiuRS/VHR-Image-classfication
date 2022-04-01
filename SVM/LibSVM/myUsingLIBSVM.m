%% Cleanup
clc; clear all; close all;

%% Adding Paths LIBSVM Matlab
addpath F:\Mulfeatruefusion\spectral_spatial_classification\SVM\LibSVM;
addpath(genpath('./EMAP')) 
addpath('./LORSAL-BP')
addpath('./GraphCutMex')
addpath('./DATA')
addpath(genpath('./SVM'))
%% load hysperspectral image--spectral
[FileName1,PathName1,~] = uigetfile('*','Input the origin image','F:\Mulfeatruefusion\');
[org_img,info]=enviread([PathName1 FileName1]); 
[no_lines, no_columns,nb1] = size(org_img);
hyperspectral_img = org_img;
%% load lidar features--spatial
[FileName1,PathName1,~] = uigetfile('*','Input the AP image','F:\Mulfeatruefusion\');
[lidar_img,~]=enviread([PathName1 FileName1]);
%% load gt--spatial
load hyperspectral_img
load lidar_img
load train_class.mat
load test_class.mat
train_img = zeros(no_lines,no_columns);
test_img = zeros(no_lines,no_columns);
for i = 1:349
    for j =1:1905
        if 
            train_img(i,j) = 
 test_img = zeros(no_lines,no_columns);
test_class = gt_all;
for i = 1:349
    for j =1:1905
        if 
            test_img(i,j) =            
% Train and Test Data Selection
% Linear Kernel
train_img = train_label;
test_img = test_label;
model_linear = svmtrain(train_label, train_data, '-t 0');
model_precomputed = svmtrain(train_label, [(1:N)', train_data*train_data'], '-t 4');

% Applying SVM
[predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, test_data, model_linear);
[predict_label_P, accuracy_P, dec_values_P] = svmpredict(test_label, [(1:M-N)', test_data*train_data'], model_precomputed);
