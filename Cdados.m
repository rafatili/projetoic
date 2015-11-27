classdef Cdados
    %CDADOS Classe de objetos que armazenam os dados da simulacao
    
    properties
        Pulsos          % Classe com sinais para cada etapa do processador
        num_canais;     % Numero de canais do IC
        maxima;         % Selecao de n (maxima) canais por frame
        tipo_filtro;    % Tipo de filtro para o banco do IC
        tipo_env;       % Tipo de extracao da envoltoria
        fcorte_fpb;     % Frequencia de corte do FPB apos retificacao
        ordem_fpb;      % Ordem do FPB apos retificacao
        tipo_pulso;     % Formato de pulso eletrico
        largura_pulso;	% Largura do pulso (meia onda sem contar o interphase gap)
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
        low_freq;       % Frequencia central do filtro de baixa frequencia
        nome;           % Nome do arquivo de entrada de audio
        famost;

    end
    properties(Dependent)
        freq2;          % Frequencia de amostragem das ondas de corrente
    end
    
    methods
        function obj=Cdados(Y)      %construtor
            if ~isa(Y,'Cprocessador')
                error('A entrada deve ser um objeto tipo Cprocessador.')
            end
            
            obj.Pulsos = Y.Csinal_processador.corr_onda;
            obj.num_canais = Y.num_canais;
            obj.maxima = Y.maxima;
            obj.tipo_filtro = Y.tipo_filtro;
            obj.tipo_env = Y.tipo_env;
            obj.fcorte_fpb = Y.fcorte_fpb;
            obj.ordem_fpb = Y.ordem_fpb;
            obj.tipo_pulso = Y.tipo_pulso;
            obj.largura_pulso = Y.largura_pulso;
            obj.interphase_gap = Y.interphase_gap;
            obj.taxa_est = Y.taxa_est;
            obj.quant_bits = Y.quant_bits;
            obj.fat_comp = Y.fat_comp;
            obj.fase_pulso = Y.fase_pulso;
            obj.amp_corr_T = Y.amp_corr_T;
            obj.amp_corr_C = Y.amp_corr_C;
            obj.max_corr = Y.max_corr;
            obj.atraso = Y.atraso;
            obj.paciente = Y.paciente;
            obj.low_freq = Y.low_freq;
            obj.nome = Y.nome;
            obj.famost = Y.freq_amost;
            
        end
        
        function f2=get.freq2(obj)
            f2=20*obj.famost;
        end
        
        function [ondas, tempo] = calcOndas(obj)
            f2=obj.freq2;
            tmax=zeros(1,obj.num_canais);
            for n = 1:obj.num_canais
                vn = strcat('E',num2str(n));
                tc = obj.Pulsos.(vn);
                tmax(n)=max(tc(:,1));
            end

            tend=max(tmax)+2*obj.largura_pulso+obj.interphase_gap;
            npoints=ceil(tend*f2);
            tempo=(1:npoints)*1/obj.freq2;
            ondas=zeros(obj.num_canais,npoints);

            for n = 1:obj.num_canais
                vn = strcat('E',num2str(n));
                tc = obj.Pulsos.(vn);
                ondas(n,:)=calcOndas(tc, f2, obj.tipo_pulso, ...
                    obj.largura_pulso, tempo);
                
            end
        end
    end
    
end

