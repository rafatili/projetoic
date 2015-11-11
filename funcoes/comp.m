function saida = comp(entrada,fat_comp,quant_bits,amp_corr_C,amp_corr_T,max_corr)

            comp_range = 0:2^quant_bits-1;
            fat_comp = 0.6;
            comp_range = comp_range.^fat_comp;
            saida = zeros(size(entrada,1),size(entrada,2));
            max_ent = max(max(entrada));
            
            for i = 1:size(entrada,1)
                entrada(i,:) = entrada(i,:)*(2^quant_bits-1)/max_ent;
                saida(i,:) = quantiz(entrada(i,:), comp_range) - 1 + amp_corr_T(i);       
%                 %saida(i,:) = (amp_corr_C(i)/(2^quant_bits-1))*saida(i,:) + amp_corr_T(i);               
                for j = 1:size(saida,2)
                    if saida(i,j) == amp_corr_T(i)
                        %amp_corr_T(i)
                        saida(i,j) = 0;
                    elseif saida(i,j) > amp_corr_C(i)
                        saida(i,j) = amp_corr_C(i);
                    end
                    if saida(i,j) ~=0
                        saida(i,j) = (max_corr/(2^quant_bits-1))*log10(saida(i,j));
                    else
                        saida(i,j) = 0;
                    end
                end    
           end

            

            
end