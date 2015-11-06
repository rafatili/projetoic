classdef Cprocessador < handle
    % Classe principal da simulação do Implante Coclear
    %   
    
    properties (Access = public)
        Csinal_processador % Classe com sinais para cada etapa do processador             
        num_canais = 16 % Número de canais do IC
        maxima = 22 % Seleção de n (maxima) canais por frame
        tipo_filtro = 'Butterworth' % Tipo de filtro para o banco do IC
        tipo_pulso = 'Bifásico' % Formato de pulso elétrico
        largura_pulso = 25e-6 % Largura do pulso (meia onda sem contar o interphase gap)
        interphase_gap = 8e-6 % Intervalo entre as partes positiva e negativa do pulso
        taxa_est = 1000 % Taxa de estimulação do gerador de pulsos
        quant_bits = 8 % Número de bits para divisão da faixa dinâmica
        fat_comp = 0.6 % fator de compressão (expoente para a lei da potência)
        fase_pulso = 'Catódico' % Fase inicial do pulso: Anódico (-) ou Catódico (+)
        amp_corr_T = 1e-5 % Limiar da amplitude de corrente
        amp_corr_C = 1e-3 % Máximo conforto para amplitude de corrente
        max_corr = 1.75e-3 % Máxima corrente do gerador
        atraso = 0; % Atraso do envelope entre canais: 0 (sem atraso) ou 1 (com atraso)
        paciente = 'Default' % Utilização das informações do 'paciente padrão' da clase
        low_freq = 150 % Frequência central do filtro de baixa frequência
        nome % Nome do arquivo de entrada de áudio
    end
    
    properties (Dependent)
        dt % Intervalo de tempo entre pontos no arquivo de entrada
        T_total % Tempo total do arquivo de entrada
        freq_amost % Frequência de amostragem do arquivo de entrada
        %nome % Nome do arquivo de entrada de áudio
        num_bits % Número de bits do arquivo de entrada 
        vet_tempo % Vetor temporal do arquivo de entrada
    end
    
    methods % Funções da Classe
        function objeto = Cprocessador(prop1,prop2) % Função geral da Classe
            if nargin == 1
                objeto.nome = prop1;
            elseif nargin == 2
                objeto.nome = prop1;
                objeto.paciente = prop2;
            end
            
            if strcmp(objeto.paciente,'Default') == 0
               
            objeto.num_canais = max(Cpaciente(objeto.paciente).numero_canais);
            %objeto.maxima = Cpaciente(objeto.paciente).maxima;
            objeto.interphase_gap = mean(Cpaciente(objeto.paciente).inter_phase_gap);
            objeto.largura_pulso = mean(Cpaciente(objeto.paciente).largura_pulso);
            %objeto.num_canais = Cpaciente(objeto.paciente).T_SPL;
            %objeto.num_canais = Cpaciente(objeto.paciente).C_SPL;
            objeto.fat_comp = mean(Cpaciente(objeto.paciente).loudness_exp);
            %objeto.amp_corr_T = Cpaciente(objeto.paciente).T_corr;
            %objeto.amp_corr_C = Cpaciente(objeto.paciente).C_corr;
            objeto.low_freq = Cpaciente(objeto.paciente).lower_freq(1,1);
            %objeto.num_canais = Cpaciente(objeto.paciente).upper_freq;
                
                
                
            end
        end 
        
%% GET (Definição das variáveis dependentes)      
%         function nome = get.nome(objeto)
%             nome = objeto.Csinal_processador.nome;           
%         end
        
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
            objeto.Csinal_processador.filt = cochlearFilterBank(objeto.freq_amost, objeto.num_canais, objeto.low_freq, objeto.Csinal_processador.in);
        end 
    
        function ext_env(objeto)
            objeto.Csinal_processador.env = abs(hilbert(objeto.Csinal_processador.filt'))';
        end
        
        function comp(objeto)
            
            comp_range = 0:2^objeto.quant_bits-1;
            comp_range = comp_range.^objeto.fat_comp;
            max_amp = max(max(objeto.Csinal_processador.env));
            
            for i = 1:objeto.num_canais
                objeto.Csinal_processador.env(i,:) = objeto.Csinal_processador.env(i,:)*(2^objeto.quant_bits-1)/max_amp; 
                objeto.Csinal_processador.comp(i,:) = quantiz(objeto.Csinal_processador.env(i,:), comp_range);       
            end
            
            objeto.Csinal_processador.comp = (objeto.amp_corr_C/(2^objeto.quant_bits-1))*objeto.Csinal_processador.comp;
            
        end

        
        function ger_pulsos(objeto)
            
            if objeto.num_canais == objeto.maxima % Estratégia CIS
            
            objeto.Csinal_processador.corr_onda = zeros(objeto.num_canais,objeto.T_total*objeto.taxa_est,2);
            
            if strcmp(objeto.fase_pulso,'Catódico') == 1 
                fase = 1;
            elseif strcmp(objeto.fase_pulso,'Anódico') == 1
                fase = -1;
            end
                                    
            t = 0;
                
            for i = objeto.num_canais:-1:1
 
            resamp(i,:) = resample(objeto.Csinal_processador.comp(i,:), objeto.num_canais*objeto.taxa_est,objeto.freq_amost);
               
            end
            size(resamp)
                
            a = 1;
                
                for j = 1:objeto.T_total*objeto.taxa_est %size(resamp,2)
                    
                    n = 0;
                    
                    for i = objeto.num_canais:-1:1
                        
                        if strcmp(objeto.tipo_pulso,'Bifásico') == 1 
                            
                            for k = 1:2
                                if k == 1
                                objeto.Csinal_processador.corr_onda(i,a,:) = [t fase*resamp(i,j + n)];  
                                elseif k == 2
                                t = t + objeto.largura_pulso + objeto.interphase_gap;
                                objeto.Csinal_processador.corr_onda(i,a + 1,:) = [t -fase*resamp(i,j + n)];
                                end
                            end
                            t = t - (objeto.largura_pulso + objeto.interphase_gap) + 1/(objeto.num_canais*objeto.taxa_est);
                        
                        end
                        
                        if objeto.atraso == 0
                           n = n + 1;
                        end
                        
                    end
                    
                    a = a + 2;
                    
                end
                
                a
                t
            
            else
                
                display('Estratégia ainda não programada!') % Estratégia ACE
            
            end
            
        end
               
                                   
        function cis(objeto)
            filtros(objeto)
            ext_env(objeto)
            comp(objeto)
            ger_pulsos(objeto)
        end

    end
end
   
    
        

