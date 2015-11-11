classdef Cpaciente
    % Classe para extração das informações e dados de pacientes
    
    properties
        arquivo_dat = 'media' % Arquivo .dat com dados do paciente
        quantidade = 10 % Quantidade de pacientes a ser considerada
        excluir = [7 8] % Exclusao de alguns pacientes
        modelo_arquivo_cochlear = './dados_pacientes/p_cochlear_' % Modelo do arquivo de dados para pacientes da cochlear       
    end
    
    properties (Dependent)       
        paciente_cochlear_media
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
        bandwidths_in
    end
    
    methods 
        function objeto = Cpaciente(prop1,prop2,prop3)
            if nargin == 1
                objeto.arquivo_dat = prop1;               
            end
            if nargin == 3
                objeto.arquivo_dat = prop1; 
                objeto.quantidade = prop2;               
                objeto.excluir = prop3;
            end            
        end
%% GET       
        function paciente_cochlear_media = get.paciente_cochlear_media(objeto)    
            [A, B] = media_paciente_cochlear(objeto.quantidade,objeto.modelo_arquivo_cochlear,objeto.excluir);
            paciente_cochlear_media.dados1 = A;
            paciente_cochlear_media.dados2 = B;
        end     

        function empresa = get.empresa(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            empresa = 'Cochlear'; 
            else
            empresa = dlmread(objeto.arquivo_dat,'\t',[3 2 3 2]); 
            end
        end
        
        function numero_canais = get.numero_canais(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            numero_canais = paciente_cochlear_media.dados2(1);
            else
            numero_canais = dlmread(objeto.arquivo_dat,'\t',[15 0 36 0]);
            end
        end
        
        function T_corr = get.T_corr(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            T_corr = paciente_cochlear_media.dados1(:,3);
            else
            T_corr = dlmread(objeto.arquivo_dat,'\t',[15 3 36 3]);
            end
        end
        
        function C_corr = get.C_corr(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            C_corr = paciente_cochlear_media.dados1(:,4);
            else
            C_corr = dlmread(objeto.arquivo_dat,'\t',[15 4 36 4]);
            end
        end
        
        function lower_freq = get.lower_freq(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            lower_freq = paciente_cochlear_media.dados1(:,9);
            else
            lower_freq = dlmread(objeto.arquivo_dat,'\t',[15 9 36 9]);
            end
        end
        
        function upper_freq = get.upper_freq(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            upper_freq = paciente_cochlear_media.dados1(:,10);
            else
            upper_freq = dlmread(objeto.arquivo_dat,'\t',[15 10 36 10]);
            end
        end
        
        function bandwidths_in = get.bandwidths_in(objeto)
            bandwidths_in = objeto.upper_freq - objeto.lower_freq;
        end
        
        function largura_pulso = get.largura_pulso(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            largura_pulso = mean(paciente_cochlear_media.dados1(:,7));
            else
            largura_pulso = dlmread(objeto.arquivo_dat,'\t',[15 7 36 7]);
            end
        end
        
        function maxima = get.maxima(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            maxima = ceil(paciente_cochlear_media.dados2(2));
            else
            maxima = dlmread(objeto.arquivo_dat,'\t',[3 1 3 1]);
            end
        end
        
        function inter_phase_gap = get.inter_phase_gap(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            inter_phase_gap = paciente_cochlear_media.dados2(3);
            else
            inter_phase_gap = dlmread(objeto.arquivo_dat,'\t',[4 1 4 1]);
            end
        end
        
        function loudness_exp = get.loudness_exp(objeto)            
            if strcmp(objeto.arquivo_dat,'media') == 1
            a = paciente_cochlear_media.dados2(5);
            else
            a = dlmread(objeto.arquivo_dat,'\t',[7 1 7 1]);           
            end
            
            if a == 20
            loudness_exp = 0.24;
            elseif a == 30
            loudness_exp = 0.3;
            elseif a == 40
            loudness_exp = 0.51;
            elseif a == 50
            loudness_exp = 0.6;   
            else
            error('Valor desconhecido do fator de compressao')
            end           
        end
        
        function T_SPL = get.T_SPL(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            T_SPL = paciente_cochlear_media.dados2(7);
            else
            T_SPL = dlmread(objeto.arquivo_dat,'\t',[8 1 8 1]);
            end
        end
        
        function C_SPL = get.C_SPL(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            C_SPL = paciente_cochlear_media.dados2(8);
            else
            C_SPL = dlmread(objeto.arquivo_dat,'\t',[9 1 9 1]);
            end
        end
           
    end       
end

