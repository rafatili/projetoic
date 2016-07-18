function [dist_corr,spike_matrix, V_mem, Ap, pos_eletrodo] = LIF(PulsosCorr,num_canais,...
    freq_amost_pulsos, tipo_esp_corr, lambda, dtn_A, N_neurons, R_mem, C_mem,dt_refrat_abs,...
    Vthr_mem, V_rest_mem,V_ruido_mem, pos_inicial, dx_eletrodo, Z_eletrodo, fase_pulso)

%% Propriedades

N_neurons_pop = ceil(N_neurons/num_canais); % numero de neuronios por populacao
N_neurons = num_canais*N_neurons_pop;

R_desv = abs(max(R_mem) - mean(R_mem))/3;
R = random('norm',mean(R_mem),R_desv,N_neurons,1);

C_desv = abs(max(C_mem) - mean(C_mem))/3;
C = random('norm',mean(C_mem),C_desv,N_neurons,1);

dt_refrat_desv = abs(max(dt_refrat_abs) - mean(dt_refrat_abs))/3;
dt_refrat = random('norm',mean(dt_refrat_abs),dt_refrat_desv,N_neurons,size(PulsosCorr,2));

V_thr_desv = abs(max(Vthr_mem) - mean(Vthr_mem))/3;
V_thr = random('norm',mean(Vthr_mem),V_thr_desv,N_neurons,1);

V_rest_desv = abs(max(V_rest_mem) - mean(V_rest_mem))/3;
V_rest = random('norm',mean(V_rest_mem),V_rest_desv,N_neurons,size(PulsosCorr,2));

V_ruido_desv = abs(max(V_ruido_mem) - mean(V_ruido_mem))/3;
V_ruido = random('norm',mean(V_ruido_mem),V_ruido_desv,N_neurons,size(PulsosCorr,2));

pos_eletrodo = (dx_eletrodo + pos_inicial):dx_eletrodo:(num_canais*dx_eletrodo + pos_inicial);

comp_coclea = 24; % comprimento onde neurônios considerados estão localizados [mm]
dx_coclea = comp_coclea/N_neurons; % distância entre neurônios [mm]
x_coclea = 0:dx_coclea:comp_coclea-dx_coclea; % vetor de posição dos neurônios [mm]

%% Distribuicao da corrente

if strcmp(fase_pulso,'Catodico')==1
    PulsosCorr = -PulsosCorr;
end

for i = 1:size(PulsosCorr,1)
    for j = 1:size(PulsosCorr,2)
        if PulsosCorr(i,j) < 0
            PulsosCorr(i,j) = 0;
        end
%         if PulsosCorr(i,j) > 0
%             PulsosCorr(i,j) = 0;
%         end
    end 
end

dist_corr = zeros(length(x_coclea),size(PulsosCorr,2));

switch(tipo_esp_corr)
    case 'Exp'
    for i = 1:size(PulsosCorr,2)
        for j = 1:size(PulsosCorr,1)
            if PulsosCorr(j,i)>0       
                dist_corr(:,i) = PulsosCorr(j,i)*exp(-abs(pos_eletrodo(j)-x_coclea)/lambda);
            end
        end
    end
    case 'Gauss'
    for i = 1:size(PulsosCorr,2)
        for j = 1:size(PulsosCorr,1)
            if PulsosCorr(j,i)>0 
                A = normpdf(x_coclea,pos_eletrodo(j),PulsosCorr(j,i)*1e3);
                dist_corr(:,i) = PulsosCorr(j,i)*A/(0.4e-3);
                dist_corr(:,i) = PulsosCorr(j,i)*dist_corr(:,i);
            end
        end 
    end
end

%% Leaky Integrate and Fire

V_mem = zeros(size(dist_corr));
for i = 1:size(dist_corr,2)
    for j = 1:size(dist_corr,1)
        V_mem(j,i) = V_rest(j); % potencial de membrana inicial       
    end
end
spike_matrix = zeros(size(dist_corr)); % matriz de spikes
% an = zeros(size(dist_corr,1));
% RZ = mean(Z_eletrodo);
dt = 1/freq_amost_pulsos;

% tic
% for i = 2:size(dist_corr,2)
%     for j = 1:size(dist_corr,1)
%             if an(j)==0                
%                 tau = R(j)*C(j);            
%                 V_mem(j,i) = V_mem(j,i-1) + (dt/tau)*(-(V_mem(j,i-1) - V_rest(j,i)) + RZ*dist_corr(j,i)) + V_ruido(j,i);                       
%                 if V_mem(j,i) >= V_thr(j)
%                     spike_matrix(j,i) = 1;
%                     an(j) = 1;
%                     V_mem(j,i) = V_rest(j,i);
%                 end
%                 
%             else
%                 if dt_refrat(j,i)<an(j)*dt
%                 tau = R(j)*C(j);
%                 V_mem(j,i) = V_mem(j,i-1) + (dt/tau)*(-(V_mem(j,i-1) - V_rest(j,i)) + RZ*dist_corr(j,i)) + V_ruido(j,i);                       
%                     if V_mem(j,i) >= V_thr(j)
%                         spike_matrix(j,i) = 1;
%                         an(j) = 1;
%                         V_mem(j,i) = V_rest(j,i);
%                     end 
%                 else
%                     an(j) = an(j) + 1;
%                 end
%             end
% 
%     end
% end
% toc

tic
t = 0:dt:size(dist_corr,2)*dt-dt;
n_refrat = floor(dt_refrat/dt);
%V_thRi = -40e-3; % Threshold potential
V_thR = zeros(size(dist_corr));
for j = 1:size(dist_corr,2)
    V_thR(:,j) = V_thr;
end
V_refrat = 0.97.*exp(-(t-0.7e-3)/(1.32e-3)); % Relative refractory period
dist_corr = -dist_corr*2e-7;

for j = 1:size(dist_corr,1)
    for i = 2:size(dist_corr,2)-1                                     
        V_mem(j,i) = V_mem(j,i-1) + (dt/(R(j)*C(j)))*(-(V_mem(j,i-1) - V_rest(j,i)) - R(j)*dist_corr(j,i)) + V_ruido(j,i); 
        if V_mem(j,i) >= V_thR(j,i)
        spike_matrix(j,i) = 1;
            if (i+n_refrat(j,i))<size(dist_corr,2)
                V_thR(j,i:(i+n_refrat(j,i))) = Inf;
            end
        V_thR(j,(i+n_refrat(j,i)+1):size(dist_corr,1)) = V_thr(j) - V_thr(j)*V_refrat(1:(size(dist_corr,1)-(i+n_refrat(j,i)+1)+1));
        V_mem(j,i) = V_rest(j,i);
        end                                      
    end
end
toc

size(spike_matrix)
%% Somatório de potenciais de ação (spikes/s)


W = 1:N_neurons_pop;
Wn = pdf('norm',W,mean(W),1);
Wn = Wn/max(Wn);
n_A = floor(dtn_A*freq_amost_pulsos);
N_A = floor(size(spike_matrix,2)/n_A);
Ap = zeros(num_canais,N_A);
tic
for i1 = 1:num_canais
    for i2 = 1:N_A-1
        SOMA1 = 0;
        b = 1;
        for j1 = ((i1-1)*N_neurons_pop + 1):((i1-1)*N_neurons_pop + N_neurons_pop)  
            SOMA2 = 0;
            for j2 = ((i2-1)*n_A + 1):((i2-1)*n_A + n_A)
                SOMA2 = SOMA2 + spike_matrix(j1,j2); 
            end
            SOMA1 = SOMA1 + Wn(b)*SOMA2;
            b = b + 1;
        end
        Ap(i1,i2) = SOMA1/(N_neurons_pop*dtn_A);
    end
end
toc

toc


end
            






