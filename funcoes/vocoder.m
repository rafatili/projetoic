function saida = vocoder(entrada,freq_amost,tipo_vocoder,bandwidths_in,upper_freq,lower_freq,vet_tempo)
    if strcmp(tipo_vocoder,'Ruido') == 1
       
       Ruido = randn(size(entrada,2),1);  % gera ruido branco
       Ruido = Ruido - median(Ruido); % força que a media seja = 0
       Ruido = Ruido/max(abs(Ruido)); % normaliza entre -1 e 1       

       Bandas = CIFilterBank(freq_amost, size(entrada,1), 150, Ruido, bandwidths_in);
       
    elseif strcmp(tipo_vocoder,'Senoidal') == 1
       
       for i = 1:size(entrada,1)
           center_freq = (upper_freq(i) + lower_freq(i))/2;
           Bandas(i,:) = sin(2*pi*center_freq.*vet_tempo)';
       end
       Bandas = flipud(Bandas);
    else
        disp('Processo cancelado.');
        error('Erro: Tipo de sintese invalido. Opcoes disponiveis: Ruido, Senoidal ')
    end
        
       Audio_bandas = Bandas.*entrada;     
       Audio_out = zeros(size(entrada,2),1)';
       for i = 1:size(entrada,1) % Composicao de todas as bandas de audio
            Audio_out = Audio_out + Audio_bandas(i,:);
       end
        
       InMax = max(max(entrada)); % Normalizacao: volume maximo do sinal sintetizado
       OutMax = max(Audio_out);     % igual ao do sinal de entrada.
       saida = Audio_out*max(InMax)/max(OutMax);

end