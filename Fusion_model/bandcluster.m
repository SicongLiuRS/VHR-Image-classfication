%% �Ǽල���ξ���
% clc;clear all;
% %% load all feature image
% [FileName1,PathName1,~] = uigetfile('*','Input the envi image','F:\Mulfeatruefusion\');
% [img,~]=enviread([PathName1 FileName1]);
% [FileName1,PathName1,~] = uigetfile('*','Input the envi image','F:\Mulfeatruefusion\');
% [ap_img,~]=enviread([PathName1 FileName1]);
function finalfeature = bandcluster(img, class)
%% feature stack ������������
[~,no_bands] = size(img); 
%% Pearson correlation coefficient �������ϵ������
%  R = corrcoef(img);
%% mutual information ���λ���Ϣ����
for i = 1:no_bands
    for j = 1:no_bands
        MI(i,j) = mutualinfo(img(:,i),img(:,j));
    end
end
%% ��Ϊkmeans���ξ���Ĳ�������
imagefeature = cat(1, MI);
imagefeature = imagefeature';% ���ദ��ǰ�������ں�
img = img';% ���ദ��ǰ�������ں�
% ��ʼ���ࣨ�����ǲ���֮������ϵ���ͻ���Ϣ��
step = no_bands/class;
for i = 1:class
    m = round(step*i);
    orgcenter(i,:) = imagefeature(m,:);
end
[orgincluster,clustercenter1,sumD1,D1] = kmeans(imagefeature,class,'start',orgcenter);
%% �����ʼ����Ԫ��
orginfeature ={};
 for i=1:class
     orginfeaturesub = find(orgincluster==i);
     orginfeature{i,1} = img(orginfeaturesub,:); 
     finalcenter(i,:) = img(orginfeaturesub(1),:);
 end
% ������ʼ����õ��ĳ�ʼ�������پ��ࣨ�����ǲ��ε����лҶ�ֵ��
[finalcluster,clustercenter2,sumD2,D2] = kmeans(img,class,'start',finalcenter);
%% ������վ���Ԫ��
 finalfeature ={};
 for i=1:class
     finalfeaturesub = find(finalcluster==i);
     finalfeature{i,1} = img(finalfeaturesub,:);   
 end
 