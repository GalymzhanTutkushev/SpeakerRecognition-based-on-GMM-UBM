function y=SeparateWav(Y0,Fs)
%���������� ������ ������, ������������ ��������������� �������
%Y0 - ������
%Fs - ������� �������������
  y=zeros(1,2); %������ ������
  FrameSizeMS = 0.01;%����� ���� ������� � ���
  FrameSizeSampl = Fs*FrameSizeMS;%����� ���� � �������
  LenWav = length(Y0);
  FrameCount=fix(LenWav/FrameSizeSampl)-1;%���-�� ����
  Std=std(Y0);
  Porog =2*Std; % ��������� ��������
  J = 0;
  Si = 0;
  II=0;
  Beg=0;
  End=0;
  y(1,1)=1;
  y(1,2)=length(Y0);
  for I=1:FrameCount
      %������ ����
      N1 = (I-1)*FrameSizeSampl + 1;
      %����� ����
      N2 = N1 + FrameSizeSampl;
      Y=Y0(N1:N2);     
      %������ �������� � ������� ����
      R=max(Y)-min(Y);
      if R>Porog
          J=J+1;
          if J==1
              Beg = N1+round(FrameSizeSampl/2);%������ - �������� ����
          end
          Si = 0;
      else
          Si = Si + 1;
          if J>5 && Si<4 %���� ���-�� ������ ������ ����>3
              End = N1+round(FrameSizeSampl/2);%����� - �������� ����
              II=II+1;
              y(II,1)=Beg;
              y(II,2)=End;
          end
          J=0;
      end
  end
  %��� ��������� ���������� ����
  if Beg>0 && End==0
      End = N1+round(FrameSizeSampl/2);
      II=II+1;
      y(II,1)=Beg;
      y(II,2)=End;
  end