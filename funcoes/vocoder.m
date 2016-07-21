function saida = vocoder(entrada,freq_amost,carrier,baixa_freq,vet_tempo,F0_HC,df_HC,numhar_HC)      
    
    %f1 = 165.4*(10^(0.06*(33-max(pos_eletrodo)))-1); % Funcao de Greenwood
    f1 = baixa_freq;
    
    switch(carrier)
       
        case 0 % Ruido
        Ruido = randn(size(entrada,2),1);  % Gera ruido branco
        Ruido = Ruido - median(Ruido); % Media = 0
        Ruido = Ruido/max(abs(Ruido)); % Normaliza entre -1 e 1          
        
        Bandas = cochlearFilterBank(freq_amost, size(entrada,1), f1 , Ruido); % Filtros Gammatone
       
        case 1 % Senoidal 
        Bandas = zeros(size(entrada,1),length(vet_tempo));
        [~,~, cf] = cochlearFilterBank(freq_amost, size(entrada,1), f1 , entrada(1,:));
        for i = 1:size(entrada,1)
           Bandas(i,:) = sin(2*pi*cf(i).*vet_tempo)';
        end
        
        case 2 % HC        
        fh = F0_HC:df_HC:numhar_HC*df_HC;
        SOMA = 0;
        for i = 1:length(fh)
           SOMA = SOMA + sin(2*pi*fh(i).*vet_tempo + 2*pi*rand(1));
        end        
        Bandas = cochlearFilterBank(freq_amost, size(entrada,1), f1, SOMA);
        
        otherwise
            error('Somente as seguintes opcoes: 0 - Ruido / 1 - Senoidal / 2 - HC');
   
    end
        
       Audio_bandas = Bandas.*entrada;     
       Audio_out = zeros(size(entrada,2),1)';
       for i = 1:size(entrada,1) % Composicao de todas as bandas de audio
            Audio_out = Audio_out + Audio_bandas(i,:);
       end
        
       InMax = max(max(entrada)); % Normalizacao: volume maximo do sinal sintetizado
       OutMax = max(Audio_out);     % Igual ao do sinal de entrada.
       saida = Audio_out*max(InMax)/max(OutMax);

end