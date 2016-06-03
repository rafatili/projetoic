classdef Creconst < Cpaciente
    %CRECONST Classe de objetoetos que armazenam os dados, testa modelos e
    %reconstroi o sinal
    
    properties
        Csinal_processador % Classe com sinais para cada etapa do processador
        tipo_pulso = 'Bifasico' % Formato de pulso eletrico
        max_corr = 1.75e-3 % Maxima corrente do gerador
        NF = 15;        % Discretiza��o da nova freq amost
        nome_reconst
        CorrDist        % Distribui��o de corrente
        Spike_matrix    % Matriz de spikes
        V_mem           % Potencial de membrana ao longo do tempo
        Ap              % Somat�rio de spikes ao longo do tempo
        lambda = 3;     % Monopolar 8-11mm / Bipolar 2-4mm
        dtn_A = 35e-3;  % Discretiza��o para o somat�rio de spikes
        N_neurons = 1000; % numero total de neuronios
        R_mem = [1900e6 2000e6]; % resistencia do neuronio [Ohms] | Distribuicao normal entre 1900MOhm e 2000MOhm como 99.7% do intervalo de confianca
        C_mem = [0.07e-12 0.5e-12]; % capacitancia [F] | Distribuicao normal entre 0.07pF e 0.5pF como 99.7% do intervalo de confianca
        dt_refrat_abs = [1e-6 330e-6]; % % periodo refratario absoluto [s] | Distribuicao normal entre 1us e 300us
        V_thr_mem = [-50e-3 -36e-3]; % potencial limiar [V] | Distribuicao normal entre -50mV e -36mV
        V_rest_mem = [-80e-3 -55e-3]; % potencial de membrana estacionario [V] | Distribuicao normal entre -80mV e -55mV
        V_ruido_mem = [-2e-3 2e-3];       % potencial de ruido [V] | Distribuicao normal entre -2mV e 2mV
        corr_esp = 'Gauss'; % 'Exp' ou 'Gauss'
        pos_inicial = 0; % posi��o inicial do arrranjo de eletrodos inserido na c�clea [mm]
        dx_eletrodo = 1; % dist�ncia entre eletrodos [mm]
        R_canal = 5e3; % imped�ncia dos canais do implante [Ohm]
        audio_reconst
        carrier = 'Harmonic Complex'; % carrier do vocoder: 'Ruido', 'Senoidal' e 'Harmonic Complex'
        ondas
        tempo
    end
    properties(Dependent)
        freq2;          % Frequencia de amostragem das ondas de corrente
    end
    
    methods
        function objeto = Creconst(arquivo_dat)      %construtor
            objeto@Cpaciente(arquivo_dat);           
        end
        
        function f2 = get.freq2(objeto)
            f2 = objeto.NF*objeto.freq_amost;
        end
        
        function calcOndas(objeto)
            tmax = zeros(1,objeto.num_canais);
            for n = 1:objeto.num_canais
                vn = strcat('E',num2str(n));
                tc = objeto.Csinal_processador.corr_onda.(vn);
                tmax(n) = max(tc(:,1));
            end

            tend = max(tmax) + objeto.largura_pulso1 + objeto.interphase_gap + objeto.largura_pulso2;
            npoints = ceil(tend*objeto.freq2);
            objeto.tempo = (1:npoints)*1/objeto.freq2;
            objeto.ondas = zeros(objeto.num_canais,npoints);

            for n = 1:objeto.num_canais
                vn = strcat('E',num2str(n));
                tc = objeto.Csinal_processador.corr_onda.(vn);
                [~,objeto.ondas(n,:)] = calcOndas(tc, objeto.freq2, objeto.tipo_pulso, ...
                objeto.largura_pulso1, objeto.largura_pulso2, objeto.tempo);                
            end
        end
        
        function vocoder(objeto,flag)
            saida = vocoder(objeto.Csinal_processador.env,objeto.freq_amost,...
                objeto.carrier,Cpaciente(objeto.paciente).bandas_freq_entrada,...
                Cpaciente(objeto.paciente).sup_freq,Cpaciente(objeto.paciente).inf_freq,...
                objeto.vet_tempo);
            if flag == 1
            nv = '_vocoder_hc.wav';
            audiowrite(char(strcat(objeto.nome_reconst,nv)),saida,objeto.freq_amost)
            end
        end
        
        function neural_vocoder(objeto,flag)
            objeto.calcOndas();
            [objeto.CorrDist,objeto.Spike_matrix, objeto.V_mem, objeto.Ap,...
                objeto.audio_reconst] = neural_vocoder(objeto.ondas,objeto.num_canais,...
                objeto.freq_amost,objeto.freq2,objeto.corr_esp,objeto.carrier,...
                objeto.lambda,objeto.dtn_A, objeto.N_neurons, objeto.R_mem,objeto.C_mem,...
                objeto.dt_refrat_abs,objeto.V_thr_mem,objeto.V_rest_mem,objeto.V_ruido_mem,...
                objeto.pos_inicial, objeto.dx_eletrodo, objeto.R_canal);

            if flag == 1
            nv = strcat('_neural_vocoder_hc','.wav');
            audiowrite(char(strcat(objeto.nome_reconst,nv)),objeto.audio_reconst,objeto.freq_amost)
            end
        end 
        
        function plotSpikes(objeto)
            [y,x] = find(objeto.Spike_matrix);
            x = x/(2*objeto.freq2);
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
            suplabel('N�mero do eletrodo','y',[.125 .125 .8 .8]);
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
                ylabel('Popula��o no eletrodo "N" (da base ao �pice)')
                ylabel(c,'Taxa de disparos (spikes/s)')
                view(0, 270)
                %set(gca,'Ydir','reverse')
        end
        
    end
    
end

