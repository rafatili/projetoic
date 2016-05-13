function saida = comp(entrada,fat_comp,amp_corr_C,amp_corr_T)
          
            saida = zeros(size(entrada));
            
            for i = 1:size(entrada,1)             
                entrada(i,:) = entrada(i,:)/max(max(entrada));
                saida(i,:) = entrada(i,:).^fat_comp;                                               
                saida(i,:) = saida(i,:)*(amp_corr_C(i)-amp_corr_T(i)) + amp_corr_T(i) - 1;
                for j = 1:size(saida,2)
                    if saida(i,j) < amp_corr_T(i)
                        saida(i,j) = 0;
                    elseif saida(i,j) > amp_corr_C(i)
                        saida(i,j) = amp_corr_C(i);
                    end                                   
                end
                saida(i,:) = floor(saida(i,:));
            end           
end