%% 非监督波段聚类
% clc;clear all;
% %% load all feature image
% [FileName1,PathName1,~] = uigetfile('*','Input the envi image','F:\Mulfeatruefusion\');
% [img,~]=enviread([PathName1 FileName1]);
% [FileName1,PathName1,~] = uigetfile('*','Input the envi image','F:\Mulfeatruefusion\');
% [ap_img,~]=enviread([PathName1 FileName1]);
function finalfeature = bandcluster(img, class)
%% feature stack 空谱特征叠加
[~,no_bands] = size(img); 
%% Pearson correlation coefficient 波段相关系数矩阵
%  R = corrcoef(img);
%% mutual information 波段互信息矩阵
for i = 1:no_bands
    for j = 1:no_bands
        MI(i,j) = mutualinfo(img(:,i),img(:,j));
    end
end
%% 作为kmeans波段聚类的波段特征
imagefeature = cat(1, MI);
imagefeature = imagefeature';% 聚类处在前，特征在后
img = img';% 聚类处在前，特征在后
% 初始聚类（特征是波段之间的相关系数和互信息）
step = no_bands/class;
for i = 1:class
    m = round(step*i);
    orgcenter(i,:) = imagefeature(m,:);
end
[orgincluster,clustercenter1,sumD1,D1] = kmeans(imagefeature,class,'start',orgcenter);
%% 输出初始聚类元胞
orginfeature ={};
 for i=1:class
     orginfeaturesub = find(orgincluster==i);
     orginfeature{i,1} = img(orginfeaturesub,:); 
     finalcenter(i,:) = img(orginfeaturesub(1),:);
 end
% 给定初始聚类得到的初始类中心再聚类（特征是波段的所有灰度值）
[finalcluster,clustercenter2,sumD2,D2] = kmeans(img,class,'start',finalcenter);
%% 输出最终聚类元胞
 finalfeature ={};
 for i=1:class
     finalfeaturesub = find(finalcluster==i);
     finalfeature{i,1} = img(finalfeaturesub,:);   
 end
 