%% bandcluster iteration
clear all;close all;
clc
addpath('./Image_data')
addpath('./Train_data')
addpath(genpath('./Fusion_model'))
addpath(genpath('./SVM'))
addpath ('./GFF_1.0')
%% load image
load zh1Org.mat
load zh1OrgAP.mat
img = normalize(double(img),0,1);
AP = AP(:,:,1:8);
AP = normalize(double(AP),0,1);
org_img = cat(3,img,AP);
[no_lines,no_columns,no_bands] = size(org_img); 
%% load train_set
load zh1train_set20.mat
load zh1training2D20.mat
load zh1test_set20.mat
name = 'zh1cluster20';
precises = zeros(8,53);
%% parameters
n_class = length(unique(test_set(2,:))); % number of class
% classification with SVM
in_param.probability_estimates = 1;
in_param.cost = 300;
in_param.gamma = 2^(-6);
in_param.kernel_type = 2;
%% feature stack 空谱特征叠加
org_img = ToVector(org_img);
s = tic;
%% perform function
class = 7;
finalfeature = bandcluster(org_img,class);
Inresult = Interfusion(finalfeature,no_lines,no_columns,class);

for wsize = 3:10
    outimg = Outerfusion(Inresult,class,wsize);
    [map_class,outdata] = classify_svm(outimg,training2D,in_param);
    % output probabilities
    [p,order,ordervalue] = aux_ordenar_v4(training2D,outdata.prob_estimates,no_lines, no_columns);
    p = p';
    [~,cmap] = max(p);
    [OA, kappa, AA, CA, EM] =calcError( test_set(2,:)-1, cmap(test_set(1,:))-1, 1: n_class);
    %% output precision
    precises(wsize-2,:) = [wsize , OA , kappa , AA, EM(:)'];
end
time =toc(s);
[max_OA,index] = max(precises(:,2));
%% 输出分类图
figure;
Raw_output = colormap(no_lines,no_columns,cmap);
imshow(Raw_output);
imwrite(Raw_output,['Result\',name,'.tif']);
%% 输出精度
%输出总精度和时间
precisesfinal = [precises(index,1:4),time]
fid = fopen('Result\Accuary.txt','a');
fprintf(fid,name);
fprintf(fid,'%15.4f %15.4f %15.4f %15.4f %15.4f\r\n',precisesfinal);
fclose(fid);
%输出各类精度
fid = fopen('Result\Accuary_EM.txt','a');
fprintf(fid,name);
fprintf(fid,'%10d',precises(index,5:end));
fprintf(fid,'%g\n',' ');
fclose(fid);