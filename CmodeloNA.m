classdef CmodeloNA < Cprocessador
    %CmodeloNA Classe responsável pela modelagem da resposta do Nervo Auditivo
    
    properties
        dn_freq_amost = 10; % Discretização da nova freq amost (dn_freq_amost*freq_amost)
        dist_corr % Distribuição de corrente
        spike_matrix % Matriz de spikes
        V_mem % Potencial de membrana ao longo do t_pulsos_corr
        Ap % Somatório de spikes ao longo do t_pulsos_corr
        lambda = 3; % Monopolar 8-11mm / Bipolar 2-4mm
        dtn_A = 35e-3; % Discretização para o somatório de spikes
        N_neurons = 50; % Numero total de neuronios
        R_mem = [1900e6 2000e6]; %Resistencia do neuronio [Ohms] | Distribuicao normal entre 1900MOhm e 2000MOhm como 99.7% do intervalo de codn_freq_amostianca
        C_mem = [0.07e-12 0.5e-12]; % Capacitancia [F] | Distribuicao normal entre 0.07pF e 0.5pF como 99.7% do intervalo de codn_freq_amostianca
        dt_refrat_abs = [1e-6 330e-6]; % Periodo refratario absoluto [s] | Distribuicao normal entre 1us e 300us
        V_thr_mem = [-50e-3 -36e-3]; % Potencial limiar [V] | Distribuicao normal entre -50mV e -36mV
        V_rest_mem = [-80e-3 -55e-3]; % Potencial de membrana estacionario [V] | Distribuicao normal entre -80mV e -55mV
        V_ruido_mem = [-2e-3 2e-3];  % Potencial de ruido [V] | Distribuicao normal entre -2mV e 2mV
        tipo_esp_corr = 'Gauss'; % Modelo de espalhamento de corrente: 'Exp' ou 'Gauss'
        pos_inicial = 0; % Posição inicial do arrranjo de eletrodos inserido na cóclea [mm]
        pos_eletrodo % Vetor de posicao de cada eletrodo no arranjo
        dx_eletrodo = 1; % Distância entre eletrodos [mm]
        Z_eletrodo = 5e3*ones(22,1); % Impedância dos canais do implante [Ohm]
        pulsos_corr % Series de pulsos de corrente
        t_pulsos_corr % vetor de tempo para series de pulso
        
    end
    
    properties(Dependent)
        freq_amost_pulsos;          % Frequencia de amostragem das pulsos_corr de corrente
    end
    
    methods
        function objeto = CmodeloNA(arquivo_dat,nome_sinal_entrada)         
            objeto@Cprocessador(arquivo_dat,nome_sinal_entrada);
        end
        
        function val = get.freq_amost_pulsos(objeto)
            val = objeto.dn_freq_amost*objeto.freq_amost;
        end
        function calcOndas(objeto) % Geração das séries de pulso
            tmax = zeros(1,objeto.num_canais);
            for n = 1:objeto.num_canais
                vn = strcat('E',num2str(n));
                tc = objeto.Csinal_processador.amp_pulsos.(vn);
                tmax(n) = max(tc(:,1));
            end

            tend = max(tmax) + objeto.largura_pulso1 + objeto.interphase_gap + objeto.largura_pulso2;
            npoints = ceil(tend*objeto.freq_amost_pulsos);
            objeto.t_pulsos_corr = (1:npoints)*1/objeto.freq_amost_pulsos;
            objeto.pulsos_corr = zeros(objeto.num_canais,npoints);

            for n = 1:objeto.num_canais
                vn = strcat('E',num2str(n));
                tc = objeto.Csinal_processador.amp_pulsos.(vn);
                [~,objeto.pulsos_corr(n,:)] = calcOndas(tc, objeto.freq_amost_pulsos, objeto.tipo_pulso, ...
                objeto.largura_pulso1, objeto.largura_pulso2, objeto.t_pulsos_corr);                
            end
        end
        
        function LIF(objeto) % Modelo Leaky Integrate & Fire 
            objeto.calcOndas();
            [objeto.dist_corr,objeto.spike_matrix, objeto.V_mem, objeto.Ap, objeto.pos_eletrodo] = LIF(objeto.pulsos_corr,objeto.num_canais,...
            objeto.freq_amost_pulsos,objeto.tipo_esp_corr,...
            objeto.lambda,objeto.dtn_A, objeto.N_neurons, objeto.R_mem,objeto.C_mem,...
            objeto.dt_refrat_abs,objeto.V_thr_mem,objeto.V_rest_mem,objeto.V_ruido_mem,...
            objeto.pos_inicial, objeto.dx_eletrodo, objeto.Z_eletrodo);    
        end 
    end
    
end

