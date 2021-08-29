function Lst = GetFileList(Dir, Pr)
if Pr==1
    K=0;
    L1=dir(Dir);
    for I=1:length(L1)
      S = L1(I).name;
      D=L1(I).isdir();
      D1=strcmp(L1(I).name,'.');
      D2=strcmp(L1(I).name,'..');
      if (D == 1) && (D1 == 0 && D2 == 0)
          S = strcat(Dir,L1(I).name,'\');
          L2=dir(S);
          for J=1:length(L2)
              if L2(J).isdir() == 0 && L2(J).bytes>=800000
                  S = L2(J);
                  K=K+1;
                  Lst(K).name=L2(J).name;
                  Lst(K).No = I;
                  Lst(K).SkrName = L1(I).name;
              end
          end
      end
    end
else
    L=dir(Dir);
    K=0;
    for I=1:length(L)
        if L(I).isdir()==0
            K=K+1;
            Lst(K).name=L(I).name;
            Lst(K).No = I;
            Lst(K).SkrName = L(I).name(1:end-4);
        end
    end
end