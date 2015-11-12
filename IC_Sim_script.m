%% Simulação do sinal no implante coclear

clear classes
clear all
clc
addpath(genpath('./funcoes'))
addpath(genpath('./SRMRToolbox-master'))

%sim = Cprocessador('sinal16k.wav', './dados_pacientes/p_cochlear_9.dat');
sim = Cprocessador('sinal16k.wav', 'media');
sim.num_canais = 22;
sim.maxima = 22;
sim.taxa_est = 700;
sim.fcorte_fpb = 400;
sim.ordem_fpb = 4;
%sim.fat_comp = 0.6;

tic
sim.cis();
toc

sim
sim.Csinal_processador

n = 8;

figure(2)
subplot(4,1,1)
plot(sim.vet_tempo,sim.Csinal_processador.filt(n,:))
subplot(4,1,2)
plot(sim.vet_tempo,sim.Csinal_processador.env(n,:))
subplot(4,1,3)
plot(sim.vet_tempo,sim.Csinal_processador.comp(n,:))
subplot(4,1,4)
plot(sim.Csinal_processador.corr_onda(n,:,1),sim.Csinal_processador.corr_onda(n,:,2))
