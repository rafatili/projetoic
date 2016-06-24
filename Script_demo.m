clear all
clc
close all

addpath(genpath('./projetoic'))
Iniciar_SimIC

% objeto criado: "sim"
sim = CsimIC('p_cochlear_1.dat','chão_16k.wav'); 

% selecao de alguns parametros
sim.num_canais = 22; 
sim.maxima = 10;
sim.taxa_est = 800;

% processamento do implante
sim.cis_ace();

% resposta do nervo auditivo
sim.N_neurons = 100;
sim.calcOndas();
sim.LIF();

% plot dos resultados
sim.plotEletrodograma();
sim.plotSpikes();
sim.plotNeurograma();

% vocoder
sim.carrier = 'Senoidal';
sim.tipo_vocoder = 'Neural';
sim.vocoder(1);