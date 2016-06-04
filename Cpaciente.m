classdef Cpaciente < handle 
    % Classe para extração das informações e dados de pacientes
    
    properties (Access = public)
        arquivo_dat = './dados_pacientes/p_cochlear_padrao' % Arquivo .dat com dados do paciente
%         quantidade_media = 10 % quantidade_media de pacientes a ser considerada
%         excluir_media = [7 8] % Exclusao de alguns pacientes
        modelo_arquivo_cochlear = './dados_pacientes/p_cochlear_' % Modelo do arquivo de dados para pacientes da cochlear       
%         paciente_cochlear_media_matriz
%         paciente_cochlear_media_vetor                     
        empresa % Empresa que produz o dispositivo utilizado pelo paciente
        estrategia % Estrategia de processamento do IC
        num_canais = 16 % Numero de canais do IC
        maxima % Selecao de n (maxima) canais por frame
        interphase_gap % Intervalo entre as partes positiva e negativa do pulso
        largura_pulso1 % Largura do pulso 1 (meia onda 1 sem contar o interphase gap)
        largura_pulso2 % Largura do pulso 2 (meia onda 2 sem contar o interphase gap)
        fat_comp = 0.6 % fator de compressao (expoente para a lei da potencia)
        T_SPL = 25 % NPS referente ao valor do limiar
        C_SPL = 65 % NPS referente ao valor do maximo conforto
        T_Level  % Limiar da amplitude de corrente por banda
        C_Level % Maximo conforto para amplitude de corrente por banda
        inf_freq % Frequencias inferiores do banco de filtros
        sup_freq % Frequencias superiores do banco de filtros
        
    end
    
    properties (Dependent)
        central_freq % Frequencias centrais do banco de filtros
        bandas_freq_entrada % Largura das bandas do banco de filtros
    end
    
    methods 
        function objeto = Cpaciente(prop1)%,prop2,prop3)
            if nargin == 1
                objeto.arquivo_dat = prop1;               
                objeto.empresa = dlmread(prop1,'\t',[3 2 3 2]);
                objeto.num_canais = max(dlmread(prop1,'\t',[15 0 36 0]));
                objeto.maxima = dlmread(prop1,'\t',[3 1 3 1]);
                objeto.interphase_gap = mean(dlmread(prop1,'\t',[4 1 4 1]))*1e-6;
                objeto.largura_pulso1 = mean(dlmread(prop1,'\t',[15 7 36 7]))*1e-6;
                objeto.largura_pulso2 = mean(dlmread(prop1,'\t',[15 7 36 7]))*1e-6; 
                objeto.T_SPL = dlmread(prop1,'\t',[8 1 8 1]);
                objeto.C_SPL = dlmread(prop1,'\t',[9 1 9 1]);
                objeto.T_Level = dlmread(prop1,'\t',[15 3 36 3]);
                objeto.C_Level = dlmread(prop1,'\t',[15 4 36 4]);
                objeto.inf_freq = dlmread(prop1,'\t',[15 9 36 9]);
                objeto.sup_freq = dlmread(prop1,'\t',[15 10 36 10]);
                
                
                a = dlmread(objeto.arquivo_dat,'\t',[7 1 7 1]);           

                    if a == 20
                        val = 0.24;
                    elseif a == 30
                        val = 0.3;
                    elseif a == 40
                        val = 0.51;
                    elseif a == 50
                        val = 0.6;   
                    else
                        error('Valor desconhecido do fator de compressao')
                    end
                    
                objeto.fat_comp = val;               
            end
%             if nargin == 3
%                 objeto.arquivo_dat = prop1; 
%                 objeto.quantidade_media = prop2;               
%                 objeto.excluir_media = prop3;
%             end  

        

        end
%% GET     

          function val = get.bandas_freq_entrada(objeto)
                val = objeto.sup_freq - objeto.inf_freq;
          end
        
          function val = get.central_freq(objeto)
                val = (objeto.sup_freq + objeto.inf_freq)./2;
          end
%         function val = get.paciente_cochlear_media_matriz(objeto)    
%             [val, ~] = media_paciente_cochlear(objeto.quantidade_media,objeto.modelo_arquivo_cochlear,objeto.excluir_media);
%         end     

%         function val = get.paciente_cochlear_media_vetor (objeto)    
%             [~, val] = media_paciente_cochlear(objeto.quantidade_media,objeto.modelo_arquivo_cochlear,objeto.excluir_media);
%         end 
        

        
%% BLOCOS

%         function media_paciente(objeto)
%             if strcmp(objeto.empresa,'Cochlear')
%             [objeto.paciente_cochlear_media_matriz, ~] = media_paciente_cochlear(objeto.quantidade_media,objeto.modelo_arquivo_cochlear,objeto.excluir_media);
%             else
%                 error('Dados de pacientes de outras empresas ainda não foram adicionados')
%             end
%         end
    end       
end

