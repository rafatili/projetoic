function  intel  = srmr2intel( SRMR, SRMR_clean, flgci )
%intel  = srmr2intel( srmr, ci )
%   Returns the intelligibility for a given srmr score
%   SRMR is the metric score of the analysed audio
%   SRMR_clean is the score for the clean version of the analysed audio
%   flgci is a flag, if 0: srmr metric for normal hearing;
%                    if 1: srmr_ci

srmr_norm = SRMR/SRMR_clean;
switch flgci
    case 0      %SRMR
        alpha = [-2.8516, 6.7629]';
        
    case 1      %SRMR-CI
        alpha = [-7.4535, 12.1742]';

    otherwise
        error('flgci must be either 0 or 1. See help' )
end

intel=88.92./(1+exp(-(alpha(1)+alpha(2)*srmr_norm)));
end

