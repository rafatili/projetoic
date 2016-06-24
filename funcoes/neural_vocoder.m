function audio = neural_vocoder(Ap,freq_amost,carrier,dtn_A,pos_eletrodo,baixa_freq,F0_HC,df_HC,numhar_HC) 

%% Loudness Scalling

            freq = (2/(dtn_A));
            freq = ceil(freq_amost/(freq));
            
            for i = 1:size(Ap,1)      
                audio(i,:) = resample(Ap(i,:),freq,1);
                audio(i,:) = smooth(audio(i,:),10);
            end
            
            lt = 0.25;
            
            max_sr = max(max(audio));
            audio = audio/max_sr;

             for i = 1:size(audio,1)
                for j = 1:size(audio,2)
                    if audio(i,j) >= lt && audio(i,j) < 1                                         
                       audio(i,j) = (-log(1./audio(i,j) - 1) + 1)/6 + .01644; 
                    elseif audio(i,j)<lt
                       audio(i,j) = 0; 
                    else
                       audio(i,j) = 1; 
                    end
                end
             end                          
            
            
%% Vocoder
     
     dt = dtn_A/(2*freq);
     %dt = 1/freq_amost
     t_reconst = 0:dt:size(audio,2)*dt - dt;
     f1 = baixa_freq;       
     SOMA = zeros(size(audio,2),1)';            
     senos = zeros(size(audio));
     
switch(carrier)     
    case 'Senoidal'
            [~,~, cf] = cochlearFilterBank(freq_amost, size(audio,1), f1 , audio(1,:));
            for i = 1:size(audio,1)  
                senos(i,:) = sin(2*pi*cf(i).*t_reconst);
                SOMA = SOMA + senos(i,:).*audio(i,:);
            end          
                audio = 0.25*SOMA/max(SOMA);
                
                
    case 'Ruido'
            Ruido = randn(size(audio,2),1);  % gera ruido branco
            Ruido = Ruido - median(Ruido); % força que a media seja = 0
            Ruido = Ruido/max(abs(Ruido)); % normaliza entre -1 e 1                  

            Bandas = cochlearFilterBank(freq_amost, size(audio,1), f1 , Ruido);            
            Audio_bandas = Bandas.*audio;     
            Audio_out = zeros(size(audio,2),1)';
            for i = 1:size(audio,1) % Composicao de todas as bandas de audio
                Audio_out = Audio_out + Audio_bandas(i,:);
            end

            OutMax = max(Audio_out);     % igual ao do sinal de entrada.
            audio = 0.25*Audio_out/max(OutMax);  
            
    case 'HC'
       
            fh = F0_HC:df_HC:numhar_HC*df_HC;
            SOMA = 0;
            for i = 1:length(fh)
               SOMA = SOMA + sin(2*pi*fh(i).*t_reconst + 2*pi*rand(1));
            end

            f1 = 165.4*(10^(0.06*(33-max(pos_eletrodo))-1));
            Bandas = cochlearFilterBank(freq_amost, size(audio,1), f1 , SOMA);
            Audio_bandas = Bandas.*audio;     
            Audio_out = zeros(size(audio,2),1)';
            for i = 1:size(audio,1) % Composicao de todas as bandas de audio
                Audio_out = Audio_out + Audio_bandas(i,:);
            end

            OutMax = max(Audio_out);     % igual ao do sinal de entrada.
            audio = 0.25*Audio_out/max(OutMax); 
end
            






