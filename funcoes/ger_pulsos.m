function saida = ger_pulsos(entrada,num_canais,maxima,freq_amost,T_total,taxa_est,tipo_pulso,largura_pulso,interphase_gap,fase_pulso,atraso)

    if num_canais == maxima % Estrategia CIS            
            
            if strcmp(fase_pulso,'Catodico') == 1 
                fase = 1;
            elseif strcmp(fase_pulso,'Anodico') == 1
                fase = -1;
            end
                                    
            t = 0;
              
            if num_canais*taxa_est < freq_amost            
                for i = 1:num_canais
                    resamp(i,:) = resample(entrada(i,:), num_canais*taxa_est,freq_amost);               
                end
            elseif num_canais*taxa_est > freq_amost
                error('Erro: frequencia de amostragem menor do que o produto do numero de canais pela taxa de estimulacao!')
                stop
            else
                resamp = entrada;
            end
                
            saida = zeros(num_canais,2*T_total*taxa_est,2);
            
            size(resamp)               
            a = 1;

                for j = 1:num_canais:T_total*taxa_est*num_canais - num_canais + 2                   
                    n = 0;                         
                    for i = num_canais:-1:1                        
                        
                        if strcmp(tipo_pulso,'Bifasico') == 1                            
                            for k = 1:2
                                if k == 1
                                saida(i,a,:) = [t , fase*resamp(i,j + n)]; 
                                elseif k == 2
                                t = t + largura_pulso + interphase_gap;
                                saida(i,a + 1,:) = [t , -fase*resamp(i,j + n)];
                                end
                            end
                            t = t - (largura_pulso + interphase_gap) + 1/(num_canais*taxa_est);                       
                        end
                        
                        if atraso == 0
                           n = n + 1;
                        end                        
                    end                    
                    a = a + 2;
                end           
    else                
    error('Estrategia ACE ainda nao programada!') % Estrategia ACE            
    stop
    end
end