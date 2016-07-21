classdef CsimIC < CmodeloNA
    %% CsimIC Classe para criacao do objeto de simulacao, reconstrucao do
    % sinal e avaliacao objetiva dos resultados
    
    properties
        nome_sinal_reconst % Nome do arquivo gerado para o sinal reconstruido
        audio_reconst % Sinal de audio reconstruido
        carrier = 1; % Carrier (sinal portador) do vocoder: 0 - Ruido / 1 - Senoidal / 2 - HC
        numhar_HC = 240; % Numero de harmonicos no complexo
        df_HC = 100; % Discretizacao do complexo harmonico
        F0_HC = 100; % Frequencia fundamental do complexo harmonico
        tipo_vocoder = 1; % 0 - Tradicional / 1 - Neural
        tipo_espec = 0; % Tipo de espectograma: 0 - Wavelet / - FFT
        tipo_spike_matrix = 0; % Tipo de matriz de disparos: 0 - LIF (Modelo eletrico) / 1 - Zilany (Modelo acustico)
        SRMR_NH % Valor da metrica SRMR-NH
        SRMR_IC % Valor da metrica SRMR-CI
        SRMR_clean_NH % Valor da metrica SRMR-NH para o sinal limpo
        SRMR_clean_IC % Valor da metrica SRMR-CI para o sinal limpo
        Intel_SRMR_NH % Previsao da inteligibilidade para a metrica SRMR-NH
        Intel_SRMR_IC % Previsao da inteligibilidade para a metrica SRMR-CI
    end

    
    methods
        function obj = CsimIC(arquivo_dat,varargin) % Funcao geral da Classe
            % varargin = {arquivo .wav de audio alvo, arquivo .wav do ruido, SNRdB}
            obj@CmodeloNA(arquivo_dat,varargin{:});
        end
       
        function vocoder(obj,flag) % Reconstrucao atraves do vocoder: Tradicional ou Neural
            if (max(obj.ERB_cf) + max(obj.ERB_bandas)/2)*2 > obj.freq_amost
                display('A condicao (max(obj.ERB_cf) + max(obj.ERB_bandas)/2)*2 <= obj.freq_amost deve ser seguida');
                error('Frequencia de amostragem baixa para os filtros de alta frequencia!!!');             
            else
                
            switch(obj.tipo_vocoder)
                
                case 0 % Tradicional
                obj.audio_reconst.Tradicional = vocoder(obj.Csinal_processador.env,obj.freq_amost,...
                obj.carrier, obj.baixa_freq, obj.vet_tempo,...
                obj.F0_HC,obj.df_HC,obj.numhar_HC);
                    if flag == 1
                        obj.nome_sinal_reconst = obj.arqX(1:(size(obj.arqX,2)-4));
                        nv = strcat('_Vocoder_',obj.carrier,'.wav');
                        audiowrite(char(strcat(obj.nome_sinal_reconst,nv)),obj.audio_reconst.Tradicional,obj.freq_amost);
                    end
                    
                case 1 % Neural
                    obj.audio_reconst.Neural = neural_vocoder(obj.Ap,obj.freq_amost,obj.carrier,obj.dtn_A,obj.pos_eletrodo,...
                    obj.baixa_freq, obj.F0_HC, obj.df_HC, obj.numhar_HC);
                    if flag == 1
                        obj.nome_sinal_reconst = obj.arqX(1:(size(obj.arqX,2)-4));
                        nv = strcat('_Neural_Vocoder_',obj.carrier,'.wav');
                        audiowrite(char(strcat(obj.nome_sinal_reconst,nv)),obj.audio_reconst.Neural,obj.freq_amost);
                    end
                otherwise
                    error('Somente as seguintes opcoes: 0 - Tradicional / 1 - Neural');
            end
            
            end
        end
        
        
        function plotSpikes(obj) % Plota a matriz de disparos obtida com o modelo do NA
            switch(obj.tipo_spike_matrix)
                case 0 % LIF
                    [y,x] = find(obj.spike_matrix);
                    x = x/(2*obj.freq_amost_pulsos);
                
                case 1 % Zilany
                    [y,x] = find(obj.spike_matrix_Zilany);
                    x = x/(1e5);
                otherwise
                    error('Somente as seguintes opcoes: 0 - LIF / 1 - Zilany');
            end
            
            figure()
            plot(x,y,'.k','MarkerSize',2)
            %ylim([0 max(y)])
            xlabel('Tempo(s)')
            ylabel('Neuronio "n" (da base (0) ao apice (N))')
            set(gca,'Ydir','reverse')          
        end
        
        function plotEletrodograma(obj) % Plota o eletrodograma com a serie de pulsos
            canal_min = 1;
            canal_max = obj.num_canais;
            figure()
            for n = 1:canal_max
                h = subplot(obj.num_canais-canal_min+1,1,n);
                vn = strcat('E',num2str(n));
                tc = obj.Csinal_processador.amp_pulsos.(vn);
                stem(tc(:,1),tc(:,2),'k','Marker','none');
                ylim([0 obj.max_corr])
                set(h,'XTick',[])
                set(h,'YTick',[])
                set(h,'FontSize',8)
                set(h,'yscale','log')
                ylabel(strcat('',num2str(n)))
                if n == canal_max
                    set(h,'XTick',0:0.1:max(obj.vet_tempo),'TickDir','out')
                    xlim([0 max(obj.vet_tempo)])
                    xlabel('t(s)')
                end
            suplabel('Numero do eletrodo','y',[.125 .125 .8 .8]);
            end
            
        end
        
        function plotEspectrograma(obj) % Plota o espectrograma do sinal de entrada
            switch obj.tipo_espec               
                case 0 % Wavelet
                    figure()
                    level = 6;
                    wpt = wpdec(obj.Csinal_processador.in,level,'sym8');
                    [Spec,Time,Freq] = wpspectrum(wpt,obj.freq_amost);
                    surf(Time,fliplr(Freq),10*log10(abs(Spec)),'EdgeColor','none');
                    set(gca,'yscale','log')
                    axis xy; 
                    axis tight;
                    colormap(jet);
                    view(0,90);
                    ylabel('f(Hz)');
                    xlabel('t(s)'); 
                    
                case 1 % FFT                    
                    figure();        
                    [p,f,t] = spectrogram(obj.Csinal_processador.in,256,120,256,obj.freq_amost,'yaxis');
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
                otherwise
                    error('Somente as seguintes opcoes: 0 - Wavelet / 1 - FFT');
            end
        end
        
        function plotNeurograma(obj) % Plota o neurograma obtido com o modelo do NA
                x_Ap = (1:size(obj.Ap,2))*obj.dtn_A/2;
                y_Ap = 1:size(obj.Ap,1);
                figure()
                surface(x_Ap,y_Ap,obj.Ap,'EdgeColor','none')
                c = colorbar;
                colormap(jet)
                ylim([1 obj.num_canais])
                xlim([obj.dtn_A max(x_Ap)])
                xlabel('Tempo(s)')
                ylabel('Populacao no eletrodo "N" (da base ao apice)')
                ylabel(c,'Taxa de disparos (spikes/s)')
                view(0, 270)
        end
        
        function plotFiltros(obj) % Plota o banco de filtros utilizado
             switch obj.tipo_filtro
                 case 0 % ERB
                    np = 2048;
                    y = cochlearFilterBank(obj.freq_amost, obj.num_canais,obj.central_freq(1), [1 zeros(1,(np-1))]);
                    resp = 20*log10(abs(fft(y')));
                    freqScale = (0:(np-1))/np*obj.freq_amost;
                    figure()
                    semilogx(freqScale(1:(np/2-1)),resp(1:(np/2-1),:),'LineWidth',1);
                    axis([1e2 0.8e4 -80 0])
                    xlabel('Frequencia (Hz)','FontSize',10);
                    ylabel('Resposta (dB)','FontSize',10); 
                 
                 case 1 % Nucleus
                    np = 2048;
                    y = CIFilterBank(obj.freq_amost, obj.num_canais,obj.central_freq(1), [1 zeros(1,(np-1))]);
                    resp = 20*log10(abs(fft(y')));
                    freqScale = (0:(np-1))/np*obj.freq_amost;
                    figure()
                    semilogx(freqScale(1:(np/2-1)),resp(1:(np/2-1),:),'LineWidth',1);
                    axis([1e2 0.8e4 -80 0])
                    xlabel('Frequencia (Hz)','FontSize',10);
                    ylabel('Resposta (dB)','FontSize',10);
                 otherwise
                    error('Somente as seguintes opcoes: 0 - ERB / 1 - Nucleus');
             end
                    
        end
        
        function calcSRMR(obj) % Calcula os valores de SRMR-NH e SRMR-CI
                obj.SRMR_NH = SRMR(obj.audio_reconst, obj.freq_amost);
                obj.SRMR_IC = SRMR_CI(obj.Csinal_processador.in, obj.freq_amost);
                obj.SRMR_clean_NH = SRMR(obj.Csinal_processador.in, obj.freq_amost);
                obj.SRMR_clean_IC = SRMR_CI(obj.Csinal_processador.in, obj.freq_amost);
                obj.Intel_SRMR_NH  = srmr2intel(obj.SRMR_NH, obj.SRMR_clean_NH, 0);
                obj.Intel_SRMR_IC  = srmr2intel(obj.SRMR_IC, obj.SRMR_clean_IC, 1);                
        end
        
        
        
    end
    
end

