function onda = calcOndas( pulsos, freq2, tipo, largura, interfase, tempo)
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
        Lpos=floor(largura*freq2);
        Lneg=Lpos;
        Lgap=floor(interfase*freq2);
        Lt=Lpos+Lneg+Lgap;

        %% gera pulso básico
        Pbase=[ones(1,Lpos), zeros(1,Lgap), -1*ones(1,Lneg)];
        plot(Pbase,'*')
        
        %% gera as ondas
        [Ltime, ~] = size(pulsos);
        time=pulsos(:,1);
        amp=pulsos(:,2);
        onda=zeros(1,length(tempo));
        for i=1:Ltime
            N=floor(time(i)*freq2)+1;
            onda(N:N+Lt-1)=amp(i)*Pbase;
        end
%         drawnow;
%         plot(onda)
%         pause(10)
    otherwise
        error('Apenas implementado para pulso tipo Bifasico simetrico')
end
end


