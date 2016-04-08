clear classes
clear all
clc
addpath(genpath('./funcoes'))
addpath(genpath('./SRMRToolbox-master'))

%% SRMR

% tic
% SRMR_resultados.Audio = zeros(20,2);
% SRMR_resultados.Vocoder.Filtro_IC = zeros(20,2);
% SRMR_resultados.Vocoder.Filtro_GT.dx1 = zeros(20,2);
% SRMR_resultados.Vocoder.Filtro_GT.dx075 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Exponencial.N100 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Exponencial.N500 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Exponencial.N1000 = zeros(20,2);
% SRMR_resultados.Neuro_Vocoder.Gauss.N100 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.N500 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.N1000 = zeros(20,2);
% SRMR_resultados.Neuro_Vocoder.Gauss.dtA1 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.dtA10 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.dtA100 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.tref10_50 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.tref100_500 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.tref1000_5000 = zeros(20,1);
% SRMR_resultados.Neuro_Vocoder.Gauss.dx075 = zeros(20,1);
% 
% pasta = {'./CLEAN/','./N_SNR = 10 dB/'};
% nome_arq = {'S_01_0', 'S_01_','S_02_0','S_02_','S_19_0','S_19_','S_20_0','S_20_'};
% tipo = {'.wav', '_noisy_10dB.wav', '_vocoder.wav','_vocoder_cf.wav', '_noisy_10dB_vocoder.wav', ...
%     '_noisy_10dB_vocoder_cf.wav', '_reconst_neuro_gauss.wav','_noisy_10dB_reconst_neuro_gauss.wav',...
%     '_reconst_neuro_exp.wav','_noisy_10dB_reconst_neuro_exp.wav', '_reconst_neuro_gauss_100n.wav',...
%     '_reconst_neuro_gauss_500n.wav','_reconst_neuro_exp_100n.wav','_reconst_neuro_exp_500n.wav',...
%     '_reconst_neuro_gauss_dtA_1.wav','_reconst_neuro_gauss_dtA_10.wav','_reconst_neuro_gauss_dtA_100.wav',...
%     '_reconst_neuro_gauss_tref_10_50.wav','_reconst_neuro_gauss_tref_100_500.wav',...
%     '_reconst_neuro_gauss_tref_1000_5000.wav', '_reconst_neuro_gauss_dx075.wav','_vocoder_cf_dx075.wav'};
% 
% for arq = 1:10
%     if arq ~= 10 
%         
%     [SRMR_resultados.Audio(arq,1), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(1))));
%     [SRMR_resultados.Audio(arq+10,1), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(1))));
%     [SRMR_resultados.Audio(arq,2), ~] = SRMR_CI(char(strcat(pasta(2),nome_arq(5),num2str(arq),tipo(2))));
%     [SRMR_resultados.Audio(arq+10,2), ~] = SRMR_CI(char(strcat(pasta(2),nome_arq(7),num2str(arq),tipo(2))));
%     
%     [SRMR_resultados.Vocoder.Filtro_IC(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(3))));
%     [SRMR_resultados.Vocoder.Filtro_IC(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(3))));
%     [SRMR_resultados.Vocoder.Filtro_IC(arq,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(5),num2str(arq),tipo(5))));
%     [SRMR_resultados.Vocoder.Filtro_IC(arq+10,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(7),num2str(arq),tipo(5))));
%     
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(4))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(4))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(5),num2str(arq),tipo(6))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq+10,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(7),num2str(arq),tipo(6))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(7))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(7))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(5),num2str(arq),tipo(8))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq+10,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(7),num2str(arq),tipo(8))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(9))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(9))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(5),num2str(arq),tipo(10))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq+10,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(7),num2str(arq),tipo(10))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N100(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(11))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N100(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(11))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N500(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(12))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N500(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(12))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N100(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(13))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N100(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(13))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N500(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(14))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N500(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(14))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA1(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(15))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA1(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(15))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA10(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(16))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA10(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(16))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA100(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(17))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA100(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(17))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref10_50(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(18))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref10_50(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(18))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref100_500(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(19))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref100_500(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(19))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref1000_5000(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(20))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref1000_5000(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(20))));
%        
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dx075(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(21))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dx075(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(21))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx075(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(1),num2str(arq),tipo(22))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx075(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(3),num2str(arq),tipo(22))));
% 
%     else
%     
%     [SRMR_resultados.Audio(arq,1), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(1))));
%     [SRMR_resultados.Audio(arq+10,1), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(1))));
%     [SRMR_resultados.Audio(arq,2), ~] = SRMR_CI(char(strcat(pasta(2),nome_arq(6),num2str(arq),tipo(2))));
%     [SRMR_resultados.Audio(arq+10,2), ~] = SRMR_CI(char(strcat(pasta(2),nome_arq(8),num2str(arq),tipo(2))));
%     
%     [SRMR_resultados.Vocoder.Filtro_IC(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(3))));
%     [SRMR_resultados.Vocoder.Filtro_IC(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(3))));
%     [SRMR_resultados.Vocoder.Filtro_IC(arq,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(6),num2str(arq),tipo(5))));
%     [SRMR_resultados.Vocoder.Filtro_IC(arq+10,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(8),num2str(arq),tipo(5))));
%     
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(4))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(4))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq,1), ~] = SRMR(char(strcat(pasta(2),nome_arq(6),num2str(arq),tipo(6))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx1(arq+10,1), ~] = SRMR(char(strcat(pasta(2),nome_arq(8),num2str(arq),tipo(6))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(7))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(7))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(6),num2str(arq),tipo(8))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N1000(arq+10,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(8),num2str(arq),tipo(8))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(9))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(9))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(6),num2str(arq),tipo(10))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(arq+10,2), ~] = SRMR(char(strcat(pasta(2),nome_arq(8),num2str(arq),tipo(10))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N100(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(11))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N100(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(11))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N500(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(12))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.N500(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(12))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N100(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(13))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N100(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(13))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N500(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(14))));
%     [SRMR_resultados.Neuro_Vocoder.Exponencial.N500(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(14))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA1(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(15))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA1(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(15))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA10(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(16))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA10(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(16))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA100(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(17))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dtA100(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(17))));
%     
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref10_50(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(18))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref10_50(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(18))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref100_500(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(19))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref100_500(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(19))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref1000_5000(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(20))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.tref1000_5000(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(20))));
%        
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dx075(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(21))));
%     [SRMR_resultados.Neuro_Vocoder.Gauss.dx075(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(21))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx075(arq,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(2),num2str(arq),tipo(22))));
%     [SRMR_resultados.Vocoder.Filtro_GT.dx075(arq+10,1), ~] = SRMR(char(strcat(pasta(1),nome_arq(4),num2str(arq),tipo(22))));
%         
%     end
% 
% end
% toc

%% SRMR 2

SRMR_resultados.Audio = zeros(20,5);
SRMR_resultados.Audio2 = zeros(20,5);
SRMR_resultados.Vocoder.Harmonicos = zeros(20,5);
SRMR_resultados.Vocoder.Ruido = zeros(20,5);
SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos = zeros(20,5);
SRMR_resultados.Neuro_Vocoder.Gauss.Ruido = zeros(20,5);
SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1 = zeros(20,1);
SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2 = zeros(20,1);
SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3 = zeros(20,5);
SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4 = zeros(20,1);
SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8 = zeros(20,1);
SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1 = zeros(20,1);
SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2 = zeros(20,1);
SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3 = zeros(20,5);
SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4 = zeros(20,1);
SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8 = zeros(20,1);


pasta = {'./CLEAN/','./N_SNR = 10 dB/','./N_SNR = 5 dB/','./N_SNR = 0 dB/','./N_SNR = -5 dB/'};
tipo = {'_noisy_10dB','_noisy_5dB','_noisy_0dB','_noisy_-5dB'};
nome = {'.wav', '_vocoder_hc.wav', '_vocoder.wav','_reconst_neuro_gauss_hc.wav','_reconst_neuro_gauss_ruido.wav',...
    '_reconst_neuro_exp_hc.wav','_reconst_neuro_exp_ruido_lc1.wav','_reconst_neuro_exp_ruido_lc2.wav',...
    '_reconst_neuro_exp_ruido.wav','_reconst_neuro_exp_ruido_lc4.wav','_reconst_neuro_exp_ruido_lc8.wav',...
    '_reconst_neuro_exp_hc_lc1.wav','_reconst_neuro_exp_hc_lc2.wav','_reconst_neuro_exp_hc_lc4.wav',...
    '_reconst_neuro_exp_hc_lc8.wav'};
tic
for pn = 1:5
for arq = 1:20


%arq = 1;
%sim = Cprocessador('sinal16k.wav', './dados_pacientes/p_cochlear_padrao.dat');
if arq<11
    if arq==10 
        if pn==1
        nome_arq = 'S_01_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq,num2str(arq),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(15))));
        elseif pn==2
        nome_arq = 'S_19_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        elseif pn==3
        nome_arq = 'S_21_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        elseif pn==4
        nome_arq = 'S_41_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        else
        nome_arq = 'S_39_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        end
    else
        if pn==1
        nome_arq = 'S_01_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq,num2str(arq),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),nome(15))));
        elseif pn==2
        nome_arq = 'S_19_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        elseif pn==3
        nome_arq = 'S_21_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        elseif pn==4
        nome_arq = 'S_41_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        else
        nome_arq = 'S_39_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq),tipo(pn-1),nome(15))));
        end
    end    
else
    if arq==20 
        if pn==1
        nome_arq = 'S_02_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(15))));
        elseif pn==2
        nome_arq = 'S_20_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        elseif pn==3
        nome_arq = 'S_22_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        elseif pn==4
        nome_arq = 'S_42_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        else
        nome_arq = 'S_40_';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        end
    else
        if pn==1
        nome_arq = 'S_02_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(1),nome_arq,num2str(arq-10),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),nome(15))));
        elseif pn==2
        nome_arq = 'S_20_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        elseif pn==3
        nome_arq = 'S_22_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        elseif pn==4
        nome_arq = 'S_42_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        else
        nome_arq = 'S_40_0';
        [SRMR_resultados.Audio(arq,pn), ~] = SRMR_CI(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Audio2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(1))));
        [SRMR_resultados.Vocoder.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(2))));
        [SRMR_resultados.Vocoder.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(3))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(4))));
        [SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(5))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(6))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(7))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(8))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(9))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(10))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(11))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc1(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(12))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc2(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(13))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc4(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(14))));
        [SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos.lc8(arq,pn), ~] = SRMR(char(strcat(pasta(pn),nome_arq,num2str(arq-10),tipo(pn-1),nome(15))));
        end
    end  
end
end
end
toc

% SRMR_resultados.Audio(20,1)=SRMR_resultados.Audio(30,1);
% SRMR_resultados.Audio=SRMR_resultados.Audio(1:20,1:5);
% 
% SRMR_resultados.Vocoder(20,1)=SRMR_resultados.Vocoder(30,1);
% SRMR_resultados.Vocoder=SRMR_resultados.Vocoder(1:20,1:5);

%% 
Inteligibilidade_resultados.Audio = [srmr2intel2(mean(SRMR_resultados.Audio(:,1)),mean(SRMR_resultados.Audio(:,1)),1)...
    srmr2intel2(mean(SRMR_resultados.Audio(:,2)),mean(SRMR_resultados.Audio(:,1)),1)...
    srmr2intel2(mean(SRMR_resultados.Audio(:,3)),mean(SRMR_resultados.Audio(:,1)),1)...
    srmr2intel2(mean(SRMR_resultados.Audio(:,4)),mean(SRMR_resultados.Audio(:,1)),1)...
    srmr2intel2(mean(SRMR_resultados.Audio(:,5)),mean(SRMR_resultados.Audio(:,1)),1)];

Inteligibilidade_resultados.Vocoder.Harmonicos = [srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,3)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,4)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Harmonicos(:,5)),mean(SRMR_resultados.Audio(:,1)),0)];

Inteligibilidade_resultados.Vocoder.Ruido = [srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,3)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,4)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Vocoder.Ruido(:,5)),mean(SRMR_resultados.Audio(:,1)),0)];

Inteligibilidade_resultados.Neuro_Vocoder.Gauss.Harmonicos = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,3)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,4)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Harmonicos(:,5)),mean(SRMR_resultados.Audio(:,1)),0)];

Inteligibilidade_resultados.Neuro_Vocoder.Gauss.Ruido = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,3)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,4)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.Ruido(:,5)),mean(SRMR_resultados.Audio(:,1)),0)];

Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Harmonicos = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos(:,3)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos(:,4)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Harmonicos(:,5)),mean(SRMR_resultados.Audio(:,1)),0)];

Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1 = srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(:,1)),mean(SRMR_resultados.Audio(:,1)),0);

Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2 = srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc2(:,1)),mean(SRMR_resultados.Audio(:,1)),0);

Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3 = [srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc1(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,3)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,4)),mean(SRMR_resultados.Audio(:,1)),0)...
    srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc3(:,5)),mean(SRMR_resultados.Audio(:,1)),0)];

Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4 = srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc4(:,1)),mean(SRMR_resultados.Audio(:,1)),0);

Inteligibilidade_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8 = srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.Ruido.lc8(:,1)),mean(SRMR_resultados.Audio(:,1)),0);

SNR_label = {'inf' '10dB' '5dB' '0dB' '-5B'};
SNR_values = [15 10 5 0 -5];

%% PLOT

% load SRMR_Intel.mat
% 
% figure(1)
% plot(SNR_values,Inteligibilidade_resultados.Audio,'-ok')
% hold on
% plot(SNR_values,Inteligibilidade_resultados.Vocoder,'-ob')
% plot(SNR_values,Inteligibilidade_resultados.Neuro_Vocoder.Gauss,'-or')
% plot(SNR_values,Inteligibilidade_resultados.Neuro_Vocoder.Exponencial,'-og')
% hold off
% legend('Audio','Vocoder','Neuro-vocoder Gauss','Neuro-vocoder Exponencial')
% xlim([-5 15])
% ylim([0 100])



%% Figuras
% close all
% %load SRMR_resultados.mat
% 
% figure(1)
% subplot(1,2,1)
% legenda = {'Sinal Limpo', 'Vocoder IC', 'Vocoder GT', 'N-vocoder Gauss', 'N-vocoder Exp'};
% boxplot([SRMR_resultados.Audio(:,1) SRMR_resultados.Vocoder.Filtro_IC(:,1) SRMR_resultados.Vocoder.Filtro_GT.dx1(:,1)...
%     SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1) SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(:,1)],legenda)
% title('SRMR Limpo')
% ylabel('SRMR(SRMR IC)')
% subplot(1,2,2)
% SII = [srmr2intel2(mean(SRMR_resultados.Audio(:,1)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Filtro_IC(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Filtro_GT.dx1(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(:,1)),mean(SRMR_resultados.Audio(:,1)),0)];
% bar(SII)
% set(gca,'XTickLabel',legenda)
% title('Inteligibilidade')
% ylabel('SII(%)')
% ylim([0 100])
% grid on
% 
% figure(2)
% subplot(1,2,1)
% legenda = {'Sinal Limpo', 'Gauss 100N', 'Exp 100N', 'Gauss 500N', 'Exp 500N', 'Gauss 1000N', 'Exp 1000N'};
% boxplot([SRMR_resultados.Audio(:,1) SRMR_resultados.Neuro_Vocoder.Gauss.N100 SRMR_resultados.Neuro_Vocoder.Exponencial.N100...
%     SRMR_resultados.Neuro_Vocoder.Gauss.N500 SRMR_resultados.Neuro_Vocoder.Exponencial.N500...
%     SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1) SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(:,1)],legenda)
% title('Número de Neurônios / Espalhamento')
% ylabel('SRMR(SRMR IC)')
% subplot(1,2,2)
% SII = [srmr2intel2(mean(SRMR_resultados.Audio(:,1)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N100),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.N100),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N500),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.N500),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(:,1)),mean(SRMR_resultados.Audio(:,1)),0)];
% bar(SII)
% set(gca,'XTickLabel',legenda)
% title('Inteligibilidade')
% ylabel('SII(%)')
% ylim([0 100])
% grid on
% 
% figure(3)
% subplot(1,2,1)
% legenda = {'Sinal Limpo', 'tref 1e-6', 'tref 10e-6', 'tref 100e-6', 'tref 1000e-6'};
% boxplot([SRMR_resultados.Audio(:,1) SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1)  SRMR_resultados.Neuro_Vocoder.Gauss.tref10_50... 
%    SRMR_resultados.Neuro_Vocoder.Gauss.tref100_500 SRMR_resultados.Neuro_Vocoder.Gauss.tref1000_5000],legenda)
% title('Período refratário / Gauss')
% ylabel('SRMR(SRMR IC)')
% subplot(1,2,2)
% SII = [srmr2intel2(mean(SRMR_resultados.Audio(:,1)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.tref10_50),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.tref100_500),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.tref1000_5000),mean(SRMR_resultados.Audio(:,1)),0)];
% bar(SII)
% set(gca,'XTickLabel',legenda)
% title('Inteligibilidade')
% ylabel('SII(%)')
% ylim([0 100])
% grid on
% 
% figure(4)
% subplot(1,2,1)
% legenda = {'Sinal Limpo', 'dt=1ms', 'dt=10ms', 'dt=35ms', 'dt=100ms'};
% boxplot([SRMR_resultados.Audio(:,1) SRMR_resultados.Neuro_Vocoder.Gauss.dtA1 SRMR_resultados.Neuro_Vocoder.Gauss.dtA10...
%      SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1) SRMR_resultados.Neuro_Vocoder.Gauss.dtA100],legenda)    
% title('Intervalo de soma de spikes / Gauss')
% ylabel('SRMR(SRMR IC)')
% subplot(1,2,2)
% SII = [srmr2intel2(mean(SRMR_resultados.Audio(:,1)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.dtA1),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.dtA10),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.dtA100),mean(SRMR_resultados.Audio(:,1)),0)];
% bar(SII)
% set(gca,'XTickLabel',legenda)
% title('Inteligibilidade')
% ylabel('SII(%)')
% ylim([0 100])
% grid on
% 
% figure(5)
% subplot(1,2,1)
% legenda = {'Sinal Limpo', 'Vocoder dx=1mm', 'Vocoder dx=0.75mm', 'N-vocoder dx=1mm', 'N-vocoder dx=0.75mm'};
% boxplot([SRMR_resultados.Audio(:,1) SRMR_resultados.Vocoder.Filtro_GT.dx1(:,1) SRMR_resultados.Vocoder.Filtro_GT.dx075...
%      SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1) SRMR_resultados.Neuro_Vocoder.Gauss.dx075],legenda)    
% title('Posição Eletrodo / GT / Gauss')
% ylabel('SRMR(SRMR IC)')
% subplot(1,2,2)
% SII = [srmr2intel2(mean(SRMR_resultados.Audio(:,1)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Filtro_GT.dx1(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Filtro_GT.dx075),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,1)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.dx075),mean(SRMR_resultados.Audio(:,1)),0)];
% bar(SII)
% set(gca,'XTickLabel',legenda)
% title('Inteligibilidade')
% ylabel('SII(%)')
% ylim([0 100])
% grid on
% 
% figure(6)
% subplot(1,2,1)
% legenda = {'Sinal Limpo', 'Vocoder IC', 'Vocoder GT', 'N-vocoder Gauss', 'N-vocoder Exp'};
% boxplot([SRMR_resultados.Audio(:,2) SRMR_resultados.Vocoder.Filtro_IC(:,2) SRMR_resultados.Vocoder.Filtro_GT.dx1(:,2)...
%     SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,2) SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(:,2)],legenda)
% title('SRMR Ruido 10dB')
% ylabel('SRMR(SRMR IC)')
% subplot(1,2,2)
% SII = [srmr2intel2(mean(SRMR_resultados.Audio(:,2)),mean(SRMR_resultados.Audio(:,1)),1)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Filtro_IC(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Vocoder.Filtro_GT.dx1(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Gauss.N1000(:,2)),mean(SRMR_resultados.Audio(:,1)),0)...
%     srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder.Exponencial.N1000(:,2)),mean(SRMR_resultados.Audio(:,1)),0)];
% bar(SII)
% set(gca,'XTickLabel',legenda)
% title('Inteligibilidade')
% ylabel('SII(%)')
% ylim([0 100])
% grid on
% 



%SI = [srmr2intel2(mean(SRMR_resultados.Limpo),mean(SRMR_resultados.Limpo),1) srmr2intel2(mean(SRMR_resultados.Vocoder),mean(SRMR_resultados.Limpo),0) srmr2intel2(mean(SRMR_resultados.Neuro_Vocoder),mean(SRMR_resultados.Limpo),0)];

%SRMR_2 = [SRMR_frases(:,1)./SRMR_frases(:,4) SRMR_frases(:,2)./SRMR_frases(:,5) SRMR_frases(:,3)./SRMR_frases(:,6)];
