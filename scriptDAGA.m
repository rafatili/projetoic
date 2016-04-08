close all
clear all
clc

load SRMR3.mat

% figure()
% plot(SNR_values,Inteligibilidade_resultados.Audio,'-ok')
% hold on
% plot(SNR_values,Inteligibilidade_resultados.Vocoder.Harmonicos,'-ob')
% plot(SNR_values,Inteligibilidade_resultados.Neuro_Vocoder.Gauss.Harmonicos,'-or')
% plot(SNR_values,Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Harmonicos,'-og')
% hold off
% legend('Audio','Vocoder','Neuro-vocoder Gauss','Neuro-vocoder Exponencial')
%xlim([-5 15])
%ylim([0 1])

% figure()
% errorbar(SNR_values,SRMR_resultados.Neuro_Vocoder.Exponencial')
% hold on
% errorbar(SNR_values,SRMR_resultados.Vocoder')
% hold off
%% normalizado
[lin, col] = size(SRMR_resultados.Audio);

ref_cl=repmat(SRMR_resultados.Audio(:,1), 1,col);
SRMRnorm.Audio=SRMR_resultados.Audio./ref_cl;


ref=repmat(SRMR_resultados.Vocoder.Harmonicos(:,1), 1,col);
SRMRnorm.Vocoder.Harmonicos=SRMR_resultados.Vocoder.Harmonicos./ref;

ref=repmat(SRMR_resultados.Vocoder.Ruido(:,1), 1,col);
SRMRnorm.Vocoder.Ruido=SRMR_resultados.Vocoder.Ruido./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos=SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Gauss.Ruido=SRMR_resultados.Neuro_Vocoder.Gauss.Ruido./ref;

ref=repmat(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos(:,1), 1,col);
SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos./ref;

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


%% calcula estatísticas
St.Audio=quantile(SRMRnorm.Audio,3);
St.Vocoder.Harmonicos=quantile(SRMRnorm.Vocoder.Harmonicos,3);
St.Neuro_Vocoder.Gauss.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos,3);
St.Neuro_Vocoder.Exponencial.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos,3);

medians=[St.Audio(2,:); St.Vocoder.Harmonicos(2,:); St.Neuro_Vocoder.Gauss.Harmonicos(2,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(2,:)]; %median
lowQ=[St.Audio(1,:); St.Vocoder.Harmonicos(1,:); St.Neuro_Vocoder.Gauss.Harmonicos(1,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Audio(3,:); St.Vocoder.Harmonicos(3,:); St.Neuro_Vocoder.Gauss.Harmonicos(3,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(3,:)]; %upper quartile
highQ=highQ-medians;
%% plota figura
color=['k','r','m','b'];
marker=['o','o','o','o'];
SNR = {'','-5','0','5','10','INF',''};
figure()
hold on
for j=1:4
    errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),'Color',color(j),'Marker',marker(j),...
        'MarkerSize',8,'LineWidth',2,'LineStyle','-','MarkerFaceColor',color(j))
end
%legend('Audio','Vocoder','Neuro-vocoder Gauss','Neuro-vocoder Exponencial')
xlabel('SNR(dB)')
ylabel('normalized SRMR')
legend('Unprocessed','SV','NV Gauss','NV Exp BP','Location','NorthWest')
title('Harmonic Complex')
ylim([0 1])
set(gca,'XtickL',SNR)
grid on

%%
St.Audio=quantile(SRMRnorm.Audio,3);
St.Vocoder.Ruido=quantile(SRMRnorm.Vocoder.Ruido,3);
St.Neuro_Vocoder.Gauss.Ruido=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Ruido,3);
St.Neuro_Vocoder.Exponencial.Ruido.lc3=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3,3);

medians=[St.Audio(2,:); St.Vocoder.Ruido(2,:); St.Neuro_Vocoder.Gauss.Ruido(2,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(2,:)]; %median
lowQ=[St.Audio(1,:); St.Vocoder.Ruido(1,:); St.Neuro_Vocoder.Gauss.Ruido(1,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Audio(3,:); St.Vocoder.Ruido(3,:); St.Neuro_Vocoder.Gauss.Ruido(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(3,:)]; %upper quartile
highQ=highQ-medians;
%% plota figura
color=['k','r','m','b'];
marker=['o','o','o','o'];
figure()
hold on
for j=1:4
    errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),'Color',color(j),'Marker',marker(j),...
        'MarkerSize',8,'LineWidth',2,'LineStyle','-','MarkerFaceColor',color(j))
end
legend('Unprocessed','SV','NV Gauss','NV Exp BP','Location','NorthWest')
xlabel('SNR(dB)')
ylabel('normalized SRMR')
title('White Noise')
ylim([0 1])
set(gca,'XtickL',SNR)
grid on



%% calcula inteligibilidades
% intel.Audio = srmr2intel2(SRMR_resultados.Audio,ref_cl,1);
% intel.Vocoder.Harmonicos = srmr2intel2(SRMR_resultados.Vocoder.Harmonicos,ref_cl,0);
% % intel.Vocoder.Ruido = srmr2intel2(SRMR_resultados.Vocoder.Ruido,ref_cl,0);
% intel.Neuro_Vocoder.Gauss.Harmonicos = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos,...
%     ref_cl,0);
% % intel.Neuro_Vocoder.Gauss.Ruido = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido,...
% %     ref_cl,0);
% intel.Neuro_Vocoder.Exponencial.Harmonicos = srmr2intel2(...
%     SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos,ref_cl,0);
% % intel.Neuro_Vocoder.Exponencial.Ruido.lc3 = srmr2intel2(...
% %     SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos,ref_cl,0);
% 
% 
% St.Audio=quantile(intel.Audio,3);
% St.Vocoder.Harmonicos=quantile(intel.Vocoder.Harmonicos,3);
% St.Neuro_Vocoder.Gauss.Harmonicos=quantile(intel.Neuro_Vocoder.Gauss.Harmonicos,3);
% St.Neuro_Vocoder.Exponencial.Harmonicos=quantile(intel.Neuro_Vocoder.Exponencial.Harmonicos,3);
% 
% medians=[St.Audio(2,:); St.Vocoder.Harmonicos(2,:); St.Neuro_Vocoder.Gauss.Harmonicos(2,:); ...
%     St.Neuro_Vocoder.Exponencial.Harmonicos(2,:)]; %median
% lowQ=[St.Audio(1,:); St.Vocoder.Harmonicos(1,:); St.Neuro_Vocoder.Gauss.Harmonicos(1,:); ...
%     St.Neuro_Vocoder.Exponencial.Harmonicos(1,:)]; %lower quartile
% lowQ=lowQ-medians;
% 
% highQ=[St.Audio(3,:); St.Vocoder.Harmonicos(3,:); St.Neuro_Vocoder.Gauss.Harmonicos(3,:); ...
%     St.Neuro_Vocoder.Exponencial.Harmonicos(3,:)]; %upper quartile
% highQ=highQ-medians;
% %% plota figura
% color=['k','b','r','m'];
% SNR = {'','-5dB','0dB','5dB','10dB','INF',''}
% figure()
% hold on
% for j=1:4
%     errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),color(j),'Color',color(j),'Marker',marker(j),...
%         'MarkerSize',8,'LineWidth',1.5,'LineStyle','-','MarkerFaceColor',color(j))
% end
% xlabel('SNR(dB)')
% ylabel('Intelligibility (%)')
% legend('Unprocessed','SV','NV Gauss','NV Exp BP','Location','NorthWest')
% title('Harmonic Complex')
% ylim([0 100])
% set(gca,'XtickL',SNR)
% grid on
% 
% intel.Audio = srmr2intel2(SRMR_resultados.Audio,ref_cl,1);
% %intel.Vocoder.Harmonicos = srmr2intel2(SRMR_resultados.Vocoder.Harmonicos,ref_cl,0);
%  intel.Vocoder.Ruido = srmr2intel2(SRMR_resultados.Vocoder.Ruido,ref_cl,0);
% %intel.Neuro_Vocoder.Gauss.Harmonicos = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos,...
% %    ref_cl,0);
%  intel.Neuro_Vocoder.Gauss.Ruido = srmr2intel2(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido,...
%      ref_cl,0);
% %intel.Neuro_Vocoder.Exponencial.Harmonicos = srmr2intel2(...
% %    SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos,ref_cl,0);
%  intel.Neuro_Vocoder.Exponencial.Ruido.lc3 = srmr2intel2(...
%      SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos,ref_cl,0);
% 
% 
% St.Audio=quantile(intel.Audio,3);
% St.Vocoder.Ruido=quantile(intel.Vocoder.Ruido,3);
% St.Neuro_Vocoder.Gauss.Ruido=quantile(intel.Neuro_Vocoder.Gauss.Ruido,3);
% St.Neuro_Vocoder.Exponencial.Ruido.lc3=quantile(intel.Neuro_Vocoder.Exponencial.Ruido.lc3,3);
% 
% medians=[St.Audio(2,:); St.Vocoder.Ruido(2,:); St.Neuro_Vocoder.Gauss.Ruido(2,:); ...
%     St.Neuro_Vocoder.Exponencial.Ruido.lc3(2,:)]; %median
% lowQ=[St.Audio(1,:); St.Vocoder.Ruido(1,:); St.Neuro_Vocoder.Gauss.Ruido(1,:); ...
%     St.Neuro_Vocoder.Exponencial.Ruido.lc3(1,:)]; %lower quartile
% lowQ=lowQ-medians;
% 
% highQ=[St.Audio(3,:); St.Vocoder.Ruido(3,:); St.Neuro_Vocoder.Gauss.Ruido(3,:); ...
%     St.Neuro_Vocoder.Exponencial.Ruido.lc3(3,:)]; %upper quartile
% highQ=highQ-medians;
% %% plota figura
% color=['k','b','r','m'];
% SNR = {'','-5dB','0dB','5dB','10dB','INF',''}
% figure()
% hold on
% for j=1:4
%     errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),color(j),'Color',color(j),'Marker',marker(j),...
%         'MarkerSize',8,'LineWidth',1.5,'LineStyle','-','MarkerFaceColor',color(j))
% end
% xlabel('SNR(dB)')
% ylabel('Intelligibility (%)')
% legend('Unprocessed','SV','NV Gauss','NV Exp BP','Location','NorthWest')
% title('White Noise')
% ylim([0 100])
% set(gca,'XtickL',SNR)
% grid on

%% Espalhamento

St.Audio=quantile(SRMRnorm.Audio,3);
St.Neuro_Vocoder.Exponencial.Ruido.lc1=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc1,3);
St.Neuro_Vocoder.Exponencial.Ruido.lc2=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc2,3);
St.Neuro_Vocoder.Exponencial.Ruido.lc3=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3,3);
St.Neuro_Vocoder.Exponencial.Ruido.lc4=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc4,3);
St.Neuro_Vocoder.Exponencial.Ruido.lc8=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc8,3);


medians=[St.Audio(2,:); St.Neuro_Vocoder.Exponencial.Ruido.lc1(2,:); St.Neuro_Vocoder.Exponencial.Ruido.lc2(2,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(2,:); St.Neuro_Vocoder.Exponencial.Ruido.lc4(2,:); St.Neuro_Vocoder.Exponencial.Ruido.lc8(2,:)]; %median
%medians = fliplr(medians);
lowQ=[St.Audio(1,:); St.Neuro_Vocoder.Exponencial.Ruido.lc1(1,:); St.Neuro_Vocoder.Exponencial.Ruido.lc2(1,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(1,:); St.Neuro_Vocoder.Exponencial.Ruido.lc4(1,:); St.Neuro_Vocoder.Exponencial.Ruido.lc8(1,:)]; %lower quartile
%lowQ = fliplr(lowQ);
lowQ=lowQ-medians;
highQ=[St.Audio(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc1(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc2(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc4(3,:); St.Neuro_Vocoder.Exponencial.Ruido.lc8(3,:)];%upper quartile
%highQ=fliplr(highQ);
highQ=highQ-medians;
%% plota figura
color=['k','r','m','b','g','c'];
marker=['o','o','o','o','o','o'];
SNR = {'','-5','0','5','10','INF',''};
figure()
hold on
for j=1:6
    errorbar(SNR_values, medians(j,:), lowQ(j,:), highQ(j,:),'Color',color(j),'Marker',marker(j),...
        'MarkerSize',8,'LineWidth',2,'LineStyle','-','MarkerFaceColor',color(j))
end
legend('Unprocessed','1mm','2mm','3mm','4mm','8mm','Location','NorthWest')
xlabel('SNR(dB)')
ylabel('normalized SRMR')
title('White Noise')
ylim([0 1])
set(gca,'XtickL',SNR)
grid on



% SNR = {'1','2','3','4','8'}
% Esp = [SRMR_resultados.Audio(:,1) SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(:,1) SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(:,1)...
%     SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,1) SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(:,1)...
%     SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(:,1)];
% 
% boxplot(Esp)
% title('Current Spread')
% % set(gca,'XtickL',SNR)
% %grid on

%%
[lin, col] = size(SRMR_resultados.Audio);

%ref_cl=repmat(SRMR_resultados.Audio(:,1), 1,col);
SRMRnorm.Audio=1;

SRMRnorm.Vocoder.Harmonicos=SRMR_resultados.Vocoder.Harmonicos(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos=SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos=SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Vocoder.Ruido=SRMR_resultados.Vocoder.Ruido(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Gauss.Ruido=SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc1=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc2=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc4=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(:,1)./SRMR_resultados.Audio(:,1);

SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc8=SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(:,1)./SRMR_resultados.Audio(:,1);

%% calcula estatísticas
St.Audio=quantile(SRMRnorm.Audio,3)';
St.Vocoder.Harmonicos=quantile(SRMRnorm.Vocoder.Harmonicos,3)';
St.Neuro_Vocoder.Gauss.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Harmonicos,3)';
St.Neuro_Vocoder.Exponencial.Harmonicos=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Harmonicos,3)';

St.Audio=quantile(SRMRnorm.Audio,3)';
St.Vocoder.Ruido=quantile(SRMRnorm.Vocoder.Ruido,3)';
St.Neuro_Vocoder.Gauss.Ruido=quantile(SRMRnorm.Neuro_Vocoder.Gauss.Ruido,3)';
St.Neuro_Vocoder.Exponencial.Ruido.lc3=quantile(SRMRnorm.Neuro_Vocoder.Exponencial.Ruido.lc3,3)';

medians=[St.Audio(2,:); St.Vocoder.Harmonicos(2,:); St.Neuro_Vocoder.Gauss.Harmonicos(2,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(2,:)]; %median
lowQ=[St.Audio(1,:); St.Vocoder.Harmonicos(1,:); St.Neuro_Vocoder.Gauss.Harmonicos(1,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(1,:)]; %lower quartile
lowQ=lowQ-medians;

highQ=[St.Audio(3,:); St.Vocoder.Harmonicos(3,:); St.Neuro_Vocoder.Gauss.Harmonicos(3,:); ...
    St.Neuro_Vocoder.Exponencial.Harmonicos(3,:)]; %upper quartile
highQ=highQ-medians;

medians2=[St.Audio(2,:); St.Vocoder.Ruido(2,:); St.Neuro_Vocoder.Gauss.Ruido(2,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(2,:)]; %median
lowQ2=[St.Audio(1,:); St.Vocoder.Ruido(1,:); St.Neuro_Vocoder.Gauss.Ruido(1,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(1,:)]; %lower quartile
lowQ2=lowQ2-medians2;

highQ2=[St.Audio(3,:); St.Vocoder.Ruido(3,:); St.Neuro_Vocoder.Gauss.Ruido(3,:); ...
    St.Neuro_Vocoder.Exponencial.Ruido.lc3(3,:)]; %upper quartile
highQ2=highQ2-medians2;
%% plota figura
color=['k','r','m','b'];
marker=['o','o','o','o'];
SNR = {'','S-Vocoder','','N-Vocoder Gauss',' ','N-Vocoder Exp',''};
figure()
hold on
for j=2:4
    errorbar(j,medians(j), lowQ(j), highQ(j),'Color','b','Marker',marker(j),...
        'MarkerSize',10,'LineWidth',2,'LineStyle','-','MarkerFaceColor','b')
end

for j=2:4
    errorbar(j,medians2(j), lowQ2(j), highQ2(j),'Color','r','Marker','s',...
        'MarkerSize',10,'LineWidth',2,'LineStyle','-','MarkerFaceColor','r')
end
%legend('Audio','Vocoder','Neuro-vocoder Gauss','Neuro-vocoder Exponencial')
%xlabel('SNR(dB)')
ylabel('normalized SRMR (SNR=Inf)')
%legend('SV','NV Gauss','NV Exp BP','Location','NorthWest')
%title('Harmonic Complex')
ylim([0 0.8])
set(gca,'XtickL',SNR)
grid on

