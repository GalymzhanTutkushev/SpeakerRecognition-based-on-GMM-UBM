function blocks=newVAD(Y,Fs)

tframe=0.01;                       % длительность фрейма 10 мс
Nsamples=Fs*tframe;                 % количество точек в фрейме
tfull=floor(length(Y)/Fs);          % длительность аудио                              % частота дискретизации 
Nframes=fix(tfull/tframe);          % количество фреймов 
%%%%%%%%%%%%%%%%%%%   расчет энергии каждого фрейма   %%%%%%%%%%%%%%%%%%%%%%
Eframe=zeros(1,Nframes);
YY = cell(Nframes,1);
for i=1:Nframes                
    lower=(i-1)*Nsamples+1;             % нижн€€ граница фрейма
    upper=i*Nsamples;                   % верхн€€ граница фрейма
    YY{i} = Y(lower:upper);
end

parfor i=1:Nframes                
    Eframe(i)=sum((YY{i}).^2);      % расчет энергии отдельного фрейма
end
% Eframe=sort(Eframe);
% De1=diff(Eframe);
% De2=diff(Eframe,2);
% [co,ro]=find(De1<0);
% De1(co,ro)=0;
% [col,row]=find(De2<0);
% De2(col,row)=0;
[fff,Epor]=hist(Eframe,200);

p=1;             % номер столбца гистограммы
o=fff(p);        % количество фреймов в столбцax
%%%%%%%%% определени€ порога отбора %%%%%%%%%%%%%%%%
per=fff(p)/Nframes;
while(per<0.6)   %  вырезаем 60 процентов 
    p=p+1;       %  переходим к следующему фрейму
  o=fff(p)+o;
  per=o/Nframes;
end
Ep=Epor(p);
% disp(Ep)
% disp(p)
k=1;

 %%%%%%%%%%%%%%%%%  выбор необходимых фреймов (только голос) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 YYY=cell(Nframes,1);
 iter=zeros(Nframes,1);
 for i=1:Nframes   
     if(Eframe(i)>Ep)         % условие отбора фрейма  
         iter(k)=i;           % номер отобранных фреймов
         YYY{k}=YY{i};
         YYY{k}=YYY{k}-mean(YYY{k});
         k=k+1;
         
     end
 end
%  figure(301)
% plot(Eframe)
% hold on;
% bbbb=1:length(Eframe);
% bb(1:length(Eframe))=Ep;
% plot(bbbb,bb,'r-')
% figure(302)
% plot(De1);
% hold on;
% plot(De2);
 iter=iter(1:k-1,1);
 Hf=zeros(length(iter),1);

%%%%%%%%%%%%%%% запись выбранных фреймов в массив и сохранение в аудиофайл%%
if(~isempty(iter) && length(iter)>2000)
    

parfor i=1:length(iter)
    E=abs(fft(YYY{i},1024));
    E=E(1:512);
    sumE=zeros(1,8);
    for d=0:512/64-1
        start=d*64+1;
        sumE(d+1)=sum(E(start:start+63)); 
    end
    E=nonzeros(E);
    p=sumE/sum(E);
    entr=-sum(p.*log2(p));                    % расчет энтропии отдельного фрейма
    Hf(i)=entr;                             % запись энтропии отдельного фрейма в массив  
end
p(1:8)=1/8;
maxHf=-sum(p.*log2(p)); 
Hf=Hf/maxHf;
%%%%%%%%%%%%%%%%%%%   расчет энергии каждого фрейма   %%%%%%%%%%%%%%%%%%%%%%

u=1;
oter=zeros(length(iter),1);

for i=1:length(iter)
    if Hf(i)<0.85                 % условие отбора фрейма
        oter(u)=iter(i);           % номер отобранных фреймов
        u=u+1;
    end
end
% figure(300)
% plot(Hf,'*-')
% hold on;
% aaaa=1:length(Hf);
% aa(1:length(Hf))=0.85;
% plot(aaaa,aa,'r-')
% disp(maxHf)
% disp(max(Hf))
oter=nonzeros(oter);
 blocks=zeros(length(oter),2);
%       blocks(1,1)=0;
%       blocks(1,2)=0;
FramesInBlock=0; ii=0;
% disp(oter)
for s=1:length(oter)-1
   
    if(oter(s+1)==oter(s)+1) && (s+1)<length(oter)
        FramesInBlock=FramesInBlock+1;
%         disp(FramesInBlock)
    else
   
        silence=oter(s+1)-oter(s);
     
      if(FramesInBlock>10)
        ii=ii+1;
        Begin=(oter(s)-FramesInBlock)*Nsamples;
        End=Nsamples*oter(s);
     blocks(ii,1)=Begin;
     blocks(ii,2)=End;
%      FramesInBlock=0;
      end

      FramesInBlock=0;

    
    end
   
end
 blocks=blocks(1:ii,:);
else
    
         blocks=[];

end

end
 