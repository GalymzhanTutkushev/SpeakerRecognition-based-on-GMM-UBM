function fmnt = GetFormantsByRoots(Lp,Fs)
fmnt = zeros(3,1);
rts = roots(Lp);
rts = rts(imag(rts)>=0);
angz = atan2(imag(rts),real(rts));

[frqs,indices] = sort(angz.*(Fs/(2*pi)));
bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices)));
nn = 0;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && bw(kk) <400)
        nn = nn+1;
        fmnt(nn) = frqs(kk);
    end
    if nn==3
        break;
    end;
end