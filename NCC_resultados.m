clear classes
clear all
clc
addpath(genpath('./funcoes'))
addpath(genpath('./SRMRToolbox-master'))

load PSTH1pos.mat
load PSTH1neg.mat
load PSTH2pos.mat
load PSTH2neg.mat

tic
[rho_env, rho_tfs] = NCC(PSTH1pos,PSTH1neg,PSTH2pos,PSTH2neg);
toc

rho_env = abs(rho_env)./max(max(abs(rho_env)));

figure(1)
surface(1:size(rho_env,1),1:size(rho_env,1),rho_tfs);
%zlim([0 1])
view(0,90)