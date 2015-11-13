function saida = ext_env(entrada,tipo,fcorte_fpb,freq_amost,ordem_fpb)
         
         if strcmp(tipo,'Hilbert') == 1
            saida = abs(hilbert(entrada'))';
         elseif strcmp(tipo,'Retificacao') == 1
            saida = abs(entrada);
            w = 2*(fcorte_fpb/freq_amost);         
            [b,a] = butter(ordem_fpb,w);              
            for i = 1:size(entrada,1)            
                max_env = max(saida(i,:));
                saida(i,:) = abs(filter(b,a,saida(i,:)));
                saida(i,:) = (max_env/max(saida(i,:))).*saida(i,:);
            end
         end
                         
end