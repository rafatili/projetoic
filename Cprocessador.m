classdef Cprocessador < handle
    % Classe principal da simulacao do Implante Coclear
    %   
    
    properties (Access = public)
        Csinal_processador % Classe com sinais para cada etapa do processador             
        num_canais = 22 % Numero de canais do IC
        maxima = 22 % Selecao de n (maxima) canais por frame
        tipo_filtro = 'Butterworth' % Tipo de filtro para o banco do IC
        tipo_env = 'Hilbert' % Tipo de extracao da envoltoria
        fcorte_fpb = 400; % Frequencia de corte do FPB apos retificacao
        ordem_fpb = 4; % Ordem do FPB apos retificacao
        tipo_pulso = 'Bifasico' % Formato de pulso eletrico
        largura_pulso = 25e-6 % Largura do pulso (meia onda sem contar o interphase gap)
        interphase_gap = 8e-6 % Intervalo entre as partes positiva e negativa do pulso
        taxa_est = 1000 % Taxa de estimulacao do gerador de pulsos
        quant_bits = 8 % Número de bits para divisão da faixa dinamica
        fat_comp = 0.6 % fator de compressao (expoente para a lei da potencia)
        fase_pulso = 'Catodico' % Fase inicial do pulso: Anodico (-) ou Catodico (+)
        amp_corr_T = 1e-5 % Limiar da amplitude de corrente
        amp_corr_C = 1e-3 % Maximo conforto para amplitude de corrente
        max_corr = 1.75e-3 % Maxima corrente do gerador
        atraso = 0; % Atraso do envelope entre canais: 0 (sem atraso) ou 1 (com atraso)
        paciente = 'padrao' % Utilização das informacoes do 'paciente padrao' da clase
        low_freq = 150 % Frequencia central do filtro de baixa frequencia
        nome % Nome do arquivo de entrada de audio
        tipo_vocoder = 'Senoidal' % Formato de onda para reconstrucao com vocoder: 'Ruido' / 'Senoidal'
    end
    
    properties (Dependent)
        dt % Intervalo de tempo entre pontos no arquivo de entrada
        T_total % Tempo total do arquivo de entrada
        freq_amost % Frequencia de amostragem do arquivo de entrada
        num_bits % Número de bits do arquivo de entrada 
        vet_tempo % Vetor temporal do arquivo de entrada
    end
    
    methods % Funcoes da Classe
        function objeto = Cprocessador(prop1,prop2) % Funcao geral da Classe
            if nargin == 1
                objeto.nome = prop1;
            elseif nargin == 2
                objeto.nome = prop1;
                objeto.paciente = prop2;
            
%                 if strcmp(objeto.paciente,'media') == 1
%                     Cpaciente(objeto.paciente).media_paciente()
%                 end
                
            objeto.num_canais = max(Cpaciente(objeto.paciente).numero_canais);
            objeto.maxima = Cpaciente(objeto.paciente).maxima;
            objeto.interphase_gap = mean(Cpaciente(objeto.paciente).inter_phase_gap)*1e-6;
            objeto.largura_pulso = mean(Cpaciente(objeto.paciente).largura_pulso)*1e-6;
            objeto.fat_comp = mean(Cpaciente(objeto.paciente).fat_comp);
            objeto.amp_corr_T = Cpaciente(objeto.paciente).T_corr;
            objeto.amp_corr_C = Cpaciente(objeto.paciente).C_corr;
            objeto.low_freq = Cpaciente(objeto.paciente).lower_freq(1,1);
            %objeto.num_canais = Cpaciente(objeto.paciente).upper_freq;
                                              
            end
        end 
        
%% GET (Definição das variáveis dependentes)      
        
        function freq_amost = get.freq_amost(objeto)
            [~ , var]= audioread(objeto.nome);
            freq_amost = var;
        end       
        
        function dt = get.dt(objeto)
                dt = 1/objeto.freq_amost;
        end
        
        function T_total = get.T_total(objeto)
                var = audioinfo(objeto.nome);
                T_total = var.Duration;
        end
        
        function vet_tempo = get.vet_tempo(objeto)
                vet_tempo = objeto.dt:objeto.dt:objeto.T_total;
        end      
        
        function num_bits = get.num_bits(objeto)
                var = audioinfo(objeto.nome);
                num_bits = var.BitsPerSample;
        end
        
%% OUTRAS FUNÇÕES

        function openwav(objeto)
            objeto.Csinal_processador.in = audioread(objeto.nome); 
        end

        function play(objeto)
            sound(objeto.Csinal_processador.in,objeto.freq_amost)          
        end
        
        
%% BLOCOS

        function filtros(objeto)
            %objeto.Csinal_processador.filt = cochlearFilterBank(objeto.freq_amost, objeto.num_canais, objeto.low_freq, objeto.Csinal_processador.in);
            objeto.Csinal_processador.filt = CIFilterBank(objeto.freq_amost, objeto.num_canais, objeto.low_freq, objeto.Csinal_processador.in,Cpaciente(objeto.paciente).bandwidths_in);
        end 
    
        function ext_env(objeto)
            objeto.Csinal_processador.env = ext_env(objeto.Csinal_processador.filt,objeto.tipo_env,objeto.fcorte_fpb,objeto.freq_amost,objeto.ordem_fpb);
        end
        
        function comp(objeto)
            objeto.Csinal_processador.comp = comp(objeto.Csinal_processador.env,objeto.fat_comp,objeto.quant_bits,objeto.amp_corr_C,objeto.amp_corr_T);         
        end
       
        function ger_pulsos(objeto)          
            objeto.Csinal_processador.corr_onda = ger_pulsos(objeto.Csinal_processador.comp,objeto.num_canais,...
                objeto.maxima,objeto.freq_amost,objeto.T_total,objeto.taxa_est,objeto.tipo_pulso,objeto.largura_pulso,objeto.interphase_gap,objeto.fase_pulso,objeto.atraso,objeto.max_corr,objeto.quant_bits);                   
        end
                                                  
        function cis_ace(objeto)
            openwav(objeto)
            filtros(objeto)
            ext_env(objeto)
            comp(objeto)
            ger_pulsos(objeto)
        end
        
        function saida = vocoder(objeto,flag)
            saida = vocoder(objeto.Csinal_processador.env,objeto.freq_amost,objeto.tipo_vocoder,Cpaciente(objeto.paciente).bandwidths_in,Cpaciente(objeto.paciente).upper_freq,Cpaciente(objeto.paciente).lower_freq,objeto.vet_tempo);
            if flag == 1
            nv = 'vocoder_';
            audiowrite(strcat(nv,objeto.tipo_vocoder,'_',objeto.nome),saida,objeto.freq_amost)
            end
        end

    end
end
   
    
        

