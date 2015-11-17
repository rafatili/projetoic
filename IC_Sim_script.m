%% Simulação do sinal no implante coclear

clear classes
clear all
clc
addpath(genpath('./funcoes'))
addpath(genpath('./SRMRToolbox-master'))

%sim = Cprocessador('sinal16k.wav', './dados_pacientes/p_cochlear_5.dat');
sim = Cprocessador('sinal16k.wav', 'media');
sim.num_canais = 22;
sim.maxima = 10;
sim.taxa_est = 1000;
sim.tipo_env = 'Hilbert';
%sim.tipo_env = 'Retificacao';
%sim.fat_comp = 0.2;

tic
sim.cis_ace();
toc

sim
sim.Csinal_processador

%% Etapas dos sinais

% n = 16;
% 
% figure(1)
% subplot(4,1,1)
% plot(sim.vet_tempo,sim.Csinal_processador.filt(n,:))
% subplot(4,1,2)
% plot(sim.vet_tempo,sim.Csinal_processador.env(n,:))
% subplot(4,1,3)
% plot(sim.vet_tempo,sim.Csinal_processador.comp(n,:))
% subplot(4,1,4)
% vn = strcat('E',num2str(sim.num_canais-n+1));
% tc = sim.Csinal_processador.corr_onda.(vn);
% plot(tc(:,1),tc(:,2))
% xlim([0 3.5])

%% Eletrodograma

canal_min = 1;
canal_max = 22;
figure(2)
for n = 1:canal_max
h = subplot(canal_max-canal_min+1,1,n);
vn = strcat('E',num2str(n));
tc = sim.Csinal_processador.corr_onda.(vn);
plot(tc(:,1),tc(:,2))
xlim([0 max(sim.vet_tempo)])
ylim([0 sim.max_corr])
set(h,'XTick',[])
set(h,'YTick',[])
ylabel(strcat('E',num2str(n)))
end

%% Espectrograma FFT

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

figure(4)
level = 6;
wpt = wpdec(sim.Csinal_processador.in,level,'sym8');
[Spec,Time,Freq] = wpspectrum(wpt,sim.freq_amost);%,'plot');
surf(Time,fliplr(Freq),10*log10(abs(Spec)),'EdgeColor','none');
axis xy; 
axis tight;
%set(gca,'Yscale','log')
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% ylim([2e2 8e3])
colormap(jet);
view(0,90);

