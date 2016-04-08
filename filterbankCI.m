fs = 16e3;
numChannels = 22;
lowFreq = (313+188)/2;
bandwidths_in = [1000;875;750;625;625;500;500;375;375;250;250;250;250;125;125;125;125;125;125;125;125;125];
[fcoefs, bandwidths] = MakeCIFilters(fs,numChannels,lowFreq,bandwidths_in);

A0 = fcoefs(:,1);
A1 = [fcoefs(:,2) fcoefs(:,3) fcoefs(:,4) fcoefs(:,5)];
A2 = fcoefs(:,6);
B0 = fcoefs(:,7);
B1 = fcoefs(:,8);
B2 = fcoefs(:,9);

np = 2048;
y = CIFilterBank(fs, numChannels, lowFreq, [1 zeros(1,(np-1))], bandwidths_in);
resp = 20*log10(abs(fft(y')));
freqScale = (0:(np-1))/np*fs;
figure(1)
semilogx(freqScale(1:(np/2-1)),resp(1:(np/2-1),:),'LineWidth',1);
axis([1e2 0.8e4 -30 0])
xlabel('Frequ�ncia (Hz)','FontSize',10);
ylabel('Resposta (dB)','FontSize',10);

[TEL.audio, fs2] = audioread('televisao.wav');
TEL.audio = TEL.audio/max(abs(TEL.audio));
audioinfo('televisao.wav')
TEL.audio = resample(TEL.audio,fs,fs2);

TEL.CIfilters = CIFilterBank(fs, numChannels, lowFreq, TEL.audio, bandwidths_in);
fcorte_fpb = 400;
ordem_fpb = 4;
TEL.env.Hilbert = ext_env(TEL.CIfilters,'Hilbert',fcorte_fpb,fs,ordem_fpb);
TEL.env.Ret = ext_env(TEL.CIfilters,'Retificacao',fcorte_fpb,fs,ordem_fpb);

nc = 10;
t = 0:1/fs:(length(TEL.audio)-1)/fs;
figure(2)
plot(t,TEL.CIfilters(nc,:)')
hold on
plot(t,TEL.env.Hilbert(nc,:)','r','LineWidth',2)
plot(t,TEL.env.Ret(nc,:)','g','LineWidth',2)
hold off
xlim([0.015 0.1])
ylim([-0.1 0.1])
xlabel('Tempo (s)','FontSize',10);
ylabel('Amplitude','FontSize',10);

TEL_vocoder.HC = vocoder(TEL.env.Hilbert,fs,'Harmonic Complex',flipud(bandwidths_in),313,188,t);
TEL_vocoder.WN = vocoder(TEL.env.Hilbert,fs,'Ruido',flipud(bandwidths_in),313,188,t);

