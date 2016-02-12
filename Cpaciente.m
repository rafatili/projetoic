classdef Cpaciente < handle
    % Classe para extração das informações e dados de pacientes
    
    properties
        arquivo_dat = 'padrao' % Arquivo .dat com dados do paciente
        quantidade_media = 10 % quantidade_media de pacientes a ser considerada
        excluir_media = [7 8] % Exclusao de alguns pacientes
        modelo_arquivo_cochlear = './dados_pacientes/p_cochlear_' % Modelo do arquivo de dados para pacientes da cochlear       
        paciente_cochlear_media_matriz
        paciente_cochlear_media_vetor         
    end
    
    properties (Dependent)            
        empresa
        estrategia
        num_canais
        maxima
        interphase_gap
        largura_pulso
        T_SPL
        C_SPL
        fat_comp
        amp_corr_T
        amp_corr_C
        inf_freq
        sup_freq
        central_freq
        bandas_freq_entrada
    end
    
    methods 
        function objeto = Cpaciente(prop1,prop2,prop3)
            if nargin == 1
                objeto.arquivo_dat = prop1;               
            end
            if nargin == 3
                objeto.arquivo_dat = prop1; 
                objeto.quantidade_media = prop2;               
                objeto.excluir_media = prop3;
            end            
        end
%% GET       
        function paciente_cochlear_media_matriz = get.paciente_cochlear_media_matriz(objeto)    
            [A, ~] = media_paciente_cochlear(objeto.quantidade_media,objeto.modelo_arquivo_cochlear,objeto.excluir_media);
            paciente_cochlear_media_matriz = A;
        end     

        function paciente_cochlear_media_vetor = get.paciente_cochlear_media_vetor (objeto)    
            [~, B] = media_paciente_cochlear(objeto.quantidade_media,objeto.modelo_arquivo_cochlear,objeto.excluir_media);
            paciente_cochlear_media_vetor  = B;
        end 
        
        function empresa = get.empresa(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            empresa = 'Cochlear'; 
            else
            empresa = dlmread(objeto.arquivo_dat,'\t',[3 2 3 2]); 
            end
        end
        
        function num_canais = get.num_canais(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            num_canais = objeto.paciente_cochlear_media_vetor(1);
            else
            num_canais = dlmread(objeto.arquivo_dat,'\t',[15 0 36 0]);
            end
        end
        
        function amp_corr_T = get.amp_corr_T(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            amp_corr_T = objeto.paciente_cochlear_media_matriz(:,3);
            else
            amp_corr_T = dlmread(objeto.arquivo_dat,'\t',[15 3 36 3]);
            end
        end
        
        function amp_corr_C = get.amp_corr_C(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            amp_corr_C = objeto.paciente_cochlear_media_matriz(:,4);
            else
            amp_corr_C = dlmread(objeto.arquivo_dat,'\t',[15 4 36 4]);
            end
        end
        
        function inf_freq = get.inf_freq(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            inf_freq = objeto.paciente_cochlear_media_matriz(:,9);
            else
            inf_freq = dlmread(objeto.arquivo_dat,'\t',[15 9 36 9]);
            end
        end
        
        function sup_freq = get.sup_freq(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            sup_freq = objeto.paciente_cochlear_media_matriz(:,10);
            else
            sup_freq = dlmread(objeto.arquivo_dat,'\t',[15 10 36 10]);
            end
        end
        
        function bandas_freq_entrada = get.bandas_freq_entrada(objeto)
            bandas_freq_entrada = objeto.sup_freq - objeto.inf_freq;
        end
        
        function central_freq = get.central_freq(objeto)
            central_freq = (objeto.sup_freq + objeto.inf_freq)./2;
        end
        
        function largura_pulso = get.largura_pulso(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            largura_pulso = mean(objeto.paciente_cochlear_media_matriz(:,7));
            else
            largura_pulso = dlmread(objeto.arquivo_dat,'\t',[15 7 36 7]);
            end
        end
        
        function maxima = get.maxima(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            maxima = ceil(objeto.paciente_cochlear_media_vetor(2));
            else
            maxima = dlmread(objeto.arquivo_dat,'\t',[3 1 3 1]);
            end
        end
        
        function interphase_gap = get.interphase_gap(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            interphase_gap = objeto.paciente_cochlear_media_vetor(3);
            else
            interphase_gap = dlmread(objeto.arquivo_dat,'\t',[4 1 4 1]);
            end
        end
        
        function fat_comp = get.fat_comp(objeto)            
            if strcmp(objeto.arquivo_dat,'media') == 1
            a = objeto.paciente_cochlear_media_vetor(6);
            else
            a = dlmread(objeto.arquivo_dat,'\t',[7 1 7 1]);           
            end

            if a == 20
            fat_comp = 0.24;
            elseif a == 30
            fat_comp = 0.3;
            elseif a == 40
            fat_comp = 0.51;
            elseif a == 50
            fat_comp = 0.6;   
            else
            error('Valor desconhecido do fator de compressao')
            end           
        end
        
        function T_SPL = get.T_SPL(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            T_SPL = objeto.paciente_cochlear_media_vetor(7);
            else
            T_SPL = dlmread(objeto.arquivo_dat,'\t',[8 1 8 1]);
            end
        end
        
        function C_SPL = get.C_SPL(objeto)
            if strcmp(objeto.arquivo_dat,'media') == 1
            C_SPL = objeto.paciente_cochlear_media_vetor(8);
            else
            C_SPL = dlmread(objeto.arquivo_dat,'\t',[9 1 9 1]);
            end
        end
        
%% BLOCOS

        function media_paciente(objeto)
            if strcmp(objeto.empresa,'Cochlear')
            [objeto.paciente_cochlear_media_matriz, ~] = media_paciente_cochlear(objeto.quantidade_media,objeto.modelo_arquivo_cochlear,objeto.excluir_media);
            else
                error('Dados de pacientes de outras empresas ainda não foram adicionados')
            end
        end
    end       
end

