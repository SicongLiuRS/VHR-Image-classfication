function norm_img = normalize(input_img,ymin,ymax)
%normalize matrix to minimum and maximum values
% 
[no_lines, no_columns,no_bands] = size(input_img);
org_img1 = reshape(input_img,no_lines*no_columns,no_bands);
org_img2 = mapminmax(org_img1',ymin,ymax);%按行归一化
norm_img = reshape(org_img2',no_lines,no_columns,no_bands);
end
