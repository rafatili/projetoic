%% Simula��o do sinal no implante coclear

clear classes
clear all
clc
addpath(genpath('./funcoes'))
addpath(genpath('./SRMRToolbox-master'))

%sim = Cprocessador('sinal16k.wav', './dados_pacientes/p_cochlear_5.dat');
sim = Cprocessador('sinal16k.wav', 'media');
sim.num_canais = 22;
sim.maxima = 8;
sim.taxa_est = 1200;
sim.tipo_env = 'Hilbert';
%sim.tipo_env = 'Retificacao';
%sim.fat_comp = 0.2;

tic
sim.cis();
toc

sim

sim.Csinal_processador

n = 16;

figure(1)
subplot(4,1,1)
plot(sim.vet_tempo,sim.Csinal_processador.filt(n,:))
subplot(4,1,2)
plot(sim.vet_tempo,sim.Csinal_processador.env(n,:))
subplot(4,1,3)
plot(sim.vet_tempo,sim.Csinal_processador.comp(n,:))
subplot(4,1,4)
vn = strcat('E',num2str(sim.num_canais-n+1));
tc = sim.Csinal_processador.corr_onda.(vn);
plot(tc(:,1),tc(:,2))
%plot(sim.Csinal_processador.corr_onda(n,:,2))
xlim([0 3.5])
%% Eletrodograma

canal_min = 1;
canal_max = 22;
figure(2)
for n = canal_max:-1:canal_min
h = subplot(canal_max-canal_min+1,1,canal_max-n+1);
vn = strcat('E',num2str(n));
tc = sim.Csinal_processador.corr_onda.(vn);
plot(tc(:,1),tc(:,2))
xlim([0 max(sim.vet_tempo)])
ylim([0 sim.max_corr])
set(h,'XTick',[])
set(h,'YTick',[])
ylabel(strcat('E',num2str(canal_max-n+1)))
end




