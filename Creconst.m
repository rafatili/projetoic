classdef Creconst < handle
    %CRECONST Classe de objetoetos que armazenam os dados, testa modelos e
    %reconstroi o sinal
    
    properties
        ENV             % Envolt�ria temporal dos canais do IC
        Pulsos          % Amplitude dos pulsos de corrente ao longo do tempo
        num_canais;     % Numero de canais do IC
        maxima;         % Selecao de n (maxima) canais por frame
        tipo_filtro;    % Tipo de filtro para o banco do IC
        tipo_env;       % Tipo de extracao da envoltoria
        fcorte_fpb;     % Frequencia de corte do FPB apos retificacao
        ordem_fpb;      % Ordem do FPB apos retificacao
        tipo_pulso;     % Formato de pulso eletrico
        largura_pulso1;	% Largura do pulso 1 (meia onda sem contar o interphase gap)
        largura_pulso2;	% Largura do pulso 2 (meia onda sem contar o interphase gap)
        interphase_gap;	% Intervalo entre as partes positiva e negativa do pulso
        taxa_est;       % Taxa de estimulacao do gerador de pulsos
        quant_bits;     % Numero de bits para divisao da faixa dinamica
        fat_comp;       % fator de compressao (expoente para a lei da potencia)
        fase_pulso;     % Fase inicial do pulso: Anodico (-) ou Catodico (+)
        amp_corr_T;     % Limiar da amplitude de corrente
        amp_corr_C;     % Maximo conforto para amplitude de corrente
        max_corr;       % Maxima corrente do gerador
        atraso;         % Atraso do envelope entre canais: 0 (sem atraso) ou 1 (com atraso)
        paciente;       % Utilizacao das informacoes do 'paciente padrao' da clase
        baixa_freq;       % Frequencia central do filtro de baixa frequencia
        nome;           % Nome do arquivo de entrada de audio
        freq_amost;
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
        vet_tempo
    end
    properties(Dependent)
        freq2;          % Frequencia de amostragem das ondas de corrente
    end
    
    methods
        function objeto = Creconst(Y)      %construtor
            if ~isa(Y,'Cprocessador')
                error('A entrada deve ser um objeto do tipo Cprocessador.')
            end
            
            objeto.ENV = Y.Csinal_processador.env;
            objeto.Pulsos = Y.Csinal_processador.corr_onda;
            objeto.num_canais = Y.num_canais;
            objeto.maxima = Y.maxima;
            objeto.tipo_filtro = Y.tipo_filtro;
            objeto.tipo_env = Y.tipo_env;
            objeto.fcorte_fpb = Y.fcorte_fpb;
            objeto.ordem_fpb = Y.ordem_fpb;
            objeto.tipo_pulso = Y.tipo_pulso;
            objeto.largura_pulso1 = Y.largura_pulso1;
            objeto.largura_pulso2 = Y.largura_pulso2;
            objeto.interphase_gap = Y.interphase_gap;
            objeto.taxa_est = Y.taxa_est;
            objeto.quant_bits = Y.quant_bits;
            objeto.fat_comp = Y.fat_comp;
            objeto.fase_pulso = Y.fase_pulso;
            objeto.amp_corr_T = Y.amp_corr_T;
            objeto.amp_corr_C = Y.amp_corr_C;
            objeto.max_corr = Y.max_corr;
            objeto.atraso = Y.atraso;
            objeto.paciente = Y.paciente;
            objeto.baixa_freq = Y.baixa_freq;
            objeto.nome = Y.nome;
            objeto.freq_amost = Y.freq_amost;
            objeto.vet_tempo = Y.vet_tempo;
        end
        
        function f2 = get.freq2(objeto)
            f2 = objeto.NF*objeto.freq_amost;
        end
        
        function calcOndas(objeto)
            tmax = zeros(1,objeto.num_canais);
            for n = 1:objeto.num_canais
                vn = strcat('E',num2str(n));
                tc = objeto.Pulsos.(vn);
                tmax(n) = max(tc(:,1));
            end

            tend = max(tmax) + objeto.largura_pulso1 + objeto.interphase_gap + objeto.largura_pulso2;
            npoints = ceil(tend*objeto.freq2);
            objeto.tempo = (1:npoints)*1/objeto.freq2;
            objeto.ondas = zeros(objeto.num_canais,npoints);

            for n = 1:objeto.num_canais
                vn = strcat('E',num2str(n));
                tc = objeto.Pulsos.(vn);
                [~,objeto.ondas(n,:)] = calcOndas(tc, objeto.freq2, objeto.tipo_pulso, ...
                objeto.largura_pulso1, objeto.largura_pulso2, objeto.tempo);                
            end
        end
        
        function vocoder(objeto,flag)
            saida = vocoder(objeto.ENV,objeto.freq_amost,...
                objeto.carrier,Cpaciente(objeto.paciente).bandas_freq_entrada,...
                Cpaciente(objeto.paciente).sup_freq,Cpaciente(objeto.paciente).inf_freq,...
                objeto.vet_tempo);
            if flag == 1
            nv = '_vocoder_hc.wav';
            audiowrite(char(strcat(objeto.nome_reconst,nv)),saida,objeto.freq_amost)
            end
        end
        
        function neural_vocoder(objeto,flag)
            [objeto.CorrDist,objeto.Spike_matrix, objeto.V_mem, objeto.Ap,...
                objeto.audio_reconst] = neural_vocoder(objeto.calcOndas(),objeto.num_canais,...
                objeto.freq_amost,objeto.freq2,objeto.corr_esp,objeto.carrier,...
                objeto.lambda,objeto.dtn_A, objeto.N_neurons, objeto.R_mem,objeto.C_mem,...
                objeto.dt_refrat_abs,objeto.V_thr_mem,objeto.V_rest_mem,objeto.V_ruido_mem,...
                objeto.pos_inicial, objeto.dx_eletrodo, objeto.R_canal);

            if flag == 1
            nv = strcat('_neural_vocoder_hc','.wav');
            audiowrite(char(strcat(objeto.nome_reconst,nv)),objeto.audio_reconst,objeto.freq_amost)
            end
        end 
        
    end
    
end
