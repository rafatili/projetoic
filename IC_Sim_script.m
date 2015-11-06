%% Simulação do sinal no implante coclear

clear classes
clear all
clc

sim = Cprocessador('sinal16k.wav','./dados_pacientes/p1.dat');
sim.taxa_est = 1000;

sim.openwav();
tic
sim.cis();
toc
sim
sim.Csinal_processador
