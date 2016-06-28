function [S_mix, N] = s_and_n(S, N, SNRdb)
%%
% Adds noise to the speech signal at a given signal to noise ratio (SNR)
% 
% S_mix = s_and_n(S, N, SNRdb)
% 
%   -S_mix is the noisy signal at the specified SNR in dB.
%   -S and N are respectively the speech and noise arrays. 

%% evaluate SNR 
P_S=norm(S,2)^2;    %sum(pwelch(S)); % signal power
P_N=norm(N,2)^2;   %sum(pwelch(N1)); % noise power

SNR_in=P_S/P_N; %SNR of the input signals

SNR=10^(SNRdb/10);

a=sqrt(SNR_in/SNR); % parameter to adjust SNR to wanted value
N=a*N;

S_mix=S+N;
