function Vdb = lin2db( Vlin )
%LIN2DB Output the input in dB.
%       Vdb = 20*log10(Vlin)
if Vlin>0
    Vdb = 20*log10(Vlin);
else
    error('Input must be positive.')
end

end

