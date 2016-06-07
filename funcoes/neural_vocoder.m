function audio = neural_vocoder(Ap,freq_amost,carrier,dtn_A,pos_eletrodo)

%% Loudness Scalling

            freq = (1/(dtn_A));
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
                       %audio(i,j) = audio(i,j)^(1/0.6);
                    elseif audio(i,j)<lt
                       audio(i,j) = 0; 
                    else
                       audio(i,j) = 1; 
                    end
                end
            end
            
            dt = dtn_A/freq;
            t_reconst = 0:dt:size(audio,2)*dt-dt;
            
            SOMA = 0;
            senos = zeros(size(audio));
            
%% Vocoder
            
switch(carrier)
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
            f1 = 165.4*(10^(0.06*(33-max(pos_eletrodo))-1));
            Bandas = cochlearFilterBank(freq_amost, size(audio,1), f1 , Ruido);%;, bandwidths_in);            
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
            Bandas = cochlearFilterBank(freq_amost, size(audio,1), f1 , SOMA);
            Audio_bandas = Bandas.*audio;     
            Audio_out = zeros(size(audio,2),1)';
            for i = 1:size(audio,1) % Composicao de todas as bandas de audio
                Audio_out = Audio_out + Audio_bandas(i,:);
            end

            OutMax = max(Audio_out);     % igual ao do sinal de entrada.
            audio = 0.25*Audio_out/max(OutMax); 
end
            






