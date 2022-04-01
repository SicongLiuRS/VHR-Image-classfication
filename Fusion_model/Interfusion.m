function Infeature = Interfusion(finalfeature,no_lines,no_columns,class)
for i = 1:class
    X = finalfeature{i};
    if size(X,1)~=1
%         Infeature(:,:,i) = reshape((mean(X))',no_lines,no_columns,1);
       zz = PCA_img(reshape(X',no_lines,no_columns,size(X,1)),'all');
       Infeature(:,:,i) = zz(:,:,1);
    else
       Infeature(:,:,i) = reshape(X',no_lines,no_columns,1);    
   end
end
