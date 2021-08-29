function c = CalcFormants(YB,Fs,fff)
Nfft = 1024;
f = linspace(0,Fs,Nfft);
nLP=round(Fs/1000)+2;
NB = size(YB,1);

NF=0.01*Fs;%шаг сдвига кадра
DN=0.02*Fs;
      if fff>0
        DN=4*fix(1/fff*Fs);
        NF=fix(DN/2);
      end
NN = floor(NB/DN);
Cnt = 0;
Beg = 1;
End = Beg + DN - 1;
i=0;fm1=[];
c=[];
% fm2=[];End < NB
for i=1:2*NN-1
    Y=YB(Beg:End);
    Yw=Y.*hamming(length(Y));
    Lp=lpc(Yw,nLP);
%     try
    fmnt1 = GetFormantsByRoots(Lp,Fs);
    fmnt2 = GetFormantsBySpectreMax(Lp,f,Nfft,nLP);
     i=i+1;
%     catch
%         continue;
%     end
    fm1=vertcat(fm1,fmnt1');

  

    Beg = End-NF;
    End = Beg + DN;
end
c=fm1;
if ~isempty(c)
    nf=size(c,1);
    nc=3;
    vf=(4:-1:-4)/60;
  af=(1:-1:-1)/2;
  ww=ones(5,1);
  cx=[c(ww,:); c; c(nf*ww,:)];
  vx=reshape(filter(vf,1,cx(:)),nf+10,nc);
  vx(1:8,:)=[];
  ax=reshape(filter(af,1,vx(:)),nf+2,nc);
  ax(1:2,:)=[];
  vx([1 nf+2],:)=[];
  
     c=[c vx ax];
else
    c=0;
end
end
