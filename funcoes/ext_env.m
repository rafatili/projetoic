function saida = ext_env(entrada,tipo,fcorte_fpb,freq_amost,ordem_fpb)
         
         if strcmp(tipo,'Hilbert') == 1
         saida = abs(hilbert(entrada'))';
         elseif strcmp(tipo,'Retificacao') == 1
         saida = abs(entrada);
         end
         
         w = 2*(fcorte_fpb/freq_amost);         
         [b,a] = butter(ordem_fpb,w);         
         %saida = filter(b,a,saida);
         
end