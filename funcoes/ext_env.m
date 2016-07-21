function saida = ext_env(entrada,tipo,fcorte_fpb,freq_amost,ordem_fpb)
         
         switch tipo
             case 0 % Hilbert
                saida = abs(hilbert(entrada'))';
             case 1 % Retificacao
                saida = abs(entrada);
                w = 2*(fcorte_fpb/freq_amost);         
                [b,a] = butter(ordem_fpb,w);              
                for i = 1:size(entrada,1)            
                    max_env = max(saida(i,:));
                    saida(i,:) = abs(filter(b,a,saida(i,:)));
                    saida(i,:) = (max_env/max(saida(i,:))).*saida(i,:);
                end
              otherwise
                    error('Somente as seguintes opcoes: 0 - Hilbert / 1 - Retificacao');
         end
                         
end