function [CorrDist,Spike_matrix, V_mem, Ap,audio] = neural_vocoder(PulsosCorr,num_canais,freq_amost,freq2,corr_esp,tipo_vocoder,lambda)

%% Propriedades

N_neurons = 1000; % numero total de neuronios
N_neurons_pop = round(N_neurons/num_canais); % numero de neuronios por populacao
N_neurons = num_canais*N_neurons_pop;

% resistencia do neuronio [Ohms] | Distribuicao normal entre 1900MOhm e 2000MOhm como 99.7% do intervalo de confianca
R_max = 2000e6;  
R_min = 1900e6;
R_media = mean([R_max R_min]);
R_desv = abs(R_max - R_media)/3;
R = random('norm',R_media,R_desv,N_neurons,1);

% capacitancia [F] | Distribuicao normal entre 0.07pF e 0.5pF como 99.7% do intervalo de confianca
C_max = 0.5e-12;  
C_min = 0.07e-12;
C_media = mean([C_max C_min]);
C_desv = abs(C_max - C_media)/3;
C = random('norm',C_media,C_desv,N_neurons,1);

% periodo refratario [s] | Distribuicao normal entre 1us e 300us
dt_refrat_max = 330e-6;  
dt_refrat_min = 1e-6;
dt_refrat_media = mean([dt_refrat_max dt_refrat_min]);
dt_refrat_desv = abs(dt_refrat_max - dt_refrat_media)/3;
dt_refrat = random('norm',dt_refrat_media,dt_refrat_desv,N_neurons,1);

% potencial limiar [V] | Distribuicao normal entre -50mV e -36mV
V_thr_max = -36e-3;  
V_thr_min = -50e-3;
V_thr_media = mean([V_thr_max V_thr_min]);
V_thr_desv = abs(V_thr_max - V_thr_media)/3;
V_thr = random('norm',V_thr_media,V_thr_desv,N_neurons,1);

% potencial de membrana estacionario [V] | Distribuicao normal entre -80mV e -55mV
V_rest_max = -55e-3;  
V_rest_min = -80e-3;
V_rest_media = mean([V_rest_max V_rest_min]);
V_rest_desv = abs(V_rest_max - V_rest_media)/3;
V_rest = random('norm',V_rest_media,V_rest_desv,N_neurons,1);

% potencial de ruido [V] | Distribuicao normal entre -2mV e 2mV
V_ruido_max = 2e-3;  
V_ruido_min = -2e-3;
V_ruido_media = mean([V_ruido_max V_ruido_min]);
V_ruido_desv = abs(V_ruido_max - V_ruido_media)/3;
V_ruido = random('norm',V_ruido_media,V_ruido_desv,N_neurons,size(PulsosCorr,2));

pos_inicial = 0; % mm
dx_eletrodo = 1; % mm
pos_eletrodo = (dx_eletrodo + pos_inicial):dx_eletrodo:(num_canais*dx_eletrodo + pos_inicial);

comp_coclea = 24; % mm
dx_coclea = comp_coclea/N_neurons; % mm
x_coclea = 0:dx_coclea:comp_coclea-dx_coclea;
lambda = 2.4;

%% Distribuicao da corrente

%     for i = 1:size(PulsosCorr,1)
%         for j = 1:size(PulsosCorr,2)
% %             if PulsosCorr(i,j)>0 && PulsosCorr(i,j+1)==0
% %             PulsosCorr(i,j+1) = PulsosCorr(i,j); 
% %             end        
%               if PulsosCorr(i,j)<0 
%                  PulsosCorr(i,j) = 0; 
%               end        
%         end
%     end

CorrDist = zeros(length(x_coclea),size(PulsosCorr,2));

switch(corr_esp)
    case 'Exp'
    for i = 1:size(PulsosCorr,2)
        for j = 1:size(PulsosCorr,1)
            if PulsosCorr(j,i)>0       
                CorrDist(:,i) = PulsosCorr(j,i)*exp(-abs(pos_eletrodo(j)-x_coclea)/lambda);
            end
        end
    end
    case 'Gauss'
    for i = 1:size(PulsosCorr,2)
        for j = 1:size(PulsosCorr,1)
            if PulsosCorr(j,i)>0 
                A = normpdf(x_coclea,pos_eletrodo(j),PulsosCorr(j,i)*1e3);
                CorrDist(:,i) = PulsosCorr(j,i)*A/(0.4e-3);
                CorrDist(:,i) = PulsosCorr(j,i)*CorrDist(:,i);
            end
        end 
    end
end

%% Leaky Integrate and Fire

V_mem = zeros(size(CorrDist));
for i = 1:size(CorrDist,2)
    for j = 1:size(CorrDist,1)
        V_mem(j,i) = V_rest(j); % potencial de membrana inicial
    end
end
Spike_matrix = zeros(size(CorrDist)); % matriz de spikes
an = zeros(size(CorrDist,1));
R_canal = 5e3; % resistencia dos canais do implante

dt = 1/freq2;
tic
for i = 2:size(CorrDist,2)
    for j = 1:size(CorrDist,1)
            if an(j)==0                
                tau = R(j)*C(j);            
                V_mem(j,i) = V_mem(j,i-1) + (dt/tau)*(-(V_mem(j,i-1) - V_rest(j)) + R_canal*CorrDist(j,i)) + V_ruido(j,i);                       
                if V_mem(j,i) >= V_thr(j)
                    Spike_matrix(j,i) = 1;
                    an(j) = 1;
                    V_mem(j,i) = V_rest(j);
                end
                
            else
                if dt_refrat(j)<an(j)*dt
                tau = R(j)*C(j);
                V_mem(j,i) = V_mem(j,i-1) + (dt/tau)*(-(V_mem(j,i-1) - V_rest(j)) + R_canal*CorrDist(j,i)) + V_ruido(j,i);                       
                    if V_mem(j,i) >= V_thr(j)
                        Spike_matrix(j,i) = 1;
                        an(j) = 1;
                        V_mem(j,i) = V_rest(j);
                    end 
                else
                    an(j) = an(j) + 1;
                end
            end

    end
end
toc
%% Somatório de potenciais de ação (spikes/s)


W = 1:N_neurons_pop;
Wn = pdf('norm',W,mean(W),1);
Wn = Wn/max(Wn);
dtn_A = 35e-3;
n_A = ceil(dtn_A*freq2);
N_A = round(size(Spike_matrix,2)/n_A);

% versao 1

% tic
% for i = 1:size(Spike_matrix,2)
%     for j = 1:num_canais
%         SOMA = 0;
%         b = 1;
%         for k = ((j-1)*N_neurons_pop + 1):((j-1)*N_neurons_pop + N_neurons_pop)
%             SOMA = SOMA + Wn(b)*Spike_matrix(k,i); 
%             b = b + 1;
%         end
%         Ap1(j,i) = ceil(SOMA);
%     end
% end
% 
% 
% 
% for i = 1:size(Ap1,1)
%     for j = 1:N_A-1
%         SOMA = 0;
%         for k = ((j-1)*n_A + 1):((j-1)*n_A + n_A)
%             SOMA = SOMA + Ap1(i,k); 
%         end
%         Ap(i,j) = SOMA;
%     end
% end
% Ap = ceil(Ap/(N_neurons_pop*dtn_A));
% toc

% versao 2

% tic
% 
% for i = 1:N_A-1
%     SOMA = 0;
%     for j = ((i-1)*n_A + 1):((i-1)*(n_A) + n_A)
%                 SOMA = SOMA + Spike_matrix(i,j); 
%     end
%     Ap1(i,j) = SOMA;
% end
% 
% 
% for j = 1:size(Ap1,1)
%         SOMA = 0;
%         b = 1;
%         for k = ((j-1)*N_neurons_pop + 1):((j-1)*N_neurons_pop + N_neurons_pop)
%             SOMA = SOMA + Wn(b)*Ap1(j,k); 
%             b = b + 1;
%         end
%         Ap(j,k) = ceil(SOMA/(N_neurons_pop*dtn_A));
% end
% toc


% versao 3

tic
for i1 = 1:num_canais
    for i2 = 1:N_A-1
        SOMA1 = 0;
        b = 1;
        for j1 = ((i1-1)*N_neurons_pop + 1):((i1-1)*N_neurons_pop + N_neurons_pop)  
            SOMA2 = 0;
            for j2 = ((i2-1)*n_A + 1):((i2-1)*n_A + n_A)
                SOMA2 = SOMA2 + Spike_matrix(j1,j2); 
            end
            SOMA1 = SOMA1 + Wn(b)*SOMA2;
            b = b + 1;
        end
        Ap(i1,i2) = SOMA1/(N_neurons_pop*dtn_A);
    end
end
toc

% versao 4

% W = 1:N_neurons;
% Wn = pdf('norm',W,mean(W),1);
% Wn = Wn/max(Wn);


% Ap = zeros(N_neurons,N_A);
% tic
% for i1 = 1:N_neurons   
%     for i2 = 1:N_A-1 
%             SOMA2 = 0;
%             for j2 = ((i2-1)*n_A + 1):((i2-1)*n_A + n_A)
%                 SOMA2 = SOMA2 + Spike_matrix(i1,j2); 
%             end
%         Ap(i1,i2) = ceil(SOMA2/(dtn_A));
%     end
% end


toc

%% Vocoder

            freq = (1/(dtn_A));
            freq_amost = 1*freq_amost;
            freq = round(freq_amost/(freq));
            
            for i = 1:size(Ap,1)      
                audio(i,:) = resample(Ap(i,:),freq,1);
                %audio(i,:) = smooth(audio(i,:),10);
            end
            lt = 0.25;
            
            max_sr = max(max(audio));
            audio = audio/max_sr;
            for i = 1:size(audio,1)
                for j = 1:size(audio,2)
                    if audio(i,j)>=lt && audio(i,j)<1                                         
                       audio(i,j) = (-log(1./audio(i,j) - 1) + 1)/6 + .01644;
                       %audio(i,j) = audio(i,j)^(1/0.6);
                    elseif audio(i,j)<lt
                       audio(i,j) = 0; 
                    else
                       audio(i,j) = 1; 
                    end
                end
            end
            
            dt = dtn_A/(freq);
            t_reconst = 0:dt:size(audio,2)*dt-dt;
            
            SOMA = 0;
            senos = zeros(size(audio));
            
switch(tipo_vocoder)
    case 'Senoidal'
            for i = 1:size(audio,1)  
                f_coclea = 165.4*(10^(0.06*(33-pos_eletrodo(i)))-1);
                senos(i,:) = sin(2*pi*f_coclea.*t_reconst + random('norm',0,-pi/6));
                SOMA = SOMA + senos(i,:).*audio(i,:);
            end
            
                audio = 0.25*SOMA/max(SOMA);
    case 'Ruido'
            Ruido = randn(size(audio,2),1);  % gera ruido branco
            Ruido = Ruido - median(Ruido); % força que a media seja = 0
            Ruido = Ruido/max(abs(Ruido)); % normaliza entre -1 e 1                  
            %bandwidths_in = [1000;875;750;625;625;500;500;375;375;250;250;250;250;125;125;125;125;125;125;125;125;125];
            %bandwidths_in = [1000;875;750;625;625;500;500;125;125;125;125;125;125;125;125;125;125;125;50;50;50;50];
            %df = 100;
            %bandwidths_in = df:df:(num_canais-1)*df;
            f1 = 165.4*(10^(0.06*(33-max(pos_eletrodo))-1));
            Bandas = cochlearFilterBank(freq_amost, size(audio,1), f1 , Ruido);%;, bandwidths_in);            
            %Bandas = CIFilterBank(freq_amost, size(audio,1), 150, Ruido, flipud(bandwidths_in));
            %Bandas = flipud(Bandas);
            Audio_bandas = Bandas.*audio;     
            Audio_out = zeros(size(audio,2),1)';
            for i = 1:size(audio,1) % Composicao de todas as bandas de audio
                Audio_out = Audio_out + Audio_bandas(i,:);
            end

            OutMax = max(Audio_out);     % igual ao do sinal de entrada.
            audio2 = Audio_out/max(OutMax);  
            
            for i = 1:size(audio,1)  
                f_coclea = 165.4*(10^(0.06*(33-pos_eletrodo(i)))-1);
                senos(i,:) = sin(2*pi*f_coclea.*t_reconst + random('norm',0,-pi/6));
                SOMA = SOMA + senos(i,:).*audio(i,:);
            end
            
            s = 0;
            audio = 0.25*(s*SOMA/max(SOMA)+(1-s)*audio2);
            
    case 'Harmonic Complex'
       
        NH = 240;
        F0 = 100;
        fh = F0:F0:NH*F0;
        SOMA = 0;
        for i = 1:length(fh)
           SOMA = SOMA + sin(2*pi*fh(i).*t_reconst + 2*pi*rand(1));
        end
        
        f1 = 165.4*(10^(0.06*(33-max(pos_eletrodo))-1));
            Bandas = cochlearFilterBank(freq_amost, size(audio,1), f1 , SOMA);%;, bandwidths_in);
            %Bandas = flipud(Bandas);
            Audio_bandas = Bandas.*audio;     
            Audio_out = zeros(size(audio,2),1)';
            for i = 1:size(audio,1) % Composicao de todas as bandas de audio
                Audio_out = Audio_out + Audio_bandas(i,:);
            end

            OutMax = max(Audio_out);     % igual ao do sinal de entrada.
            audio = 0.25*Audio_out/max(OutMax); 
end
            






