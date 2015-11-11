function [M, T] = media_paciente_cochlear(quantidade,modelo_arquivo_cochlear,excluir)
        n = 1;
        for i=1:quantidade
           if excluir(1:length(excluir))~=i
            A = strcat(modelo_arquivo_cochlear,num2str(i));
            B = '.dat';
            C(n,:,:) = dlmread(strcat(A,B),'\t',[15 1 36 10]);   
            D(n,:) = dlmread(strcat(A,B),'\t',[2 1 9 1]);
            n = n + 1;
           end
        end
        M(:,:) = mean(C);
        T = mean(D);
end