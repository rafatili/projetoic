function [rho_env, rho_tfs] = NCC(psth1p,psth1n,psth2p,psth2n)

psth1.pos = psth1p;
psth1.neg = psth1n;
psth2.pos = psth2p;
psth2.neg = psth2n;

SOMA12 = 0;
% for i = 1:N
%    SOMA12 = SOMA12 + real(ifft(fft(psth1.pos(i,:)).*fft(conj(psth1.pos(i,:)))));
% end
rho_env = zeros(size(psth1.pos,1),size(psth1.pos,1));
rho_tfs = zeros(size(psth1.pos,1),size(psth1.pos,1));

for i = 1:size(psth1.pos,1)
    for j = 1:size(psth1.pos,1)

        SCC.AA = real(ifft(fft(psth1.pos(i,:)).*conj(fft(psth1.pos(j,:))))) - SOMA12;
        %SCC.AA = xcorr(psth1.pos(i,:),psth1.pos(j,:),'coeff');
% SOMA12 = 0;
% for i = 1:N
%    SOMA12 = SOMA12 + real(ifft(fft(psth1.pos(i,:)).*conj(fft(psth1.neg(i,:)))));
% end

%SCC.A_A = real(ifft(fft(sum(psth1.pos,1)).*fft(conj(sum(psth1.neg,1))))) - SOMA12;
        SCC.A_A = real(ifft(fft(psth1.pos(i,:)).*conj(fft(psth1.neg(j,:))))) - SOMA12;
        %SCC.A_A = xcorr(psth1.pos(i,:),psth1.neg(j,:),'coeff');
% SOMA12 = 0;
% for i = 1:N
%    SOMA12 = SOMA12 + real(ifft(fft(psth2.pos(i,:)).*conj(fft(psth2.pos(i,:)))));
% end

        SCC.BB = real(ifft(fft(psth2.pos(i,:)).*conj(fft(psth2.pos(j,:))))) - SOMA12;
        %SCC.BB = xcorr(psth2.pos(i,:),psth2.pos(j,:),'coeff');
% SOMA12 = 0;
% for i = 1:N
%    SOMA12 = SOMA12 + real(ifft(fft(psth2.pos(i,:)).*conj(fft(psth2.neg(i,:)))));
% end

        SCC.B_B = real(ifft(fft(psth2.pos(i,:)).*conj(fft(psth2.neg(j,:))))) - SOMA12;
        %SCC.B_B = xcorr(psth2.pos(i,:),psth2.neg(j,:),'coeff');

        SCC.AB = real(ifft(fft(psth1.pos(i,:)).*conj(fft(psth2.pos(j,:)))));
        %SCC.AB = xcorr(psth1.pos(i,:),psth2.pos(j,:),'coeff');
        SCC.A_B = real(ifft(fft(psth1.pos(i,:)).*conj(fft(psth2.neg(j,:)))));
        %SCC.A_B = xcorr(psth1.pos(i,:),psth2.neg(j,:),'coeff');

        difcor.ABA_B = (SCC.AB + SCC.A_B)/2;
        difcor.AAA_A = (SCC.AA + SCC.A_A)/2;
        difcor.BBB_B = (SCC.BB + SCC.B_B)/2;

        sumcor.ABA_B = (SCC.AB - SCC.A_B);
        sumcor.AAA_A = (SCC.AA - SCC.A_A);
        sumcor.BBB_B = (SCC.BB - SCC.B_B);

        rho_env(i,j) = max(sumcor.ABA_B)/sqrt(max(sumcor.AAA_A)*max(sumcor.BBB_B));
        rho_tfs(i,j) = max(difcor.ABA_B)/sqrt(max(difcor.AAA_A)*max(difcor.BBB_B));
    end
end
end