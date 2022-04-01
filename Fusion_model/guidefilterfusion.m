%% ���������˲���˫�߶������ں�
function fusion_result = guidefilterfusion(Org,AP,wsize,eps)
%��ֵ�˲�-��ʼ������
Org_base1 = double(filter2(fspecial('average',wsize),Org));  
AP_base1 = double(filter2(fspecial('average',wsize),AP));
%ϸ�ڲ�-��ʼϸ�ڲ�
Org_detial1 = Org - Org_base1; 
AP_detial1 = AP - AP_base1;
%��ȡ����ͼ
s1 = Org_base1.*AP_base1;
s2 = Org_detial1.*AP_detial1;
%�����˲�-���ջ�����
Org_base2 = guidedfilter( Org_base1,s1, wsize,eps);
AP_base2 = guidedfilter( AP_base1,s1, wsize, eps);
%�����˲�-����ϸ�ڲ�
Org_detial2 = guidedfilter( Org_detial1, s2, wsize, eps);
AP_detial2 = guidedfilter(  AP_detial1,s2,wsize, eps);
%�������ں�
% fusion_result = Org_base2+AP_detial2;
fusion_base = (Org_base2+AP_base2)./2;
% %ϸ�ڲ��ں�
fusion_detial = (Org_detial2+AP_detial2)./2;
% %˫�߶��ع�
 fusion_result = fusion_base+fusion_detial;
% imshow(fusion_result,[]);title('fusion result');
%%�����ʾ
% enviwrite(Org,enviinfo(Org),'E:\����\�½��ļ���\Org','E:\����\�½��ļ���\Org.hdr');
% enviwrite(AP,enviinfo(AP),'E:\����\�½��ļ���\AP','E:\����\�½��ļ���\AP.hdr');

% enviwrite(Org_base1(268:667,500:899),enviinfo(Org_base1(268:667,500:899)),'E:\����\�½��ļ���\Org_base1','E:\����\�½��ļ���\Org_base1.hdr');
% enviwrite(AP_base1(268:667,500:899),enviinfo(AP_base1(268:667,500:899)),'E:\����\�½��ļ���\AP_base1','E:\����\�½��ļ���\AP_base1.hdr');
% enviwrite(Org_detial1(268:667,500:899),enviinfo(Org_detial1(268:667,500:899)),'E:\����\�½��ļ���\Org_detial1','E:\����\�½��ļ���\Org_detial1.hdr');
% enviwrite(AP_detial1(268:667,500:899),enviinfo(AP_detial1(268:667,500:899)),'E:\����\�½��ļ���\AP_detial1','E:\����\�½��ļ���\AP_detial1.hdr');
% enviwrite(s1(268:667,500:899),enviinfo(s1(268:667,500:899)),'E:\����\�½��ļ���\s1','E:\����\�½��ļ���\s1.hdr');
% enviwrite(s2(268:667,500:899),enviinfo(s2(268:667,500:899)),'E:\����\�½��ļ���\s2','E:\����\�½��ļ���\s2.hdr');
% enviwrite(Org_base2(268:667,500:899),enviinfo(Org_base2(268:667,500:899)),'E:\����\�½��ļ���\Org_base2','E:\����\�½��ļ���\Org_base2.hdr');
% enviwrite(AP_base2(268:667,500:899),enviinfo(AP_base2(268:667,500:899)),'E:\����\�½��ļ���\AP_base2','E:\����\�½��ļ���\AP_base2.hdr');
% enviwrite(Org_detial2(268:667,500:899),enviinfo(Org_detial2(268:667,500:899)),'E:\����\�½��ļ���\Org_detial2','E:\����\�½��ļ���\Org_detial2.hdr');
% enviwrite(AP_detial2(268:667,500:899),enviinfo(AP_detial2(268:667,500:899)),'E:\����\�½��ļ���\AP_detial2','E:\����\�½��ļ���\AP_detial2.hdr');
% enviwrite(fusion_base(268:667,500:899),enviinfo(fusion_base(268:667,500:899)),'E:\����\�½��ļ���\fusion_base','E:\����\�½��ļ���\fusion_base.hdr');
% enviwrite(fusion_detial(268:667,500:899),enviinfo(fusion_detial(268:667,500:899)),'E:\����\�½��ļ���\fusion_detial','E:\����\�½��ļ���\fusion_detial.hdr');
% enviwrite(fusion_result(268:667,500:899),enviinfo(fusion_result(268:667,500:899)),'E:\����\�½��ļ���\fusion_result','E:\����\�½��ļ���\fusion_result.hdr');
