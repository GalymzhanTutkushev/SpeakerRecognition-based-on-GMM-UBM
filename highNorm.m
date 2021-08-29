function blocks = highNorm(Y,Fs)
tframe=0.01;                       % ������������ ������ 10 ��
Nsamples=Fs*tframe;                 % ���������� ����� � ������
tfull=floor(length(Y)/Fs);         % ������������ �����                              % ������� ������������� 
Nframes=fix(tfull/tframe);          % ���������� ������� 
%%%%%%%%%%%%%%%%%%%   ������ ������� ������� ������   %%%%%%%%%%%%%%%%%%%%%%
Eframe=zeros(1,Nframes);
YY = cell(Nframes,1);
for i=1:Nframes                
    lower=(i-1)*Nsamples+1;             % ������ ������� ������
    upper=i*Nsamples;                   % ������� ������� ������
    YY{i} = Y(lower:upper);
    Eframe(i)=sum((YY{i}).^2);      % ������ ������� ���������� ������
end

[fff,Epor]=hist(Eframe,3000);

p=1;             % ����� ������� �����������
o=fff(p);        % ���������� ������� � ������ax
%%%%%%%%% ����������� ������ ������ %%%%%%%%%%%%%%%%
per=fff(p)/Nframes;
while(per<0.01)   %  �������� 50 ��������� 
  p=p+1;       %  ��������� � ���������� ������
  o=fff(p)+o;
  per=o/Nframes;
end
Ep=Epor(p);

 %%%%%%%%%%%%%%%%%  ����� ����������� ������� (������ �����) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 iter=zeros(Nframes,1);
 k=1;
  for i=1:Nframes   
     if(1)         % ������� ������ ������  Eframe(i)>Ep
         iter(k)=i;           % ����� ���������� �������
         k=k+1;
         
     end
  end
  
   FramesInBlock=0; ii=0;
   oter=iter(1:k-1,1);
   blocks=zeros(length(oter),2);

  for s=1:length(oter)-1
   
    if(oter(s+1)==oter(s)+1) && (s+1)<length(oter)
        FramesInBlock=FramesInBlock+1;
       
    else
   
     
      if(FramesInBlock>10)
        ii=ii+1;
        Begin=(oter(s)-FramesInBlock)*Nsamples;
        End=Nsamples*oter(s);
        
         blocks(ii,1)=Begin;
         blocks(ii,2)=End;

      end

      FramesInBlock=0;

    
    end
   
  end
 
     blocks=blocks(1:ii,:);
  
     
