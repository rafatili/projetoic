classdef Csinal_in < handle
    %Csinal_in: Classe que contem as caracteristicas do sinal de audio
    %   
    
    properties
        Tfile;      %arquivo de audio alvo
        Nfile;      %arquivo de audio de ruido
        SNRdB;      %relacao sinal ruido
        fs;         %frequencia de amostragem
        
        unit;       %unidade ?
        calib;      %fator de calibracao
        dim_rng;    %faixa dinamica em dB
        
        nbits = 9;  %numero de bits do conversor AD do implante       
        nmics = 1;  %numero de canais do sinal (numero de mics)
        
        Tang_hor = 0;   %angulo horizontal da fonte alvo em graus
        Tang_ver = 0;   %angulo vertical da fonte alvo em graus
        Nang_hor = 0;   %angulo horizontal da fonte de ruido em graus
        Nang_ver = 0;   %angulo vertical da fonte de ruido em graus
    end
    
    properties (Dependent)
        SNR
    end 
    
    methods
        function obj=Csinal_in()
        end
        
        function snr=get.SNR(obj)
            snr=db2lin(obj.SNRdB);
        end
    end
    
end

