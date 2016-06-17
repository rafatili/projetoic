function saida = vocoder(entrada,freq_amost,tipo_vocoder,upper_freq,lower_freq,vet_tempo)      

    switch(tipo_vocoder)
       
       case 'Ruido'
       Ruido = randn(size(entrada,2),1);  % Gera ruido branco
       Ruido = Ruido - median(Ruido); % Media = 0
       Ruido = Ruido/max(abs(Ruido)); % Normaliza entre -1 e 1          
       f1 = 165.4*(10^(0.06*(33-22*0.75)-1)); % Funcao de Greenwood
       Bandas = cochlearFilterBank(freq_amost, size(entrada,1), f1 , Ruido); % Filtros Gammatone
       
        case 'Senoidal' 
        Bandas = zeros(size(entrada,1),length(vet_tempo));
        for i = 1:size(entrada,1)
           center_freq = (upper_freq(i) + lower_freq(i))/2; % Frequencias
           Bandas(i,:) = sin(2*pi*center_freq.*vet_tempo)';
        end
        Bandas = flipud(Bandas);
        
        case 'Harmonic Complex'        
        NH = 240;
        F0 = 100;
        fh = F0:F0:NH*F0;
        SOMA = 0;
        for i = 1:length(fh)
           SOMA = SOMA + sin(2*pi*fh(i).*vet_tempo + 2*pi*rand(1));
        end        
        Bandas = cochlearFilterBank(freq_amost, size(entrada,1), (upper_freq(1) + lower_freq(1))/2, SOMA);
   
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