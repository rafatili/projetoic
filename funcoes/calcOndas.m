function [onda , pulso_amp] = calcOndas( pulsos, freq2, tipo, largura1, largura2, tempo)
%calcOndas retorna as ondas de corrente amostradas com frequência freq2
%onda = calcOndas( pulsos, freq2, tipo, largura, interfase, L)
%   onda: saida em amperes
%   pulsos: estrutura contendo o instante e amplitude do pulso
%   freq2: frequencia de amostragem da onda de corrente
%   tipo: tipo de pulso
%   largura: largura da primeira fase do pulso
%   interfase: tempo entre fases positiva e negativa do pulso
%   tempo: vetor de tempo

switch(tipo)
    case 'Bifasico'
        %% para pulsos bifásicos
        L1 = floor(largura1*freq2);
        L2 = floor(largura2*freq2);
%         L1 = 1;
%         L2 = 2;

        %% gera pulso básico
        Pbase1 = ones(1,L1);
        Pbase2 = ones(1,L2);
        
        %% gera as ondas
        [Ltime, ~] = size(pulsos);
        time = pulsos(:,1);
        amp = pulsos(:,2);
        onda = zeros(1,length(tempo));
        pulso_amp = zeros(1,length(tempo));
        for i = 1:Ltime
            N = floor(time(i)*freq2)+1;                    
            if amp(i)<0
                onda(N:N+L1-1) = amp(i)*Pbase1;  
                pulso_amp(N:N+L1-1) = amp(i)*Pbase1;
%                   onda(N) = -amp(i)*Pbase1;  
%                   pulso_amp(N) = -amp(i)*Pbase1;
            elseif amp(i)>0
                onda(N:N+L2-1) = amp(i)*Pbase2;  
                pulso_amp(N:N+L2-1) = amp(i)*Pbase2;
            end
        end
%         drawnow;
%         plot(onda)
%         pause(10)
    otherwise
        error('Apenas implementado para pulso tipo Bifasico simetrico')
end
end


