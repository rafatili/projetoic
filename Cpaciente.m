classdef Cpaciente < handle 
    % Classe para extração das informações e dados de pacientes
    
    properties 
        arquivo_dat = './projetoic/dados_pacientes/p_cochlear_padrao' % Arquivo .dat com dados do paciente                       
        empresa = 'Cochlear' % Empresa que produz o dispositivo utilizado pelo paciente
        estrategia = 'ACE' % Estrategia de processamento do IC
        num_canais = 22 % Numero de canais do IC
        maxima = 8 % Selecao de n (maxima) canais por frame
        interphase_gap = 8e-6 % Intervalo entre as partes positiva e negativa do pulso
        largura_pulso1 = 25e-6 % Largura do pulso 1 (meia onda 1 sem contar o interphase gap)
        largura_pulso2 = 25e-6 % Largura do pulso 2 (meia onda 2 sem contar o interphase gap)
        fat_comp = 0.6 % fator de compressao (expoente para a lei da potencia)
        T_SPL = 25 % NPS referente ao valor do limiar
        C_SPL = 65 % NPS referente ao valor do maximo conforto
        T_Level = 100*ones(22,1) % Limiar da amplitude de corrente por banda
        C_Level = 200*ones(22,1) % Maximo conforto para amplitude de corrente por banda
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
                %objeto.empresa = dlmread(prop1,'\t',[3 2 3 2]);
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
        
        end
%% GET     

          function val = get.bandas_freq_entrada(objeto)
                val = objeto.sup_freq - objeto.inf_freq;
          end
        
          function val = get.central_freq(objeto)
                val = (objeto.sup_freq + objeto.inf_freq)./2;
          end
                  
        
%% BLOCOS

        function media_paciente(objeto,quantidade_media,excluir_media)
            if strcmp(objeto.empresa,'Cochlear')
            media_paciente_cochlear(quantidade_media,'./projetoic/dados_pacientes/p_cochlear_',excluir_media);
            else
                error('Dados de pacientes de outras empresas ainda não foram adicionados')
            end
        end
    end       
end

