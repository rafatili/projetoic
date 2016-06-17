%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CsinalEntrada class by Rafael Chiea %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef CsinalEntrada < handle
    %% CsinalEntrada classe responsavel pelo sinal de entrada
    %   Smix = target + 1/SNR * noise

    properties
        Xfile; % Arquivo .wav associado ao sinal da fonte
        Nfile = 'no_noise'; % Arquivo .wav file associated to noise signal, 'no_noise' = clean signal
        SNRdB = Inf; % Razao Sinal-Ruido (SNR) [dB]
        fs = 16000; % Frequencia de amostragem do sinal de entrada
        DB_dir %='CD_Loizou/Databases/';
        noise_dir %='Noise_Recordings/';
        speech_dir %='Speech/IEEE_corpus/wideband/';
        Tangle = 0; % Angulo de posicao da fonte sonora (graus) multiplo de 5
        Tdist = 80; % Distancia da fonte = 80 cm a 300 cm
        Nangle = 0; % Angulo de posicao da fonte de ruido (graus) multiplo de 5
        Ndist = 80; % Distancia da fonte de ruido = 80 cm a 300 cm
        side = 'left'; % Lado do IC: 'left' ou 'right'
    end

    properties(Access = private)
        PrvtSNR = Inf;
        Prvttarget; % Dados do sinal da fonte
        Prvtnoise = 0; % Dados do sinal de ruido
        PrvtSmix; % Sinal de ruido
    end

    properties(Dependent)
        SNR;
        target; % Dados do sinal da fonte
        noise; % Dados do sinal de ruido
        Smix; % Sinal de ruido
    end

    methods
        function obj = CsinalEntrada(xf,nf,snrDB) 
            switch nargin
                case 0 
                
                case 1
                    obj.Xfile = xf;
                case 2
                    obj.Xfile = xf;
                    obj.Nfile = nf;
                case 3
                    obj.Xfile = xf;
                    obj.Nfile = nf;
                    obj.SNRdB = snrDB;
                otherwise
                    error('O numero de argumentos deve ser menor ou igual a 3')
            end
        end
        %% Gets
        function val = get.SNR(obj)
            val = obj.PrvtSNR;
        end
        function val = get.target(obj)
            val = obj.Prvttarget;
        end
        function val = get.noise(obj)
            val = obj.Prvtnoise;
        end
        function val = get.Smix(obj)
            val = obj.PrvtSmix;
        end
        %% Sets
        function set.Xfile(obj,xf)
            if ischar(xf) && strcmp(xf(end-3: end), '.wav')
                obj.Xfile = xf;
                obj.ldTarget();
                obj.mix();
            else
                error('xf deve ser um arquivo .wav')
            end
        end
        function set.Nfile(obj,nf)
            if ischar(nf) && (strcmp(nf(end-3: end), '.wav') || strcmp(nf,'no_noise'))
                obj.Nfile = nf;
                obj.ldNoise;
                obj.mix();
            else
                error('nf deve ser um arquivo .wav')
            end
        end
        function set.SNRdB(obj,snrDB)
            if isnumeric(snrDB)
                obj.SNRdB = snrDB;
                obj.ldSNR();
                obj.mix();
            else
                error('snrDB deve ser numerico')
            end
        end
        function set.fs(obj,fs)
            if isnumeric(fs)
                obj.fs = fs;
            else
                error('taxa de amostragem fs deve ser numerico')
            end
        end

        function set.Tangle(obj,angle)
            if mod(angle,5) == 0 || -180 < angle <= 180
                obj.Tangle = angle;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            obj.ldTarget();
            obj.mix();
        end

        function set.Tdist(obj,dist)
            if dist == 80 || dist == 300
                obj.Tdist = dist;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            obj.ldTarget();
            obj.mix();
        end

        function set.Nangle(obj,angle)
            if mod(angle,5) == 0 || -180 < angle <= 180
                obj.Nangle = angle;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            obj.ldNoise();
            obj.mix();
        end

        function set.Ndist(obj,dist)
            if dist == 80 || dist == 300
                obj.Ndist = dist;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            obj.ldNoise();
            obj.mix();
        end

        function set.side(obj,sd)
            if strcmp(sd,'left') || strcmp(sd,'right')
                obj.side = sd;
            else
                error('o lado dever ser "left" ou "right"')
            end
            obj.ldNoise();
            obj.ldTarget();
            obj.mix;
        end
        %% functions
        function ldTarget(obj)
            path = strcat(obj.DB_dir,obj.speech_dir,obj.Xfile);
            [S, Fsmpl] = audioread(path);    %loads signal
            S = S - mean(S);
            if Fsmpl ~= obj.fs;
                S = resample(S,obj.fs,Fsmpl);
            end

            % Direcao da fonte
            IR = loadHRIR1('Anechoic', obj.Tdist, 0, obj.Tangle, 'front');
            HRIR = resample(IR.data,obj.fs,IR.fs);
            in_lft = filter(HRIR(:,1),1,S);
            in_rgt = filter(HRIR(:,2),1,S);
            norm = .9/max(abs([in_lft ; in_rgt]));
            in_lft = norm*in_lft;
            in_rgt = norm*in_rgt;

            % Escolha do lado esquerdo/direito 
            switch obj.side
                case 'left'
                    Sin = in_lft;
                case 'right'
                    Sin = in_rgt;
                otherwise
                    error('obj.side deve ser "left" ou "right"')
            end
            obj.Prvttarget = Sin;
        end

        function ldNoise(obj)
            if strcmp(obj.Nfile,'no_noise')
                obj.Prvtnoise = 0;
                return;
            end
            path = strcat(obj.DB_dir,obj.noise_dir,obj.Nfile);
            [N, Fsmpl] = audioread(path);    %loads signal
            N = N - mean(N);
            if Fsmpl ~= obj.fs;
                N = resample(N,obj.fs,Fsmpl);
            end

            % Direcao do ruido
            IR = loadHRIR1('Anechoic', obj.Ndist, 0, obj.Nangle, 'front');
            HRIR = resample(IR.data,obj.fs,IR.fs);
            in_lft = filter(HRIR(:,1),1,N);
            in_rgt = filter(HRIR(:,2),1,N);
            norm = .9/max(abs([in_lft ; in_rgt]));
            in_lft = norm*in_lft;
            in_rgt = norm*in_rgt;

            % Escolha do lado esquerdo/direito 
            switch obj.side
                case 'left'
                    Nin = in_lft;
                case 'right'
                    Nin = in_rgt;
                otherwise
                    error('obj.side deve ser "left" ou "right"')
            end
            obj.Prvtnoise = Nin;
        end

        function ldSNR(obj)
            obj.PrvtSNR = 10^(obj.SNRdB/20);
        end

        function mix(obj)
            %mix sound + noise
            if (isempty(obj.target) || isempty(obj.noise) || isempty(obj.SNRdB))
                return;
            end

            if strcmp(obj.Nfile,'no_noise')
                obj.PrvtSmix = obj.target;
                return;
            end

            %% equal size
            Ls = length(obj.target);
            Ln = length(obj.noise);


            if Ls > Ln
                rpt = fix(Ls/Ln);
                diff = rem(Ls,Ln);
                aux0 = floor(rand(1,1)*(Ln-diff));
                obj.Prvtnoise = [repmat(obj.noise,rpt,1);obj.noise(aux0+1:aux0+diff)];
            else
                aux0 = floor(rand(1,1)*(Ln-Ls));
                obj.Prvtnoise = obj.noise(aux0+1:aux0+Ls);    %noise file is ramdomly cut
            end
            %% mix at SNR
            [obj.PrvtSmix, obj.Prvtnoise] = s_and_n(obj.target, obj.noise, obj.SNRdB);
            maxim = max(abs(obj.PrvtSmix));
            if maxim > 1
                obj.PrvtSmix = obj.PrvtSmix/maxim;
            end
        end

        function [srmr0,intel0] = intelsrmr(obj)
            if obj.fs ~= 8000 && obj.fs ~= 16000
                Fs1 = 16000;  %sample frequency for SRMR_CI function
                Xf = resample(obj.Smix,Fs1,obj.fs);
                X = resample(obj.target,Fs1,obj.fs);
            else
                Xf = obj.Smix;
                X = obj.target;
                Fs1 = obj.fs;
            end
            srmr0 = SRMR_CI(Xf,Fs1,'norm',1);

            %% calculates intelligibility
            SRMR_clean = SRMR_CI(X,Fs1,'norm',1);
            srmr_norm = srmr0/SRMR_clean;
            alpha = [-7.4535, 12.1742]'; %from Joao Santos thesis
            intel0 = 88.92./(1+exp(-(alpha(1)+alpha(2)*srmr_norm)));
        end

        function pesq0 = pesq_calc(obj)
            score = PESQa(obj.target,obj.Smix,obj.fs);
            pesq0 = score;
        end

    end
end
