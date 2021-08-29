function Fmnt=GetFormantsBySpectreMax(Lp,f,Nfft,nLP)

Fmnt=zeros(3,1);
%строим огибающую спектра по КЛП
h=1./fft([Lp zeros(1,Nfft-(nLP+1))]).';
%рассматриваем только первую половину спектра
h=h(1:Nfft/2+1);
hh=abs(h);
hh = hh/sum(hh);

P=diff(hh);
%вычисляем форманты
JJ=0;
for L=2:length(P)
    S1=sign(P(L-1));
    S2=sign(P(L));
    if (S1>S2) && (f(L)>200)
        JJ=JJ+1;
        Fmnt(JJ,1)=f(L);
%         Fmnt(JJ,2)=hh(L);
    end
    if JJ==3
        break;
    end
end