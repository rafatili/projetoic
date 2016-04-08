close all
clear all
clc

load SRMR3.mat

[lin, col] = size(SRMR_resultados.Audio);

ref_cl2=repmat(SRMR_resultados.Audio2(:,1), 1,col);
%ref_cl = 1;
SRMRnorm.Audio=SRMR_resultados.Audio2./ref_cl2;
ref_cl=repmat(SRMR_resultados.Audio(:,1), 1,col);
SRMRnorm.Audio_CI=SRMR_resultados.Audio./ref_cl;
%SRMRnorm.Audio_CI = SRMRnorm.Audio_CI/max(max(SRMRnorm.Audio_CI));

ref=repmat(SRMR_resultados.Vocoder.Harmonicos(:,1), 1,col);
SRMRnorm.Vocoder.Harmonicos=SRMR_resultados.Vocoder.Harmonicos./ref;

ref=repmat(SRMR_resultados.Vocoder.Ruido(:,1), 1,col);
SRMRnorm.Vocoder.Ruido=SRMR_resultados.Vocoder.Ruido./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos=SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Gauss.Ruido=SRMR_resultados.Neuro_Vocoder.Gauss.Ruido./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc1=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc2=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc3=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc4=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc8=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc1=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc2=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc4=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc8=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8./ref;


%% Harmonic Complex
St.Audio=quantile(SRMRnorm.Audio,3);
St.Audio_CI=quantile(SRMRnorm.Audio_CI,3);
St.Vocoder.Harmonicos=quantile(SRMRnorm.Vocoder.Harmonicos,3);
St.Neuro_Vocoder.Gauss.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos,3);
St.Neuro_Vocoder.Exponencial.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc3,3);

medians=[St.Audio(2,:); St.Audio_CI(2,:); St.Vocoder.Harmonicos(2,:); St.Neuro_Vocoder.Gauss.Harmonicos(2,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(2,:)]; %median
lowQ=[St.Audio(1,:); St.Audio_CI(1,:);St.Vocoder.Harmonicos(1,:); St.Neuro_Vocoder.Gauss.Harmonicos(1,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Audio(3,:);St.Audio_CI(3,:); St.Vocoder.Harmonicos(3,:); St.Neuro_Vocoder.Gauss.Harmonicos(3,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(3,:)]; %upper quartile
highQ=highQ-medians;

color=['k','r','m','b','g'];
marker=['o','o','o','o','o'];
SNR = {'','-5','0','5','10','INF',''};
SNR_values = 15:-5:-5;
figure()
hold on
for j=1:5
    errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),'Color',color(j),'Marker',marker(j),...
        'MarkerSize',8,'LineWidth',2,'LineStyle','-','MarkerFaceColor',color(j))
end
%legend('Audio','Vocoder','Neuro-vocoder Gauss','Neuro-vocoder Exponencial')
xlabel('SNR(dB)','FontSize',12)
ylabel('normalized SRMR','FontSize',12)
legend('Unprocessed-NH','Unprocessed-CI','SV','NV Gauss','NV Exp BP','Location','NorthWest')
title('Harmonic Complex','FontSize',12)
ylim([0 1])
set(gca,'XtickL',SNR,'FontSize',12)
grid on



%% White Noise

St.Vocoder.Ruido=quantile(SRMRnorm.Vocoder.Ruido,3);
St.Neuro_Vocoder.Gauss.Ruido=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Ruido,3);
St.Neuro_Vocoder.Exponencial.Ruido.lc3=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3,3);

medians=[St.Audio(2,:); St.Audio_CI(2,:); St.Vocoder.Ruido(2,:); St.Neuro_Vocoder.Gauss.Ruido(2,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(2,:)]; %median
lowQ=[St.Audio(1,:); St.Audio_CI(1,:); St.Vocoder.Ruido(1,:); St.Neuro_Vocoder.Gauss.Ruido(1,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Audio(3,:); St.Audio_CI(3,:); St.Vocoder.Ruido(3,:); St.Neuro_Vocoder.Gauss.Ruido(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(3,:)]; %upper quartile
highQ=highQ-medians;

figure()
hold on
for j=1:5
    errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),'Color',color(j),'Marker',marker(j),...
        'MarkerSize',8,'LineWidth',2,'LineStyle','-','MarkerFaceColor',color(j))
end
%legend('Audio','Vocoder','Neuro-vocoder Gauss','Neuro-vocoder Exponencial')
xlabel('SNR(dB)','FontSize',12)
ylabel('normalized SRMR','FontSize',12)
legend('Unprocessed-NH','Unprocessed-CI','SV','NV Gauss','NV Exp BP','Location','NorthWest')
title('White Noise','FontSize',12)
ylim([0 1])
set(gca,'XtickL',SNR,'FontSize',12)
grid on

%% SRMR Clean

SRMRnorm.Vocoder.Ruido=SRMR_resultados.Vocoder.Ruido(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Gauss.Ruido=SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,1)./ref_cl2(:,1);

St.Vocoder.Ruido=quantile(SRMRnorm.Vocoder.Ruido,3)';
St.Neuro_Vocoder.Gauss.Ruido=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Ruido,3)';
St.Neuro_Vocoder.Exponencial.Ruido=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido,3)';

medians=[St.Vocoder.Ruido(2,:); St.Neuro_Vocoder.Gauss.Ruido(2,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido(2,:)]; %median
lowQ=[St.Vocoder.Ruido(1,:); St.Neuro_Vocoder.Gauss.Ruido(1,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Vocoder.Ruido(3,:); St.Neuro_Vocoder.Gauss.Ruido(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido(3,:)]; %upper quartile
highQ=highQ-medians;

SRMRnorm.Vocoder.Harmonicos=SRMR_resultados.Vocoder.Harmonicos(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos=SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,1)./ref_cl2(:,1);

St.Vocoder.Harmonicos=quantile(SRMRnorm.Vocoder.Harmonicos,3)';
St.Neuro_Vocoder.Gauss.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos,3)';
St.Neuro_Vocoder.Exponencial.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos,3)';

medians2=[St.Vocoder.Harmonicos(2,:); St.Neuro_Vocoder.Gauss.Harmonicos(2,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(2,:)]; %median
lowQ2=[St.Vocoder.Harmonicos(1,:); St.Neuro_Vocoder.Gauss.Harmonicos(1,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(1,:)]; %lower quartile
lowQ2=lowQ2-medians2;

highQ2=[St.Vocoder.Harmonicos(3,:); St.Neuro_Vocoder.Gauss.Harmonicos(3,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(3,:)]; %upper quartile
highQ2=highQ2-medians2;

marker=['o','o','o'];
figure()
hold on
for j=1:3
    errorbar(j, medians(j,1), lowQ(j,1), highQ(j,1),'Color','r','Marker',marker(j),...
        'MarkerSize',10,'LineWidth',2.5,'LineStyle','-','MarkerFaceColor','r')

    errorbar(j, medians2(j,1), lowQ2(j,1), highQ2(j,1),'Color','b','Marker',marker(j),...
        'MarkerSize',10,'LineWidth',2.5,'LineStyle','-','MarkerFaceColor','b')
end
legend('White Noise','Harmonic Complex','Location','NorthWest')
%xlabel('SNR(dB)')
ylabel('normalized SRMR','FontSize',12)
title('SNR = INF','FontSize',12)
ylim([0 0.8])
set(gca,'XtickL',{'','SV','','NV Gauss','','NV Exp',''},'FontSize',12)
grid on




%% Current Spread WN e HC

SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc1=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc2=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc4=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc8=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(:,1)./ref_cl2(:,1);

SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc1=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc2=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc3=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc4=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(:,1)./ref_cl2(:,1);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc8=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(:,1)./ref_cl2(:,1);

St.Neuro_Vocoder.Exponencial.Ruido.lc1=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc1,3)';
St.Neuro_Vocoder.Exponencial.Ruido.lc2=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc2,3)';
St.Neuro_Vocoder.Exponencial.Ruido.lc3=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3,3)';
St.Neuro_Vocoder.Exponencial.Ruido.lc4=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc4,3)';
St.Neuro_Vocoder.Exponencial.Ruido.lc8=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc8,3)';


medians=[St.Neuro_Vocoder.Exponencial.Ruido.lc1(2,:); St.Neuro_Vocoder.Exponencial.Ruido.lc2(2,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(2,:); St.Neuro_Vocoder.Exponencial.Ruido.lc4(2,:); St.Neuro_Vocoder.Exponencial.Ruido.lc8(2,:)]; %median
%medians = fliplr(medians);
lowQ=[St.Neuro_Vocoder.Exponencial.Ruido.lc1(1,:); St.Neuro_Vocoder.Exponencial.Ruido.lc2(1,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(1,:); St.Neuro_Vocoder.Exponencial.Ruido.lc4(1,:); St.Neuro_Vocoder.Exponencial.Ruido.lc8(1,:)]; %lower quartile
%lowQ = fliplr(lowQ);
lowQ=lowQ-medians;
highQ=[St.Neuro_Vocoder.Exponencial.Ruido.lc1(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc2(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc4(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc8(3,:)];%upper quartile
%highQ=fliplr(highQ);
highQ=highQ-medians;

St.Audio=quantile(SRMRnorm.Audio,3);
St.Neuro_Vocoder.Exponencial.Harmonicos.lc1=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc1,3)';
St.Neuro_Vocoder.Exponencial.Harmonicos.lc2=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc2,3)';
St.Neuro_Vocoder.Exponencial.Harmonicos.lc3=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc3,3)';
St.Neuro_Vocoder.Exponencial.Harmonicos.lc4=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc4,3)';
St.Neuro_Vocoder.Exponencial.Harmonicos.lc8=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos.lc8,3)';

medians2=[St.Neuro_Vocoder.Exponencial.Harmonicos.lc1(2,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc2(2,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos.lc3(2,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc4(2,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc8(2,:)]; %median
%medians = fliplr(medians);
lowQ2=[St.Neuro_Vocoder.Exponencial.Ruido.lc1(1,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc2(1,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos.lc3(1,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc4(1,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc8(1,:)]; %lower quartile
%lowQ = fliplr(lowQ);
lowQ2=lowQ2-medians2;
highQ2=[St.Neuro_Vocoder.Exponencial.Ruido.lc1(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc2(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(3,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc4(3,:); St.Neuro_Vocoder.Exponencial.Harmonicos.lc8(3,:)];%upper quartile
%highQ=fliplr(highQ);
highQ2=highQ2-medians2;

marker=['o','o','o'];
figure()
hold on
for j=1:5
    errorbar(j, medians(j,1), lowQ(j,1), highQ(j,1),'Color','r','Marker','o',...
        'MarkerSize',10,'LineWidth',2.5,'LineStyle','-','MarkerFaceColor','r')

    errorbar(j, medians2(j,1), lowQ2(j,1), highQ2(j,1),'Color','b','Marker','o',...
        'MarkerSize',10,'LineWidth',2.5,'LineStyle','-','MarkerFaceColor','b')
end
%legend('Standard Vocoder','Neural Vocoder Gauss','Neural Vocoder Exp')
legend('White Noise','Harmonic Complex','Location','NorthWest')
%xlabel('SNR(dB)')
ylabel('normalized SRMR','FontSize',12)
title('SNR = INF','FontSize',12)
ylim([0 0.8])
set(gca,'XtickL',{'','1mm','2mm','3mm','4mm','8mm',''},'FontSize',12)
grid on

%% Intelligibility

% Inteligibilidade_resultados.Audio = [srmr2intel2(mean(SRMR_resultados.Audio(:,1)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Audio(:,2)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Audio(:,3)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Audio(:,4)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Audio(:,5)),mean(SRMR_resultados.Audio(:,1)),1)];
% 
% Inteligibilidade_resultados.Audio2 = [srmr2intel2(mean(SRMR_resultados.Audio2(:,1)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Audio2(:,2)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Audio2(:,3)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Audio2(:,4)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Audio2(:,5)),mean(SRMR_resultados.Audio2(:,1)),0)];
% 
% Inteligibilidade_resultados.Audio2 = 100*Inteligibilidade_resultados.Audio2/95.3269;
% 
% Inteligibilidade_resultados.Vocoder.Harmonicos = [srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,1)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,2)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,3)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,4)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,5)),mean(SRMR_resultados.Audio2(:,1)),0)];
% 
% Inteligibilidade_resultados.Vocoder.Ruido = [srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,1)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,2)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,3)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,4)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,5)),mean(SRMR_resultados.Audio2(:,1)),0)];
% 
% Inteligibilidade_resultados.Neuro_Vocoder.Gauss.Harmonicos = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,1)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,2)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,3)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,4)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,5)),mean(SRMR_resultados.Audio2(:,1)),0)];
% 
% Inteligibilidade_resultados.Neuro_Vocoder.Gauss.Ruido = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,1)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,2)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,3)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,4)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,5)),mean(SRMR_resultados.Audio2(:,1)),0)];
% 
% Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3 = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,1)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,2)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,3)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,4)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(:,5)),mean(SRMR_resultados.Audio2(:,1)),0)];
% 
% % Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1 = srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(:,1)),mean(SRMR_resultados.Audio(:,1)),0);
% % 
% % Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2 = srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(:,1)),mean(SRMR_resultados.Audio(:,1)),0);
% % 
% Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3 = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,2)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,3)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,4)),mean(SRMR_resultados.Audio2(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,5)),mean(SRMR_resultados.Audio2(:,1)),0)];


intel.Audio = srmr2intel2(SRMR_resultados.Audio,ref_cl,1);
intel.Audio2 = 100*srmr2intel2(SRMR_resultados.Audio,ref_cl2,0)/95.3997;
intel.Vocoder.Harmonicos = srmr2intel2(SRMR_resultados.Vocoder.Harmonicos,ref_cl2,0);
intel.Vocoder.Ruido = srmr2intel2(SRMR_resultados.Vocoder.Ruido,ref_cl2,0);
intel.Neuro_Vocoder.Gauss.Harmonicos = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos,ref_cl2,0);
intel.Neuro_Vocoder.Gauss.Ruido = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido,ref_cl2,0);
intel.Neuro_Vocoder.Exponencial.Harmonicos = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3,ref_cl,0);
intel.Neuro_Vocoder.Exponencial.Ruido = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3,ref_cl,0);
% intel.Neuro_Vocoder.Exponencial.Ruido.lc3 = srmr2intel2(...
%     SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos,ref_cl,0);


St.Audio=quantile(intel.Audio,3);
St.Audio2=quantile(intel.Audio2,3);
St.Vocoder.Harmonicos=quantile(intel.Vocoder.Harmonicos,3);
St.Neuro_Vocoder.Gauss.Harmonicos=quantile(intel.Neuro_Vocoder.Gauss.Harmonicos,3);
St.Neuro_Vocoder.Exponencial.Harmonicos=quantile(intel.Neuro_Vocoder.Exponencial.Harmonicos,3);
St.Vocoder.Ruido=quantile(intel.Vocoder.Ruido,3);
St.Neuro_Vocoder.Gauss.Ruido=quantile(intel.Neuro_Vocoder.Gauss.Ruido,3);
St.Neuro_Vocoder.Exponencial.Ruido=quantile(intel.Neuro_Vocoder.Exponencial.Ruido,3);


medians=[St.Audio2(2,:); St.Audio(2,:); St.Vocoder.Harmonicos(2,:); St.Neuro_Vocoder.Gauss.Harmonicos(2,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(2,:)]; %median
lowQ=[St.Audio2(1,:); St.Audio(1,:);St.Vocoder.Harmonicos(1,:); St.Neuro_Vocoder.Gauss.Harmonicos(1,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Audio2(3,:);St.Audio(3,:); St.Vocoder.Harmonicos(3,:); St.Neuro_Vocoder.Gauss.Harmonicos(3,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(3,:)]; %upper quartile
highQ=highQ-medians;

color=['k','r','m','b','g'];
SNR = {'','-5dB','0dB','5dB','10dB','INF',''};
figure()
hold on
for j=1:5
    errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),'Color',color(j),'Marker','o',...
        'MarkerSize',8,'LineWidth',1.5,'LineStyle','-','MarkerFaceColor',color(j))
end
xlabel('SNR(dB)','FontSize',12)
ylabel('Intelligibility (%)','FontSize',12)
legend('Unprocessed-NH','Unprocessed-CI','SV','NV Gauss','NV Exp BP','Location','NorthWest')
title('Harmonic Complex','FontSize',12)
ylim([0 100])
set(gca,'XtickL',SNR)
grid on

medians=[St.Audio2(2,:); St.Audio(2,:); St.Vocoder.Ruido(2,:); St.Neuro_Vocoder.Gauss.Ruido(2,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido(2,:)]; %median
lowQ=[St.Audio2(1,:); St.Audio(1,:);St.Vocoder.Ruido(1,:); St.Neuro_Vocoder.Gauss.Ruido(1,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Audio2(3,:);St.Audio(3,:); St.Vocoder.Ruido(3,:); St.Neuro_Vocoder.Gauss.Ruido(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido(3,:)]; %upper quartile
highQ=highQ-medians;

color=['k','r','m','b','g'];
SNR = {'','-5dB','0dB','5dB','10dB','INF',''};
figure()
hold on
for j=1:5
    errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),'Color',color(j),'Marker','o',...
        'MarkerSize',8,'LineWidth',1.5,'LineStyle','-','MarkerFaceColor',color(j))
end
xlabel('SNR(dB)','FontSize',12)
ylabel('Intelligibility (%)','FontSize',12)
legend('Unprocessed-NH','Unprocessed-CI','SV','NV Gauss','NV Exp BP','Location','NorthWest')
title('White Noise','FontSize',12)
ylim([0 100])
set(gca,'XtickL',SNR)
grid on
