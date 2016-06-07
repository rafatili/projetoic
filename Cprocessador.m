classdef Cprocessador < Cpaciente & CsinalEntrada
    % Classe responsável pelo processamento do Implante Coclear
    %   
    
    properties 
        Csinal_processador % Classe com sinais de cada bloco de processamento
        tipo_filtro = 'Nucleus' % Tipo de filtro para o banco do IC: 'Gammatone' ; 'Nucleus';
        tipo_env = 'Hilbert' % Tipo de extracao da envoltoria
        fcorte_fpb = 400; % Frequencia de corte do FPB apos retificacao
        ordem_fpb = 4; % Ordem do FPB apos retificacao
        taxa_est = 1000 % Taxa de estimulacao do gerador de pulsos
        quant_bits = 8 % Número de bits para divisão da faixa dinamica
        fase_pulso = 'Catodico' % Fase inicial do pulso: Anodico (+) ou Catodico (-)
        atraso = 0; % Atraso do envelope entre canais: 0 (sem atraso) ou 1 (com atraso)
        paciente = 'padrao' % Utilização das informacoes do 'paciente padrao' da clase
        baixa_freq = 150 % Frequencia central do filtro de baixa frequencia
        nome_sinal_entrada % nome do arquivo de entrada de audio
        tipo_pulso = 'Bifasico' % Formato de pulso eletrico
        max_corr = 1.75e-3 % Maxima corrente do gerador
    end
    
    properties (Dependent)
        dt % Intervalo de tempo entre pontos no arquivo de entrada
        T_total % Tempo total do arquivo de entrada      
        num_bits % Número de bits do arquivo de entrada 
        vet_tempo % Vetor temporal do arquivo de entrada
        freq_amost % Frequencia de amostragem
        max_corr_paciente % Corrente maxima suportada pelo paciente
    end
    
    methods % Funcoes da Classe
        function objeto = Cprocessador(arquivo_dat,prop2)           
            objeto@Cpaciente(arquivo_dat);
            objeto@CsinalEntrada(); 
            if nargin == 2
                objeto.nome_sinal_entrada = prop2;
            else 
                error('Wrong number of input arguments')                                     
            end
        end 
        
%% GET (Definição das variáveis dependentes)      
        
        function val = get.freq_amost(objeto)
            [~ , val]= audioread(objeto.nome_sinal_entrada);
        end       
        
        function val = get.dt(objeto)
                val = 1/objeto.freq_amost;
        end
        
        function val = get.T_total(objeto)
                var = audioinfo(objeto.nome_sinal_entrada);
                val = var.Duration;
        end
        
        function val = get.vet_tempo(objeto)
                val = objeto.dt:objeto.dt:objeto.T_total;
        end      
        
        function val = get.num_bits(objeto)
                var = audioinfo(objeto.nome_sinal_entrada);
                val = var.BitsPerSample;
        end
        
        function val = get.max_corr_paciente(objeto)
                val = objeto.max_corr*(1e-2)*10.^(objeto.C_Level/(2^objeto.num_bits-1));
        end
        
%% OUTRAS FUNÇÕES

        function openwav(objeto)
%             [var1, var2] = audioread(objeto.nome_sinal_entrada);
%             objeto.Csinal_processador.in = resample(var1,objeto.freq_amost,var2);
            objeto.Csinal_processador.in = audioread(objeto.nome_sinal_entrada);
        end

        function play(objeto)
            sound(objeto.Csinal_processador.in,objeto.freq_amost)          
        end
        
        
%% BLOCOS

        function filtros(objeto)
            switch(objeto.tipo_filtro)
                
                case 'Gammatone'
                objeto.Csinal_processador.filt = cochlearFilterBank(...
                    objeto.freq_amost, objeto.num_canais, objeto.baixa_freq, objeto.Csinal_processador.in);
                
                case 'Nucleus'
                objeto.Csinal_processador.filt = CIFilterBank(...
                    objeto.freq_amost, objeto.num_canais,objeto.central_freq(1),...
                    objeto.Csinal_processador.in,objeto.bandas_freq_entrada(1:objeto.num_canais));
            end
        end 
    
        function ext_env(objeto)
            objeto.Csinal_processador.env = ext_env(objeto.Csinal_processador.filt,...
                objeto.tipo_env,objeto.fcorte_fpb,objeto.freq_amost,objeto.ordem_fpb);
        end
        
        function comp(objeto)
            objeto.Csinal_processador.comp = comp(objeto.Csinal_processador.env,...
                objeto.fat_comp,objeto.C_Level,objeto.T_Level);         
        end
       
        function ger_pulsos(objeto)          
            objeto.Csinal_processador.amp_pulsos = ger_pulsos(objeto.Csinal_processador.comp,objeto.num_canais,...
                objeto.maxima,objeto.freq_amost,objeto.T_total,objeto.taxa_est,objeto.tipo_pulso,objeto.largura_pulso1,...
                objeto.largura_pulso2,objeto.interphase_gap,objeto.fase_pulso,objeto.atraso,objeto.max_corr,...
                objeto.quant_bits,objeto.T_Level,objeto.C_Level);                   
        end
                                                  
        function cis_ace(objeto)
            openwav(objeto)
            filtros(objeto)
            ext_env(objeto)
            comp(objeto)
            ger_pulsos(objeto)
        end                     
        
    end
end
   
    
        

