function saida = vocoder_neuro(Ap,dtn_A,freq_amost,pos_eletrodo)
            freq = (1/dtn_A);
            freq = round(freq_amost/(freq));
            size(Ap)
            
            for i = 1:size(Ap,1)      
                saida(i,:) = resample(Ap(i,:),freq,1);
            end
%             for i=1:size(saida,1)
%             saida(i,:) = smooth(saida(i,:),100);
%             end
            size(saida)
            
            dt = dtn_A/freq;
            t_reconst = 0:dt:size(saida,2)*dt-dt;
            
            SOMA = 0;
            senos = zeros(size(saida));
            
            for i = 1:size(saida,1)  
                f_coclea = 165.4*(10^(0.06*(33-pos_eletrodo(i)))-1);
                senos(i,:) = sin(2*pi*f_coclea.*t_reconst + random('norm',0,-pi/6));
                SOMA = SOMA + senos(i,:).*saida(i,:);
            end
            saida = 0.1*SOMA/max(SOMA);

end