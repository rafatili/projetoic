classdef CmodeloNA < Cprocessador
    %% CmodeloNA Classe responsavel pela modelagem da resposta do Nervo Auditivo
    
    properties
        dn_freq_amost = 3; % Discretizacao da nova freq amost (dn_freq_amost*freq_amost)
        dist_corr % Distribuicao de corrente
        spike_matrix % Matriz de spikes
        V_mem % Potencial de membrana ao longo do tempo
        Ap % Somatorio de spikes ao longo do tempo
        lambda = 3; % Constante de espalhamento exponencial: Monopolar 8-11mm / Bipolar 2-4mm
        dtn_A = 35e-3; % Discretizacao para o somatorio de spikes
        N_neurons = 50; % Numero total de neuronios
        R_mem = [1900e6 2000e6]; % Resistencia do neuronio [Ohms] | Distribuicao normal entre 1900MOhm e 2000MOhm como 99.7% do intervalo de confianca
        C_mem = [0.07e-12 0.5e-12]; % Capacitancia [F] | Distribuicao normal entre 0.07pF e 0.5pF como 99.7% do intervalo de confianca
        dt_refrat_abs = [1e-6 330e-6]; % Periodo refratario absoluto [s] | Distribuicao normal entre 1us e 300us
        V_thr_mem = [-50e-3 -36e-3]; % Potencial limiar [V] | Distribuicao normal entre -50mV e -36mV
        V_rest_mem = [-80e-3 -55e-3]; % Potencial de membrana estacionario [V] | Distribuicao normal entre -80mV e -55mV
        V_ruido_mem = [-2e-3 2e-3];  % Potencial de ruido [V] | Distribuicao normal entre -2mV e 2mV
        tipo_esp_corr = 'Gauss'; % Modelo de espalhamento de corrente: 'Exp' ou 'Gauss'
        pos_inicial = 0; % Posicao inicial do arrranjo de eletrodos inserido na coclea [mm]
        pos_eletrodo = fliplr(1:22); % Vetor de posicao de cada eletrodo no arranjo
        dx_eletrodo = 1; % Distancia entre eletrodos [mm]
        Z_eletrodo = 5e3*ones(22,1); % Impedancia dos canais do implante [Ohm]
        pulsos_corr % Series de pulsos de corrente
        t_pulsos_corr % Vetor de tempo para series de pulso
        spike_matrix_Zilany
        
    end
    
    properties(Dependent)
        freq_amost_pulsos; % Frequencia de amostragem das ondas de corrente
    end
    
    methods
        function obj = CmodeloNA(arquivo_dat,varargin)
            % varargin = {arquivo .wav de audio alvo, arquivo .wav do ruido, SNRdB}
            obj@Cprocessador(arquivo_dat,varargin{:});
        end
        
        function val = get.freq_amost_pulsos(obj)
            val = obj.dn_freq_amost*obj.freq_amost;
        end
        function calcOndas(obj) % Geracao das series de pulso
            tmax = zeros(1,obj.num_canais);
            for n = 1:obj.num_canais
                vn = strcat('E',num2str(n));
                tc = obj.Csinal_processador.amp_pulsos.(vn);
                tmax(n) = max(tc(:,1));
            end

            tend = max(tmax) + obj.largura_pulso1 + obj.interphase_gap + obj.largura_pulso2;
            npoints = ceil(tend*obj.freq_amost_pulsos);
            obj.t_pulsos_corr = (1:npoints)*1/obj.freq_amost_pulsos;
            obj.pulsos_corr = zeros(obj.num_canais,npoints);

            for n = 1:obj.num_canais
                vn = strcat('E',num2str(n));
                tc = obj.Csinal_processador.amp_pulsos.(vn);
                [~,obj.pulsos_corr(n,:)] = calcOndas(tc, obj.freq_amost_pulsos, obj.tipo_pulso, ...
                obj.largura_pulso1, obj.largura_pulso2, obj.t_pulsos_corr);                
            end
        end
        
        function LIF(obj) % Modelo Leaky Integrate & Fire 
            obj.calcOndas();
            [obj.dist_corr,obj.spike_matrix, obj.V_mem, obj.Ap, obj.pos_eletrodo] = LIF(obj.pulsos_corr,obj.num_canais,...
            obj.freq_amost_pulsos,obj.tipo_esp_corr,...
            obj.lambda,obj.dtn_A, obj.N_neurons, obj.R_mem,obj.C_mem,...
            obj.dt_refrat_abs,obj.V_thr_mem,obj.V_rest_mem,obj.V_ruido_mem,...
            obj.pos_inicial, obj.dx_eletrodo, obj.Z_eletrodo,obj.fase_pulso);    
        end
        
        function Modelo_Zilany(obj)
            obj.spike_matrix_Zilany = zilany2014(obj.C_SPL,obj.Csinal_processador.in,obj.freq_amost,...
                'flow',obj.baixa_freq,'nfibers',obj.N_neurons,'fhigh',obj.freq_amost/2);
        end
    end
    
end

