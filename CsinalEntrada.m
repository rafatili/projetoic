%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% classe CsinalEntrada por Rafael Chiea %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef CsinalEntrada < handle
    %% CsinalEntrada classe responsavel pelo sinal de entrada
    %   Smescla = alvo + 1/SNR * ruido

    properties
        arqX; % Arquivo .wav associado ao sinal de interesse (alvo)
        arqR = 'sem_ruido'; % Arquivo .wav associado ao sinal de ruido, 'sem_ruido' = sinal limpo
        SNRdB = 0; % Relacao Sinal-Ruido (SNR) [dB]
        freq_amost = 16000; % Frequencia de amostragem do sinal de entrada
        DB_dir = 'sinais_entrada/'; %diretorio contendo a base de dados de audio
        ruido_dir ='ruidos/';   %subdiretorio contendo os arquivos de ruidos
        alvo_dir = ''; %subdiretorio contendo os arquivos alvo
        azmt_alvo = 0; % Angulo azimutal de posicao da fonte sonora (graus) {-180 : 5 : 180}
        elev_alvo = 0; % Angulo de elevacao da fonte sonora (graus) {-10 : 10 : 20}
        dist_alvo = 80; % Distancia da fonte = 80 cm a 300 cm
        azmt_ruido = 0; % Angulo azimutal de posicao da fonte de ruido (graus) multiplo de 5
        elev_ruido = 0; % Angulo de elevacao da fonte de ruido (graus) {-10 : 10 : 20}
        dist_ruido = 80; % Distancia da fonte de ruido = 80 cm a 300 cm
        lado = 'esquerda'; % Lado do IC: 'esquerda' ou 'direita'
    end

    properties(Access = private)
        PrvtSNR = Inf;
        Prvtalvo; % Dados do sinal da fonte
        Prvtruido = 0; % Dados do sinal de ruido
        PrvtSmescla; % Sinal de ruido
    end

    properties(Dependent)
        SNR;
        alvo; % Dados do sinal da fonte
        ruido; % Dados do sinal de ruido
        Smescla; % Sinal de ruido
    end

    methods
        function obj = CsinalEntrada(varargin)
            % varargin = {arquivo .wav de audio alvo, arquivo .wav do ruido, SNRdB}
            if isempty(varargin)
                return;
            end
            switch length(varargin)
                case 0 
                    return;
                case 1                    
                    obj.arqX = varargin{1};
                case 2
                    obj.arqX = varargin{1};
                    obj.arqR = varargin{2};
                case 3
                    obj.arqX = varargin{1};
                    obj.arqR = varargin{2};
                    obj.SNRdB = varargin{3};
                otherwise
                    error('O numero de argumentos deve ser menor ou igual a 3')
            end
        end
        %% Gets
        function val = get.SNR(obj)
            val = obj.PrvtSNR;
        end
        function val = get.alvo(obj)
            val = obj.Prvtalvo;
        end
        function val = get.ruido(obj)
            val = obj.Prvtruido;
        end
        function val = get.Smescla(obj)
            val = obj.PrvtSmescla;
        end
        %% Sets
        function set.arqX(obj,xf)
            if ischar(xf) && strcmp(xf(end-3: end), '.wav')
                obj.arqX = xf;
                obj.carregarAlvo();
                obj.mesclar();
            else
                error('arqX deve ser um arquivo .wav')
            end
        end
        function set.arqR(obj,nf)
            if ischar(nf) && (strcmp(nf(end-3: end), '.wav') || strcmp(nf,'sem_ruido'))
                obj.arqR = nf;
                obj.carregarRuido;
                obj.mesclar();
            else
                error('arqR deve ser um arquivo .wav')
            end
        end
        function set.SNRdB(obj,snrDB)
            if isnumeric(snrDB)
                obj.SNRdB = snrDB;
                obj.carregarSNR();
                obj.mesclar();
            else
                error('snrDB deve ser numerico')
            end
        end
        function set.freq_amost(obj,freq_amost)
            if isnumeric(freq_amost)
                obj.freq_amost = freq_amost;
                obj.carregarRuido();
                obj.carregarAlvo();
                obj.mesclar();
            else
                error('taxa de amostragem freq_amost deve ser numerico')
            end
        end

        function set.azmt_alvo(obj,angle)
            if mod(angle,5) == 0 || -180 < angle <= 180
                obj.azmt_alvo = angle;
            else
                error('o angulo deve ser numerico, entre -180 e 180, e multiplo de 5')
            end
            obj.carregarAlvo();
            obj.mesclar();
        end
        
        function set.elev_alvo(obj,angle)
            if mod(angle,10) == 0 || -10 <= angle <= 20
                obj.elev_alvo = angle;
            else
                error('o angulo deve ser numerico, entre -10 e 20, e multiplo de 10')
            end
            obj.carregarAlvo();
            obj.mesclar();
        end

        function set.dist_alvo(obj,dist)
            if dist == 80 || dist == 300
                obj.dist_alvo = dist;
            else
                error('a distancia deve ser 80 ou 300')
            end
            obj.carregarAlvo();
            obj.mesclar();
        end

        function set.azmt_ruido(obj,angle)
            if mod(angle,5) == 0 || -180 < angle <= 180
                obj.azmt_ruido = angle;
            else
                error('o angulo deve ser numerico, entre -180 e 180, e multiplo de 5')
            end
            obj.carregarRuido();
            obj.mesclar();
        end
        
        function set.elev_ruido(obj,angle)
            if mod(angle,10) == 0 || -10 <= angle <= 20
                obj.elev_ruido = angle;
            else
                error('o angulo deve ser numerico, entre -10 e 20, e multiplo de 10')
            end
            obj.carregarRuido();
            obj.mesclar();
        end

        function set.dist_ruido(obj,dist)
            if dist == 80 || dist == 300
                obj.dist_ruido = dist;
            else
                error('a distancia deve ser 80 ou 300')
            end
            obj.carregarRuido();
            obj.mesclar();
        end

        function set.lado(obj,sd)
            if strcmp(sd,'esquerda') || strcmp(sd,'direita')
                obj.lado = sd;
            else
                error('o lado dever ser "left" ou "right"')
            end
            obj.carregarRuido();
            obj.carregarAlvo();
            obj.mesclar;
        end
        %% funcoes
        function carregarAlvo(obj)
            path = strcat(obj.DB_dir,obj.alvo_dir,obj.arqX);
            [S, Fsmpl] = audioread(path);    %carega o sinal
            S = S - mean(S);
            if Fsmpl ~= obj.freq_amost;
                S = resample(S,obj.freq_amost,Fsmpl);
            end

            % Direcao da fonte
            IR = loadHRIR1('Anechoic', obj.dist_alvo, obj.elev_alvo, obj.azmt_alvo, 'front');
            HRIR = resample(IR.data,obj.freq_amost,IR.fs);
            in_lft = filter(HRIR(:,1),1,S);
            in_rgt = filter(HRIR(:,2),1,S);
            norm = .9/max(abs([in_lft ; in_rgt]));
            in_lft = norm*in_lft;
            in_rgt = norm*in_rgt;

            % Escolha do lado esquerdo/direito 
            switch obj.lado
                case 'esquerda'
                    Sin = in_lft;
                case 'direita'
                    Sin = in_rgt;
                otherwise
                    error('obj.lado deve ser "esquerda" ou "direita"')
            end
            obj.Prvtalvo = Sin;
        end

        function carregarRuido(obj)
            if strcmp(obj.arqR,'sem_ruido')
                obj.Prvtruido = 0;
                return;
            end
            path = strcat(obj.DB_dir,obj.ruido_dir,obj.arqR);
            [N, Fsmpl] = audioread(path);    %carrega o sinal
            N = N - mean(N);
            if Fsmpl ~= obj.freq_amost;
                N = resample(N,obj.freq_amost,Fsmpl);
            end

            % Direcao do ruido
            IR = loadHRIR1('Anechoic', obj.dist_ruido, obj.elev_ruido, obj.azmt_ruido, 'front');
            HRIR = resample(IR.data,obj.freq_amost,IR.fs);
            in_lft = filter(HRIR(:,1),1,N);
            in_rgt = filter(HRIR(:,2),1,N);
            norm = .9/max(abs([in_lft ; in_rgt]));
            in_lft = norm*in_lft;
            in_rgt = norm*in_rgt;

            % Escolha do lado esquerdo/direito 
            switch obj.lado
                case 'esquerda'
                    Nin = in_lft;
                case 'direita'
                    Nin = in_rgt;
                otherwise
                    error('obj.lado deve ser "esquerda" ou "direita"')
            end
            obj.Prvtruido = Nin;
        end

        function carregarSNR(obj)
            obj.PrvtSNR = 10^(obj.SNRdB/20);
        end

        function mesclar(obj)
            %mescla sinal de interesse + ruido
            if (isempty(obj.alvo) || isempty(obj.ruido) || isempty(obj.SNRdB))
                return;
            end

            if strcmp(obj.arqR,'sem_ruido')
                obj.PrvtSmescla = obj.alvo;
                return;
            end

            %% iguala os tamanhos
            Ls = length(obj.alvo);
            Ln = length(obj.ruido);


            if Ls > Ln
                rpt = fix(Ls/Ln);
                diff = rem(Ls,Ln);
                aux0 = floor(rand(1,1)*(Ln-diff));
                obj.Prvtruido = [repmat(obj.ruido,rpt,1);obj.ruido(aux0+1:aux0+diff)];
            else
                aux0 = floor(rand(1,1)*(Ln-Ls));
                obj.Prvtruido = obj.ruido(aux0+1:aux0+Ls);    %o arquivo de ruido e cortado aleatoriamente
            end
            %% mescla com a SNR determinada
            [obj.PrvtSmescla, obj.Prvtruido] = s_and_n(obj.alvo, obj.ruido, obj.SNRdB);
            maxim = max(abs(obj.PrvtSmescla));
            if maxim > 1
                obj.PrvtSmescla = obj.PrvtSmescla/maxim;
            end
        end

        function [srmr0,intel0] = intelsrmr(obj)
            if obj.freq_amost ~= 8000 && obj.freq_amost ~= 16000
                Fs1 = 16000;  %frequencia de amostragem para a funcao SRMR_CI
                Xf = resample(obj.Smescla,Fs1,obj.freq_amost);
                X = resample(obj.alvo,Fs1,obj.freq_amost);
            else
                Xf = obj.Smescla;
                X = obj.alvo;
                Fs1 = obj.freq_amost;
            end
            srmr0 = SRMR_CI(Xf,Fs1,'norm',1);

            %% calcula inteligibilidade
            SRMR_clean = SRMR_CI(X,Fs1,'norm',1);
            srmr_norm = srmr0/SRMR_clean;
            alpha = [-7.4535, 12.1742]'; %from Joao Santos thesis
            intel0 = 88.92./(1+exp(-(alpha(1)+alpha(2)*srmr_norm)));
        end

        function pesq0 = pesq_calc(obj)
            score = PESQa(obj.alvo,obj.Smescla,obj.freq_amost);
            pesq0 = score;
        end
        
        function reproduz_audio(obj, aux)
            if nargin==1    % se a funcao for chamada sem parametros de entrada
                aux='';     % atribui um valor qualquer a aux, para que seja reproduzido o sinal mesclado
            end
            switch(aux)
                case 'alvo'
                    sinal=obj.alvo;
                case 'ruido'
                    sinal=obj.ruido;
                case 'mescla'
                    sinal=obj.Smescla;
                otherwise
                    sinal=obj.Smescla;
                    warning('Warn:opcao_invalida',...
                    ['Opcao de reproducao invalida. Escolher entre ''alvo'', ''ruido'' ou '...
                    '''mescla''.\nReproduzindo o sinal de mescla: alvo + ruido.']);
            end
            ao=audioplayer(sinal, obj.freq_amost); %objeto de audio
            tempo=ao.TotalSamples/ao.SampleRate+.1; %tempo para reproducao
            play(ao);
            pause(tempo);   %necessario para que nao interrompa antes de reproduzir tudo
        end
    end
end
