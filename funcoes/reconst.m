function [audio_reconst , env_seno , senos] = reconst(PulsosCorr,num_canais,fat_smooth,freq2)

pos_inicial = 5; % mm 
dx_eletrodo = 1; % mm
pos_eletrodo = (1 + pos_inicial):dx_eletrodo:(num_canais + pos_inicial);

comp_coclea = 33; % mm
dx_coclea = 0.1; % mm
x_coclea = 0:dx_coclea:comp_coclea;

SOMA = zeros(size(x_coclea));
size(SOMA)
size(x_coclea)
for j = 1:size(PulsosCorr,2)
    for i = 1:size(PulsosCorr,1)
        if PulsosCorr(i,j)>0
            A = normpdf(x_coclea,pos_eletrodo(i),PulsosCorr(i,j)*1e3)/0.4;
            SOMA = SOMA + PulsosCorr(i,j)*A;
        end 
    end
    env_seno(:,j) = SOMA;
    SOMA = zeros(size(x_coclea));
end

for i =1:size(env_seno,1)
   env_seno(i,:) = smooth(env_seno(i,:),fat_smooth);
end

dt_reconst = 1/freq2;
t_reconst = 0:dt_reconst:(size(PulsosCorr,2)-1)*dt_reconst;

SOMA = 0;
for i = 1:size(env_seno,1)
    f_coclea = 165.4*(10^(0.06*(33-x_coclea(i)))-1);
    senos(i,:) = sin(2*pi*f_coclea.*t_reconst);
    SOMA = SOMA + senos(i,:).*env_seno(i,:);
end
   audio_reconst = 0.5*SOMA/max(SOMA);
   %audiowrite('audio_reconst.wav',audio_reconst, freq2)
end