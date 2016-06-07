function resamp_audio(nome_in,nome_out,fs)
        [s1, fs1] = audioread(nome_in);
        audiowrite(nome_out,resample(s1(:,1),fs,fs1),fs)
end