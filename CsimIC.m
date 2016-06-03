classdef CsimIC < CmodeloNA
    %CRECONST Classe de objetoetos que armazenam os dados, testa modelos e
    %reconstroi o sinal
    
    properties
        Csinal_processador % Classe com sinais para cada etapa do processador
        tipo_pulso = 'Bifasico' % Formato de pulso eletrico
        max_corr = 1.75e-3 % Maxima corrente do gerador
        nome_reconst
        audio_reconst
        carrier = 'Harmonic Complex'; % carrier do vocoder: 'Ruido', 'Senoidal' e 'Harmonic Complex'
        tipo_vocoder = 'Neural'; % 'Normal' ou 'Neural'
    end
    properties(Dependent)
        freq2;          % Frequencia de amostragem das ondas de corrente
    end
    
    methods
        function objeto = CsimIC(arquivo_dat,nome) % Funcao geral da Classe           
            objeto@CmodeloNA(arquivo_dat,nome);
        end
        
        function f2 = get.freq2(objeto)
            f2 = objeto.NF*objeto.freq_amost;
        end
           
        
        function vocoder(objeto,flag)
            switch(objeto.tipo_vocoder)
                
                case 'Normal'
                objeto.audio_reconst = vocoder(objeto.Csinal_processador.env,objeto.freq_amost,...
                objeto.carrier,Cpaciente(objeto.paciente).bandas_freq_entrada,...
                Cpaciente(objeto.paciente).sup_freq,Cpaciente(objeto.paciente).inf_freq,...
                objeto.vet_tempo);
                    if flag == 1
                        nv = '_vocoder_hc.wav';
                        audiowrite(char(strcat(objeto.nome_reconst,nv)),saida,objeto.freq_amost)
                    end
                    
                case 'Neural'
                    objeto.audio_reconst = neural_vocoder(objeto.Ap,objeto.freq_amost,objeto.carrier,objeto.dtn_A,objeto.pos_eletrodo);
                    if flag == 1
                        nv = strcat('_neural_vocoder_hc','.wav');
                        audiowrite(char(strcat(objeto.nome_reconst,nv)),objeto.audio_reconst,objeto.freq_amost)
                    end
            end
        end
        
        
        function plotSpikes(objeto)
            [y,x] = find(objeto.Spike_matrix);
            x = x/(2*objeto.freq2);
            figure()
            plot(x,y,'.k','MarkerSize',2)
            ylim([0 max(y)])
            xlabel('Tempo(s)')
            ylabel('Neurônio "n" (da base (0) ao ápice (N))')
            set(gca,'Ydir','reverse')
        end
        
        function plotEletrodograma(objeto)
            canal_min = 1;
            canal_max = objeto.num_canais;
            figure()
            for n = 1:canal_max
                h = subplot(objeto.num_canais-canal_min+1,1,n);
                vn = strcat('E',num2str(n));
                tc = objeto.Csinal_processador.corr_onda.(vn);
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
            suplabel('Número do eletrodo','y',[.125 .125 .8 .8]);
            end
            
        end
        
        function plotEspectrograma(objeto,tipoEspec)
            switch tipoEspec               
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
                    [~, f, t, p] = spectrogram(objeto.Csinal_processador.in,128,120,128,objeto.freq_amost,'yaxis');
                    figure();        
                    surf(t,f,10*log10(abs(p)),'EdgeColor','none');
                    axis xy; 
                    axis tight;
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
                ylim([1 22])
                xlim([objeto.dtn_A max(x_Ap)])
                xlabel('Tempo(s)')
                ylabel('População no eletrodo "N" (da base ao ápice)')
                ylabel(c,'Taxa de disparos (spikes/s)')
                view(0, 270)
                %set(gca,'Ydir','reverse')
        end
        
    end
    
end

