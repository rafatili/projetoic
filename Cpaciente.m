classdef Cpaciente
    % Classe para extração das informações e dados de pacientes
    
    properties
        arquivo_dat
        quantidade = 10
        modelo_arquivo = './dados_pacientes/p'
        dados_medios
    end
    
    properties (Dependent)
        empresa
        estrategia
        numero_canais
        maxima
        inter_phase_gap
        largura_pulso
        T_SPL
        C_SPL
        loudness_exp
        T_corr
        C_corr
        lower_freq
        upper_freq
    end
    
    methods 
        function objeto = Cpaciente(prop1)
            if nargin == 1
                objeto.arquivo_dat = prop1;
            end
        end
%% GET       
        function empresa = get.empresa(objeto)
            empresa = dlmread(objeto.arquivo_dat,'\t',[3 2 3 2]);
        end
        
        function numero_canais = get.numero_canais(objeto)
            numero_canais = dlmread(objeto.arquivo_dat,'\t',[15 0 36 0]);
        end
        
        function T_corr = get.T_corr(objeto)
            T_corr = dlmread(objeto.arquivo_dat,'\t',[15 3 36 3]);
        end
        
        function C_corr = get.C_corr(objeto)
            C_corr = dlmread(objeto.arquivo_dat,'\t',[15 4 36 4]);
        end
        
        function lower_freq = get.lower_freq(objeto)
            lower_freq = dlmread(objeto.arquivo_dat,'\t',[15 9 36 9]);
        end
        
        function upper_freq = get.upper_freq(objeto)
            upper_freq = dlmread(objeto.arquivo_dat,'\t',[15 10 36 10]);
        end
        
        function largura_pulso = get.largura_pulso(objeto)
            largura_pulso = dlmread(objeto.arquivo_dat,'\t',[15 7 36 7]);
        end
        
        function maxima = get.maxima(objeto)
            maxima = dlmread(objeto.arquivo_dat,'\t',[3 1 3 1]);
        end
        
        function inter_phase_gap = get.inter_phase_gap(objeto)
            inter_phase_gap = dlmread(objeto.arquivo_dat,'\t',[4 1 4 1]);
        end
        
        function loudness_exp = get.loudness_exp(objeto)
            
            a = dlmread(objeto.arquivo_dat,'\t',[7 1 7 1]);
            
            if a == 20
            loudness_exp = 0.24;
            elseif a == 30
            loudness_exp = 0.3;
            elseif a == 40
            loudness_exp = 0.51;
            elseif a == 50
            loudness_exp = 0.6;   
            else
            loudness_exp = a;
            end
            
        end
        
        function T_SPL = get.T_SPL(objeto)
            T_SPL = dlmread(objeto.arquivo_dat,'\t',[8 1 8 1]);
        end
        
        function C_SPL = get.C_SPL(objeto)
            C_SPL = dlmread(objeto.arquivo_dat,'\t',[9 1 9 1]);
        end
    %% OUTRAS
    
%     function media(objeto)
%         for i=1:objeto.quantidade
%             if i~=7 || i~=8
%             A = strcat(objeto.modelo_arquivo,num2str(i));
%             B = '.dat';
%             M(i,:) = dlmread(strcat(A,B),'\t',[15 3 36 3]);      
%             end
%         end
%         mean(M)
%     end
        
    end
    
    
end

