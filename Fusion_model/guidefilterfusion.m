%% 基于引导滤波的双尺度特征融合
function fusion_result = guidefilterfusion(Org,AP,wsize,eps)
%均值滤波-初始基础层
Org_base1 = double(filter2(fspecial('average',wsize),Org));  
AP_base1 = double(filter2(fspecial('average',wsize),AP));
%细节层-初始细节层
Org_detial1 = Org - Org_base1; 
AP_detial1 = AP - AP_base1;
%提取差异图
s1 = Org_base1.*AP_base1;
s2 = Org_detial1.*AP_detial1;
%引导滤波-最终基础层
Org_base2 = guidedfilter( Org_base1,s1, wsize,eps);
AP_base2 = guidedfilter( AP_base1,s1, wsize, eps);
%引导滤波-最终细节层
Org_detial2 = guidedfilter( Org_detial1, s2, wsize, eps);
AP_detial2 = guidedfilter(  AP_detial1,s2,wsize, eps);
%基础层融合
% fusion_result = Org_base2+AP_detial2;
fusion_base = (Org_base2+AP_base2)./2;
% %细节层融合
fusion_detial = (Org_detial2+AP_detial2)./2;
% %双尺度重构
 fusion_result = fusion_base+fusion_detial;
% imshow(fusion_result,[]);title('fusion result');
%%输出显示
% enviwrite(Org,enviinfo(Org),'E:\桌面\新建文件夹\Org','E:\桌面\新建文件夹\Org.hdr');
% enviwrite(AP,enviinfo(AP),'E:\桌面\新建文件夹\AP','E:\桌面\新建文件夹\AP.hdr');

% enviwrite(Org_base1(268:667,500:899),enviinfo(Org_base1(268:667,500:899)),'E:\桌面\新建文件夹\Org_base1','E:\桌面\新建文件夹\Org_base1.hdr');
% enviwrite(AP_base1(268:667,500:899),enviinfo(AP_base1(268:667,500:899)),'E:\桌面\新建文件夹\AP_base1','E:\桌面\新建文件夹\AP_base1.hdr');
% enviwrite(Org_detial1(268:667,500:899),enviinfo(Org_detial1(268:667,500:899)),'E:\桌面\新建文件夹\Org_detial1','E:\桌面\新建文件夹\Org_detial1.hdr');
% enviwrite(AP_detial1(268:667,500:899),enviinfo(AP_detial1(268:667,500:899)),'E:\桌面\新建文件夹\AP_detial1','E:\桌面\新建文件夹\AP_detial1.hdr');
% enviwrite(s1(268:667,500:899),enviinfo(s1(268:667,500:899)),'E:\桌面\新建文件夹\s1','E:\桌面\新建文件夹\s1.hdr');
% enviwrite(s2(268:667,500:899),enviinfo(s2(268:667,500:899)),'E:\桌面\新建文件夹\s2','E:\桌面\新建文件夹\s2.hdr');
% enviwrite(Org_base2(268:667,500:899),enviinfo(Org_base2(268:667,500:899)),'E:\桌面\新建文件夹\Org_base2','E:\桌面\新建文件夹\Org_base2.hdr');
% enviwrite(AP_base2(268:667,500:899),enviinfo(AP_base2(268:667,500:899)),'E:\桌面\新建文件夹\AP_base2','E:\桌面\新建文件夹\AP_base2.hdr');
% enviwrite(Org_detial2(268:667,500:899),enviinfo(Org_detial2(268:667,500:899)),'E:\桌面\新建文件夹\Org_detial2','E:\桌面\新建文件夹\Org_detial2.hdr');
% enviwrite(AP_detial2(268:667,500:899),enviinfo(AP_detial2(268:667,500:899)),'E:\桌面\新建文件夹\AP_detial2','E:\桌面\新建文件夹\AP_detial2.hdr');
% enviwrite(fusion_base(268:667,500:899),enviinfo(fusion_base(268:667,500:899)),'E:\桌面\新建文件夹\fusion_base','E:\桌面\新建文件夹\fusion_base.hdr');
% enviwrite(fusion_detial(268:667,500:899),enviinfo(fusion_detial(268:667,500:899)),'E:\桌面\新建文件夹\fusion_detial','E:\桌面\新建文件夹\fusion_detial.hdr');
% enviwrite(fusion_result(268:667,500:899),enviinfo(fusion_result(268:667,500:899)),'E:\桌面\新建文件夹\fusion_result','E:\桌面\新建文件夹\fusion_result.hdr');
