classdef CmodeloNA < Cprocessador
    %CmodeloNA esta classe contém modelos do Nervo Auditivo
    
    properties
        NF = 10;        % Discretização da nova freq amost
        CorrDist        % Distribuição de corrente
        Spike_matrix    % Matriz de spikes
        V_mem           % Potencial de membrana ao longo do tempo
        Ap              % Somatório de spikes ao longo do tempo
        lambda = 3;     % Monopolar 8-11mm / Bipolar 2-4mm
        dtn_A = 35e-3;  % Discretização para o somatório de spikes
        N_neurons = 50; % numero total de neuronios
        R_mem = [1900e6 2000e6]; % resistencia do neuronio [Ohms] | Distribuicao normal entre 1900MOhm e 2000MOhm como 99.7% do intervalo de confianca
        C_mem = [0.07e-12 0.5e-12]; % capacitancia [F] | Distribuicao normal entre 0.07pF e 0.5pF como 99.7% do intervalo de confianca
        dt_refrat_abs = [1e-6 330e-6]; % % periodo refratario absoluto [s] | Distribuicao normal entre 1us e 300us
        V_thr_mem = [-50e-3 -36e-3]; % potencial limiar [V] | Distribuicao normal entre -50mV e -36mV
        V_rest_mem = [-80e-3 -55e-3]; % potencial de membrana estacionario [V] | Distribuicao normal entre -80mV e -55mV
        V_ruido_mem = [-2e-3 2e-3];       % potencial de ruido [V] | Distribuicao normal entre -2mV e 2mV
        corr_esp = 'Gauss'; % 'Exp' ou 'Gauss'
        pos_inicial = 0; % posição inicial do arrranjo de eletrodos inserido na cóclea [mm]
        pos_eletrodo
        dx_eletrodo = 1; % distância entre eletrodos [mm]
        R_canal = 5e3; % impedância dos canais do implante [Ohm]
        ondas
        tempo
        
    end
    
    methods
        function objeto = CmodeloNA(arquivo_dat,nome) % Funcao geral da Classe           
            objeto@Cprocessador(arquivo_dat,nome);
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
        
        function LIF(objeto)
            objeto.calcOndas();
            [objeto.CorrDist,objeto.Spike_matrix, objeto.V_mem, objeto.Ap, objeto.pos_eletrodo] = LIF(objeto.ondas,objeto.num_canais,...
                objeto.freq2,objeto.corr_esp,...
                objeto.lambda,objeto.dtn_A, objeto.N_neurons, objeto.R_mem,objeto.C_mem,...
                objeto.dt_refrat_abs,objeto.V_thr_mem,objeto.V_rest_mem,objeto.V_ruido_mem,...
                objeto.pos_inicial, objeto.dx_eletrodo, objeto.R_canal);
        end 
    end
    
end

