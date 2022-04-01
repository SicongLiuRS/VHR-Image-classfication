function color_img = colormap(no_lines,no_columns,imagelabel)
imagelabel = reshape(imagelabel,[no_lines,no_columns]);
% % AVIRIS Indian 16
% color = [50,54,109;44,91,170;37,148,189;53,196,237;152,215,223; ... 
%         126,203,178;21,191,74;80,184,72;107,150,67; ... 
%         246,191,111;236,233,78;212,122,45;99,142,202; ... 
%         242,104,107;238,45,42;139,38,41;191,191,59]; ... 
%ZH17 QuickBird 7
color = [0,0,0;0,255,0;0,0,255;255,255,0; ...
    0,255,255;255,0,255;176,48,96;46,139,87];
color_img = zeros(no_lines,no_columns,3);
for i = 1:3
    variable = imagelabel;
    for j = 1:8
        variable(variable==j-1) = color(j,i);
    end
    color_img(:,:,i) = variable;
end
% ZH2 QuickBird 4
% color = [0,0,0;0,255,0;0,0,255;255,255,0; 0,255,255];
% color_img = zeros(no_lines,no_columns,3);
% for i = 1:3
%     variable = imagelabel;
%     for j = 1:5
%         variable(variable==j-1) = color(j,i);
%     end
%     color_img(:,:,i) = variable;
% end
% ERS Landsat
%color = [0,0,0;255,255,0;255,0,0;0,0,255;87,250,255; 0,255,0];
% color = [0,   0,   0;   0, 205,   0; 127, 255,   0;  46, 139,  87;   0, 139,   0; ... 
%  160,  82,  45;   0, 255, 255; 255, 255, 255; 216, 191, 216; 255,   0,   0; ... 
%  139,   0,   0;   0,   0,   0; 255, 255,   0; 238, 154,   0;  85,  26, 139; ... 
%  255, 127,  80];
% color_img = zeros(no_lines,no_columns,3);
% for i = 1:3
%     variable = imagelabel;
%     for j = 1:16
%         variable(variable==j-1) = color(j,i);
%     end
%     color_img(:,:,i) = variable;
% end
color_img= uint8(color_img);
return