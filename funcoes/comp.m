function saida = comp(entrada,fat_comp,C_Level,T_Level)
          
            saida = zeros(size(entrada));
            
            for i = 1:size(entrada,1)             
                entrada(i,:) = entrada(i,:)/max(max(entrada));
                saida(i,:) = entrada(i,:).^fat_comp;                                               
                saida(i,:) = saida(i,:)*(C_Level(i)-T_Level(i)) + T_Level(i) - 1;
                for j = 1:size(saida,2)
                    if saida(i,j) < T_Level(i)
                        saida(i,j) = 0;
                    elseif saida(i,j) > C_Level(i)
                        saida(i,j) = C_Level(i);
                    end                                   
                end
                saida(i,:) = floor(saida(i,:));
            end           
end