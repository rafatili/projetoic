%% Simulacao do sinal no implante coclear

clear classes
clear all
clc
addpath(genpath('./funcoes'))
addpath(genpath('./SRMRToolbox-master'))

nome_in = 'televisao';    
%nome_in = 'SENO_1kHz.wav';
sim = Cprocessador(strcat(nome_in,'.wav'), './dados_pacientes/p_cochlear_padrao.dat');
sim.nome_reconst = nome_in;
%sim.nome_reconst = strcat(nome_in);
sim.num_canais = 22;
sim.maxima = 10;
sim.taxa_est = 900;
sim.tipo_env = 'Hilbert';
%sim.tipo_env = 'Retificacao';
%sim.fat_comp = 0.6;

tic
sim.cis_ace();
toc
%%
sim.tipo_vocoder = 'Harmonic Complex';
%sim.vocoder(1);
data = Cdados(sim);
%sim.lambda = lc(il);
sim.corr_esp = 'Gauss';
sim.fat_smooth = 10;
data.NF = 15;
sim.dtn_A = 35e-4;
sim.neural_vocoder(data.calcOndas(),data.freq2,1);

%% Plot
close all
% [y,x] = find(sim.Spike_matrix);
% x = x/data.freq2;
% figure(1)
% plot(x,y,'.k','MarkerSize',2)
% xlim([0.249 0.251])
% ylim([0 1000])
% xlabel('Tempo(s)')
% ylabel('Neurônio "n" (da base ao ápice)')
% %set(gca,'Ydir','reverse')

% Pulsos = data.calcOndas();
% figure(2)
% plot(Pulsos(1,:))
% hold on
% plot(Pulsos(22,:),'r')
% hold off
% figure(2)
% plot(sim.CorrDist(:,1000:20000))
% 
% 
% 

%% AP
x_Ap = (1:size(sim.Ap,2))*sim.dtn_A;
y_Ap = 1:size(sim.Ap,1);
figure(3);
subplot(2,1,1)
surface(x_Ap,y_Ap,sim.Ap,'EdgeColor','none')
colormap(jet)
%zlim([0 1500])
view(0, 270)
%set(gca,'Ydir','reverse')
nc = 10;
lt = 0.25;
A = sim.Ap(nc,:)';
% for j=1:length(A)
%     if A(j)>=lt && A(j)<1                                         
%     A(j) = (-log(1./A(j) - 1) + 1)/6 + .01644;
%     %audio(i,j) = audio(i,j)^(1/0.6);
%     elseif A(j)<lt
%     A(j) = 0; 
%     else
%     A(j) = 1; 
%     end
% end
A = A/max(A);
subplot(2,1,2)
plot(x_Ap,A)
hold on
plot(sim.vet_tempo,sim.Csinal_processador.env(nc,:)/max(sim.Csinal_processador.env(nc,:)),'r')
hold off
%%
% [y, f, t, p] = spectrogram(sim.Csinal_processador.in,128,120,128,sim.freq_amost,'yaxis');
% figure(4);
% surf(t,f,10*log10(abs(p)),'EdgeColor','none');
% axis xy; 
% axis tight;
% %set(gca,'Yscale','log')
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% ylim([2e2 8e3])
% colormap(jet);
% view(0,90);
% % ylabel('Frequency (Hz) ');
% % xlabel('Time ');

%end



%% Reconstrucao Nervo Auditivo
%freq2 = 32e3;
% [CorrDist,Spike_matrix,~,Ap] = reconst_neuro(PulsosCorr,sim.num_canais,data.freq2);
% 
% [y,x] = find(Spike_matrix);
% x = x/data.freq2;
% figure(1)
% plot(x,y,'.k','MarkerSize',2)
% xlim([0 3.5])
% ylim([0 max(y)])
% set(gca,'Ydir','reverse')
% figure(2)
% plot(Ap(20,:))
% 
% x_Ap = (1:size(Ap,2))*35e-3;
% y_Ap = 1:size(Ap,1);
% figure(3);
% surface(x_Ap,y_Ap,Ap,'EdgeColor','none')
% colormap(jet)
% zlim([0 200])
% view(0, 270)

%% Etapas dos sinais

% n = 1;
% 
% figure(1)
% subplot(4,1,1)
% plot(sim.vet_tempo,sim.Csinal_processador.filt(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,2)
% plot(sim.vet_tempo,sim.Csinal_processador.env(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,3)
% plot(sim.vet_tempo,sim.Csinal_processador.comp(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,4)
% vn = strcat('E',num2str(n));
% tc = sim.Csinal_processador.corr_onda.(vn);
% plot(tc(:,1),tc(:,2))
% xlim([0 max(sim.vet_tempo)])
% 
% n = 8;
% 
% figure(2)
% subplot(4,1,1)
% plot(sim.vet_tempo,sim.Csinal_processador.filt(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,2)
% plot(sim.vet_tempo,sim.Csinal_processador.env(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,3)
% plot(sim.vet_tempo,sim.Csinal_processador.comp(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,4)
% vn = strcat('E',num2str(n));
% tc = sim.Csinal_processador.corr_onda.(vn);
% plot(tc(:,1),tc(:,2))
% xlim([0 max(sim.vet_tempo)])
% 
% n = 16;
% 
% figure(3)
% subplot(4,1,1)
% plot(sim.vet_tempo,sim.Csinal_processador.filt(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,2)
% plot(sim.vet_tempo,sim.Csinal_processador.env(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,3)
% plot(sim.vet_tempo,sim.Csinal_processador.comp(n,:))
% xlim([0 max(sim.vet_tempo)])
% subplot(4,1,4)
% vn = strcat('E',num2str(n));
% tc = sim.Csinal_processador.corr_onda.(vn);
% plot(tc(:,1),tc(:,2))
% xlim([0 max(sim.vet_tempo)])
% 

%% Eletrodograma
% 
% canal_min = 1;
% canal_max = 22;
% figure(4)
% for n = 1:canal_max
% h = subplot(canal_max-canal_min+1,1,n);
% vn = strcat('E',num2str(n));
% tc = sim.Csinal_processador.corr_onda.(vn);
% bar(tc(:,1),tc(:,2))
% xlim([0 max(sim.vet_tempo)])
% ylim([0 sim.max_corr])
% set(h,'XTick',[])
% set(h,'YTick',[])
% ylabel(strcat('E',num2str(n)))
% end
% 
% Espectrograma FFT

% [y, f, t, p] = spectrogram(sim.Csinal_processador.in,128,120,128,sim.freq_amost,'yaxis');
% figure(3);
% surf(t,f,10*log10(abs(p)),'EdgeColor','none');
% axis xy; 
% axis tight;
% %set(gca,'Yscale','log')
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% ylim([2e2 8e3])
% colormap(jet);
% view(0,90);
% % ylabel('Frequency (Hz) ');
% % xlabel('Time ');

%% Espectrograma Wavelet
% 
% figure(5)
% level = 6;
% wpt = wpdec(sim.Csinal_processador.in,level,'sym8');
% [Spec,Time,Freq] = wpspectrum(wpt,sim.freq_amost);%,'plot');
% surf(Time,fliplr(Freq),10*log10(abs(Spec)),'EdgeColor','none');
% axis xy; 
% axis tight;
% %set(gca,'Yscale','log')
% % set(gca,'XTick',[])
% % set(gca,'YTick',[])
% % ylim([2e2 8e3])
% colormap(jet);
% view(0,90);


% [y, f, t, p] = spectrogram(audio_reconst,128,120,128,data.freq2,'yaxis');
% figure(3);
% surf(t,f,p,'EdgeColor','none');
% axis xy; 
% axis tight;
% %set(gca,'Yscale','log')
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% ylim([2e2 8e3])
% zlim([0 1e-4])
% colormap(jet);
% view(0,90);
% ylabel('Frequency (Hz) ');
% xlabel('Time ');

