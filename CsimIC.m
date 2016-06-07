classdef CsimIC < CmodeloNA
    %CsimIC Classe para cria��o do objeto de simula��o, reconstru�ao do
    %sinal e avalia�ao objetiva dos resultados
    
    properties
        nome_sinal_reconst % nome do arquivo gerado para o sinal reconstruido
        audio_reconst % Sinal de audio reconstruido
        carrier = 'Harmonic Complex'; % Carrier (sinal portador) do vocoder: 'Ruido', 'Senoidal' e 'Harmonic Complex'
        tipo_vocoder = 'Neural'; % 'Normal' ou 'Neural'
        tipo_espec = 'Wavelet'; % Tipo de espectograma: 'Wavelet', 'FFT'
        SRMR_NH % Valor da metrica SRMR-NH
        SRMR_IC % Valor da metrica SRMR-CI
        Intel_SRMR_NH % Previsao da inteligibilidade para a metrica SRMR-NH
        Intel_SRMR_IC % Previsao da inteligibilidade para a metrica SRMR-CI
    end

    
    methods
        function objeto = CsimIC(arquivo_dat,nome_sinal_entrada) % Funcao geral da Classe           
            objeto@CmodeloNA(arquivo_dat,nome_sinal_entrada);
        end
       
        function vocoder(objeto,flag)
            switch(objeto.tipo_vocoder)
                
                case 'Normal'
                objeto.audio_reconst = vocoder(objeto.Csinal_processador.env,objeto.freq_amost,...
                objeto.carrier,objeto.bandas_freq_entrada,...
                objeto.sup_freq,objeto.inf_freq,...
                objeto.vet_tempo);
                    if flag == 1
                        nv = '_vocoder_hc.wav';
                        audiowrite(char(strcat(objeto.nome_sinal_reconst,nv)),saida,objeto.freq_amost)
                    end
                    
                case 'Neural'
                    objeto.audio_reconst = neural_vocoder(objeto.Ap,objeto.freq_amost,objeto.carrier,objeto.dtn_A,objeto.pos_eletrodo);
                    if flag == 1
                        nv = strcat('_neural_vocoder_hc','.wav');
                        audiowrite(char(strcat(objeto.nome_sinal_reconst,nv)),objeto.audio_reconst,objeto.freq_amost)
                    end
            end
        end
        
        
        function plotSpikes(objeto)
            [y,x] = find(objeto.spike_matrix);
            x = x/(2*objeto.freq_amost_pulsos);
            figure()
            plot(x,y,'.k','MarkerSize',2)
            ylim([0 max(y)])
            xlabel('Tempo(s)')
            ylabel('Neur�nio "n" (da base (0) ao �pice (N))')
            set(gca,'Ydir','reverse')
        end
        
        function plotEletrodograma(objeto)
            canal_min = 1;
            canal_max = objeto.num_canais;
            figure()
            for n = 1:canal_max
                h = subplot(objeto.num_canais-canal_min+1,1,n);
                vn = strcat('E',num2str(n));
                tc = objeto.Csinal_processador.amp_pulsos.(vn);
                stem(tc(:,1),tc(:,2),'k','Marker','none');
                ylim([0 objeto.max_corr])
                set(h,'XTick',[])
                set(h,'YTick',[])
                set(h,'FontSize',8)
                set(h,'yscale','log')
                ylabel(strcat('',num2str(n)))
                if n == canal_max
                    set(h,'XTick',0:0.1:max(objeto.vet_tempo),'TickDir','out')
                    xlim([0 max(objeto.vet_tempo)])
                    xlabel('t(s)')
                end
            suplabel('N�mero do eletrodo','y',[.125 .125 .8 .8]);
            end
            
        end
        
        function plotEspectrograma(objeto)
            switch objeto.tipo_espec               
                case 'Wavelet'
                    figure()
                    level = 6;
                    wpt = wpdec(objeto.Csinal_processador.in,level,'sym8');
                    [Spec,Time,Freq] = wpspectrum(wpt,objeto.freq_amost);
                    surf(Time,fliplr(Freq),10*log10(abs(Spec)),'EdgeColor','none');
                    set(gca,'yscale','log')
                    axis xy; 
                    axis tight;
                    colormap(jet);
                    view(0,90);
                    ylabel('f(Hz)');
                    xlabel('t(s)'); 
                    
                case 'FFT'                    
                    figure();        
                    [p,f,t] = spectrogram(objeto.Csinal_processador.in,256,120,256,objeto.freq_amost,'yaxis');
                    surf(t,f,10*log10(abs(p)),'EdgeColor','none');
                    axis xy; 
                    axis tight;
                    set(gca,'yscale','log');
                    xlim([0 0.1])
                    ylim([0 8e3])
                    colormap(jet);
                    view(0,90);
                    ylabel('f(Hz)');
                    xlabel('t(s)');                 
            end
        end
        
        function plotNeurograma(objeto)
                x_Ap = (1:size(objeto.Ap,2))*objeto.dtn_A/2;
                y_Ap = 1:size(objeto.Ap,1);
                figure()
                surface(x_Ap,y_Ap,objeto.Ap,'EdgeColor','none')
                c = colorbar;
                colormap(jet)
                ylim([1 objeto.num_canais])
                xlim([objeto.dtn_A max(x_Ap)])
                xlabel('Tempo(s)')
                ylabel('Popula��o no eletrodo "N" (da base ao �pice)')
                ylabel(c,'Taxa de disparos (spikes/s)')
                view(0, 270)
        end
        
        function plotFiltros(objeto)
             switch objeto.tipo_filtro
                 case 'Gammatone'
                    np = 2048;
                    y = cochlearFilterBank(objeto.freq_amost, objeto.num_canais,objeto.central_freq(1), [1 zeros(1,(np-1))]);
                    resp = 20*log10(abs(fft(y')));
                    freqScale = (0:(np-1))/np*objeto.freq_amost;
                    figure()
                    semilogx(freqScale(1:(np/2-1)),resp(1:(np/2-1),:),'LineWidth',1);
                    axis([1e2 0.8e4 -30 0])
                    xlabel('Frequ�ncia (Hz)','FontSize',10);
                    ylabel('Resposta (dB)','FontSize',10); 
                 
                 case 'Nucleus'
                    np = 2048;
                    y = CIFilterBank(objeto.freq_amost, objeto.num_canais,objeto.central_freq(1), [1 zeros(1,(np-1))], objeto.bandas_freq_entrada(1:objeto.num_canais));
                    resp = 20*log10(abs(fft(y')));
                    freqScale = (0:(np-1))/np*objeto.freq_amost;
                    figure()
                    semilogx(freqScale(1:(np/2-1)),resp(1:(np/2-1),:),'LineWidth',1);
                    axis([1e2 0.8e4 -30 0])
                    xlabel('Frequ�ncia (Hz)','FontSize',10);
                    ylabel('Resposta (dB)','FontSize',10);
             end
                    
        end
        
        function calcSRMR(objeto)
                objeto.SRMR_NH = SRMR(objeto.audio_reconst,objeto.freq_amost);
                objeto.SRMR_IC = SRMR_CI(objeto.audio_reconst,objeto.freq_amost);
        end
        
        
        
    end
    
end

