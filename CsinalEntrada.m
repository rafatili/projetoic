%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CsinalEntrada class by Rafael Chiea %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef CsinalEntrada < handle
    %CsinalEntrada class of signal under test info
    %   Smix = target + 1/SNR * noise

    properties
        Xfile;      %.wav file associated to target signal
        Nfile = 'no_noise';      %.wav file associated to noise signal, 'no_noise' = clean signal
        SNRdB = Inf;    %signal to noise ratio
        fs = 16000;   %sample rate
        DB_dir %='CD_Loizou/Databases/';
        noise_dir %='Noise_Recordings/';
        speech_dir %='Speech/IEEE_corpus/wideband/';
        Tangle = 0;   %angle of the target signal(degrees) multiple of 5
        Tdist = 80;   %distance = 80 cm or 300 cm
        Nangle = 0;   %angle of the noise signal(degrees) multiple of 5
        Ndist = 80;   %distance = 80 cm or 300 cm
        side = 'left';   %side of the implant left/right
    end

    properties(Access = private)
        PrvtSNR = Inf;
        Prvttarget;     %target signal data
        Prvtnoise = 0;      %noise signal data
        PrvtSmix;     %noisy signal
    end

    properties(Dependent)
        SNR;
        target;     %target signal data
        noise;      %noise signal data
        Smix;     %noisy signal
    end

    methods
        %% constructor
        function objeto = CsinalEntrada(xf,nf,snrDB) %constructor
            switch nargin
                case 0 
                
                case 1
                    objeto.Xfile = xf;
                case 2
                    objeto.Xfile = xf;
                    objeto.Nfile = nf;
                case 3
                    objeto.Xfile = xf;
                    objeto.Nfile = nf;
                    objeto.SNRdB = snrDB;
                otherwise
                    error('O numero de argumentos deve ser menor ou igual a 3')
            end
        end
        %% Gets
        function val = get.SNR(objeto)
            val = objeto.PrvtSNR;
        end
        function val = get.target(objeto)
            val = objeto.Prvttarget;
        end
        function val = get.noise(objeto)
            val = objeto.Prvtnoise;
        end
        function val = get.Smix(objeto)
            val = objeto.PrvtSmix;
        end
        %% Sets
        function set.Xfile(objeto,xf)
            if ischar(xf) && strcmp(xf(end-3: end), '.wav')
                objeto.Xfile = xf;
                objeto.ldTarget();
                objeto.mix();
            else
                error('xf deve ser um arquivo .wav')
            end
        end
        function set.Nfile(objeto,nf)
            if ischar(nf) && (strcmp(nf(end-3: end), '.wav') || strcmp(nf,'no_noise'))
                objeto.Nfile = nf;
                objeto.ldNoise;
                objeto.mix();
            else
                error('nf deve ser um arquivo .wav')
            end
        end
        function set.SNRdB(objeto,snrDB)
            if isnumeric(snrDB)
                objeto.SNRdB = snrDB;
                objeto.ldSNR();
                objeto.mix();
            else
                error('snrDB deve ser numerico')
            end
        end
        function set.fs(objeto,fs)
            if isnumeric(fs)
                objeto.fs = fs;
            else
                error('taxa de amostragem fs deve ser numerico')
            end
        end

        function set.Tangle(objeto,angle)
            if mod(angle,5) == 0 || -180 < angle <= 180
                objeto.Tangle = angle;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            objeto.ldTarget();
            objeto.mix();
        end

        function set.Tdist(objeto,dist)
            if dist == 80 || dist == 300
                objeto.Tdist = dist;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            objeto.ldTarget();
            objeto.mix();
        end

        function set.Nangle(objeto,angle)
            if mod(angle,5) == 0 || -180 < angle <= 180
                objeto.Nangle = angle;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            objeto.ldNoise();
            objeto.mix();
        end

        function set.Ndist(objeto,dist)
            if dist == 80 || dist == 300
                objeto.Ndist = dist;
            else
                error('o angulo deve ser numerico e multiplo de 5')
            end
            objeto.ldNoise();
            objeto.mix();
        end

        function set.side(objeto,sd)
            if strcmp(sd,'left') || strcmp(sd,'right')
                objeto.side = sd;
            else
                error('o lado dever ser "left" ou "right"')
            end
            objeto.ldNoise();
            objeto.ldTarget();
            objeto.mix;
        end
        %% functions
        function ldTarget(objeto)
            path = strcat(objeto.DB_dir,objeto.speech_dir,objeto.Xfile);
            [S, Fsmpl] = audioread(path);    %loads signal
            S = S-mean(S);
            if Fsmpl ~= objeto.fs;
                S = resample(S,objeto.fs,Fsmpl);
            end

            %target direction
            IR=loadHRIR1('Anechoic', objeto.Tdist, 0, objeto.Tangle, 'front');
            HRIR = resample(IR.data,objeto.fs,IR.fs);
            in_lft = filter(HRIR(:,1),1,S);
            in_rgt = filter(HRIR(:,2),1,S);
            norm = .9/max(abs([in_lft ; in_rgt]));
            in_lft = norm*in_lft;
            in_rgt = norm*in_rgt;

            %choose side
            switch objeto.side
                case 'left'
                    Sin = in_lft;
                case 'right'
                    Sin = in_rgt;
                otherwise
                    error('objeto.side deve ser "left" ou "right"')
            end
            objeto.Prvttarget = Sin;
        end

        function ldNoise(objeto)
            if strcmp(objeto.Nfile,'no_noise')
                objeto.Prvtnoise = 0;
                return;
            end
            path=strcat(objeto.DB_dir,objeto.noise_dir,objeto.Nfile);
            [N, Fsmpl] = audioread(path);    %loads signal
            N = N - mean(N);
            if Fsmpl ~= objeto.fs;
                N = resample(N,objeto.fs,Fsmpl);
            end

            %noise direction
            IR = loadHRIR1('Anechoic', objeto.Ndist, 0, objeto.Nangle, 'front');
            HRIR = resample(IR.data,objeto.fs,IR.fs);
            in_lft = filter(HRIR(:,1),1,N);
            in_rgt = filter(HRIR(:,2),1,N);
            norm = .9/max(abs([in_lft ; in_rgt]));
            in_lft = norm*in_lft;
            in_rgt = norm*in_rgt;

            %choose side
            switch objeto.side
                case 'left'
                    Nin = in_lft;
                case 'right'
                    Nin = in_rgt;
                otherwise
                    error('objeto.side deve ser "left" ou "right"')
            end
            objeto.Prvtnoise = Nin;
        end

        function ldSNR(objeto)
            objeto.PrvtSNR = 10^(objeto.SNRdB/20);
        end

        function mix(objeto)
            %mix sound + noise
            if (isempty(objeto.target) || isempty(objeto.noise) || isempty(objeto.SNRdB))
                return;
            end

            if strcmp(objeto.Nfile,'no_noise')
                objeto.PrvtSmix = objeto.target;
                return;
            end

            %% equal size
            Ls = length(objeto.target);
            Ln = length(objeto.noise);


            if Ls > Ln
                rpt = fix(Ls/Ln);
                diff = rem(Ls,Ln);
                aux0 = floor(rand(1,1)*(Ln-diff));
                objeto.Prvtnoise = [repmat(objeto.noise,rpt,1);objeto.noise(aux0+1:aux0+diff)];
            else
                aux0 = floor(rand(1,1)*(Ln-Ls));
                objeto.Prvtnoise = objeto.noise(aux0+1:aux0+Ls);    %noise file is ramdomly cut
            end
            %% mix at SNR
            [objeto.PrvtSmix, objeto.Prvtnoise] = s_and_n(objeto.target, objeto.noise, objeto.SNRdB);
            maxim = max(abs(objeto.PrvtSmix));
            if maxim > 1
                objeto.PrvtSmix = objeto.PrvtSmix/maxim;
            end
        end

        function [srmr0,intel0] = intelsrmr(objeto)
            if objeto.fs ~= 8000 && objeto.fs ~= 16000
                Fs1 = 16000;  %sample frequency for SRMR_CI function
                Xf = resample(objeto.Smix,Fs1,objeto.fs);
                X = resample(objeto.target,Fs1,objeto.fs);
            else
                Xf = objeto.Smix;
                X = objeto.target;
                Fs1 = objeto.fs;
            end
            srmr0 = SRMR_CI(Xf,Fs1,'norm',1);

            %% calculates intelligibility
            SRMR_clean = SRMR_CI(X,Fs1,'norm',1);
            srmr_norm = srmr0/SRMR_clean;
            alpha = [-7.4535, 12.1742]'; %from Joao Santos thesis
            intel0 = 88.92./(1+exp(-(alpha(1)+alpha(2)*srmr_norm)));
        end

        function pesq0 = pesq_calc(objeto)
            score = PESQa(objeto.target,objeto.Smix,objeto.fs);
            pesq0 = score;
        end

    end
end
