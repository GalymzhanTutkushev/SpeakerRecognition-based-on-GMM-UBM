% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 29-Jan-2018 09:44:55
%
% This script assumes these variables are defined:
%
%   c - input data.
%   id - target data.
clear;clc;

% PathSpeechTest='D:\Galym stuff\matal\audio2019\testSh\';    ��� ����
PathSpeechTest='D:\diplom\test\';
FileListTest = GetFileList(PathSpeechTest,2);
Nt = length(FileListTest);
[C_test,ID_test]=NN_train_VADst(1,Nt,PathSpeechTest,FileListTest);

% PathSpeech='D:\Galym stuff\matal\audio2019\train\';
PathSpeech='D:\diplom\train\';
FileListS = GetFileList(PathSpeech,2);
Ns = length(FileListS);
%  NetFile = strcat('netALL.mat');
%  load(NetFile,'net');
%  ������������� ��������

    newI=randperm(Ns);
    for II=1:length(newI)
        FileListTrain(II).name=FileListS(newI(II)).name;
    end

% inter=5;
% npart=Ns/inter;
% dots=[0 1 2 3 4 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150];
dots=[0 5 10 20]; %�����
npart=length(dots)-1;
% savpath='D:\Galym stuff\matal\'; ��� ����
savpath='D:\diploma\results\';
errALL=zeros(npart,1);
err1=zeros(npart,1);
err0=zeros(npart,1);
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.  trainrp
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Scaled conjugate gradient backpropagation.
hiddenLayerSize = [20 20 20];  % ���������� ����� ���������
for porog=0.5:0.1:0.5

   Num_pot=4;  %���������� ����������� �������
   delete(gcp('nocreate'))
   myPool = parpool(Num_pot);
    
   xp = [];
   tp = [];
   sumErr=zeros(npart,1);
   negErr=zeros(npart,1);
   posErr=zeros(npart,1);
   idata=zeros(npart,1);
   pr=zeros(npart,1);
   
    for i=1:npart
%         beg=(i-1)*inter+1
%         en=i*inter
        beg=dots(i)+1;
        en=dots(i+1);
        
%         % Create a Pattern Recognition Network
        [C_in,ID_in]=NN_train_VADst(beg,en,PathSpeech,FileListTrain);

        xp=vertcat(xp,C_in);
        tp=vertcat(tp,ID_in);
        x=xp';
        t=tp';

        net = patternnet(hiddenLayerSize, trainFcn);

%         % Setup Division of Data for Training, Validation, Testing
        net.divideParam.trainRatio = 90/100;
        net.divideParam.valRatio = 10/100;
        net.divideParam.testRatio = 0/100;
        net.trainParam.max_fail = 6;
        net.trainParam.epochs = 1000;

% 
        tic
%         % Train the Network
% 
        [net,tr] = train(net,x,t,'useParallel','yes');
%   NetFile = strcat('netMAD30.mat');
%    load(NetFile,'net');
        % Test the Network
        y = net(C_test');

        performance = perform(net,ID_test',y);
        [c,cm] = confusion(ID_test',y);
        sumcm=sum(sum(cm));

        errALL(i)=(cm(1,2)+cm(2,1))/sumcm*100;
        err1(i)=cm(2,1)/sumcm*100;
        err0(i)=cm(1,2)/sumcm*100;
         
        
        parfor ii=1:length(y)
            if(y(ii)>=porog)
                y(ii)=1;
            else
                y(ii)=0;
            end
        end

        e = gsubtract(ID_test',y);
        tind = vec2ind(ID_test');
        yind = vec2ind(y);
        percentErrors = sum(tind ~= yind)/numel(tind);
        toc
        sumErr(i)=numel(find(abs(e)==1))/length(e)*100;
        posErr(i)=numel(find(e==1))/length(e)*100;
        negErr(i)=numel(find(e==-1))/length(e)*100;
  
        idata(i)=2*en;
        pr(i)=performance;
        % View the Network
    %     view(net)

        % Plots
        % Uncomment these lines to enable various plots.
    %     figure, plotperform(tr)
        %figure, plottrainstate(tr)
    %     figure, ploterrhist(e)
%         figure, plotconfusion(ID_test',y)

    %     figure, plotroc(t,y)
    %  
       
    end
       
    %% 
    xlswrite(strcat(savpath,'sumerr',num2str(porog*10),'.xlsx'),sumErr)
    xlswrite(strcat(savpath,'poserr',num2str(porog*10),'.xlsx'),posErr)
    xlswrite(strcat(savpath,'negerr',num2str(porog*10),'.xlsx'),negErr)
    xlswrite(strcat(savpath,'dictorsincrement.xlsx'),idata)
    figure, plotconfusion(ID_test',y)
    figure, ploterrhist(e)
    figure(110) 
    plot(idata,errALL,'r-')
    title('��������� ������ (con)')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(111) 
    plot(idata,err1,'g-')
    title('���� ������� ��� �� ���� (con)')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(112) 
    plot(idata,err0,'b-')
    title('�� ���� ������� ��� ���� (con)')
    xlabel('���������� ��������');
    ylabel('������� ������');
    % 
switch (porog)
    case(0.5)
        md='m-*';
       figure(1000) 
    plot(idata,pr,md)
     hold on
     legend(num2str(0.5))
    title('������������������ ����')
    xlabel('���������� ��������');
    ylabel('�������� ������� ������');
     figure(1001) 
    plot(idata,sumErr,md)
     hold on
     legend(num2str(0.5))
    title('��������� ������')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1002) 
    plot(idata,posErr,md)
    hold on
     legend(num2str(0.5))
    title('���� ������� ��� �� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1003) 
    plot(idata,negErr,md)
    hold on
     legend(num2str(0.5))
    title('�� ���� ������� ��� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    p=0;
%             for prg=0.05:0.01:0.95
%                 p=p+1;
%                     y = net(C_test');
%                     parfor i=1:length(y)
%                         if(y(i)>=prg)
%                             y(i)=1;
%                         else
%                             y(i)=0;
%                         end
%                     end
%                     e = gsubtract(ID_test',y);
%                     errpos(p)=numel(find(e==1))/length(e)*100;  %1-0=1
%                     errneg(p)=numel(find(e==-1))/length(e)*100; %0-1=-1
%                     errsum(p)=numel(find(abs(e)==1))/length(e)*100;
%                     
%               
%             end
%             prg=0.05:0.01:0.95;
%                   figure(1111) 
%                     disp(errpos)
%                     plot(prg,errpos,'b--o')
%                     xlim([0 1])
%                 
%                     xlabel('����� �������� �������');
%                     ylabel('������� ������');
%                     title('���� ������� ��� �� ����')
%                     figure(1112) 
%                     disp(errneg)
%                     plot(prg,errneg,'b--o')
%                     xlim([0 1])
%                   
%                     title('�� ���� ������� ��� ����')
%                     xlabel('����� �������� �������');
%                     ylabel('������� ������');
%                     figure(1113) 
%                     disp(errsum)
%                     plot(prg,errsum,'b--o')
%                     xlim([0 1])
%                    
%                     title('��������� ������')
%                     xlabel('����� �������� �������');
%                     ylabel('������� ������');
%                     
%         xlswrite(strcat(savpath,'sumerr_diff_por.xlsx'), errsum)
%         xlswrite(strcat(savpath,'poserr_diff_por.xlsx'), errpos)
%         xlswrite(strcat(savpath,'negerr_diff_por.xlsx'), errneg)
    case(0.6)
        md='r-o';
          figure(1000) 
    plot(idata,pr,md)
     hold on
     legend(num2str(0.5),num2str(0.6))
    title('������������������ ����')
    xlabel('���������� ��������');
    ylabel('�������� ������� ������');
     figure(1001) 
    plot(idata,sumErr,md)
     hold on
     legend(num2str(0.5),num2str(0.6))
    title('��������� ������')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1002) 
    plot(idata,posErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6))
    title('���� ������� ��� �� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1003) 
    plot(idata,negErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6))
    title('�� ���� ������� ��� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    case(0.7)
        md='g-^';
          figure(1000) 
    plot(idata,pr,md)
     hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7))
    title('������������������ ����')
    xlabel('�������� ������� ������');
    ylabel('������� ������');
     figure(1001) 
    plot(idata,sumErr,md)
     hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7))
    title('��������� ������')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1002) 
    plot(idata,posErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7))
    title('���� ������� ��� �� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1003) 
    plot(idata,negErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7))
    title('�� ���� ������� ��� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    case(0.8)
        md='b-+';
          figure(1000) 
    plot(idata,pr,md)
     hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8))
    title('������������������ ����')
    xlabel('���������� ��������');
    ylabel('�������� ������� ������');
     figure(1001) 
    plot(idata,sumErr,md)
     hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8))
    title('��������� ������')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1002) 
    plot(idata,posErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8))
    title('���� ������� ��� �� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1003) 
    plot(idata,negErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8))
    title('�� ���� ������� ��� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    
    case(0.9)
        md='c-x';
          figure(1000) 
    plot(idata,pr,md)
     hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8),num2str(0.9))
    title('������������������ ����')
    xlabel('���������� ��������');
    ylabel('�������� ������� ������');
     figure(1001) 
    plot(idata,sumErr,md)
     hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8),num2str(0.9))
    title('��������� ������')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1002) 
    plot(idata,posErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8),num2str(0.9))
    title('���� ������� ��� �� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(1003) 
    plot(idata,negErr,md)
    hold on
     legend(num2str(0.5),num2str(0.6),num2str(0.7),num2str(0.8),num2str(0.9))
    title('�� ���� ������� ��� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
end
    figure(200+porog*10) 
    plot(idata,pr,'g-')
    title('������������������ ����')
    xlabel('�������� ������� ������');
    ylabel('������� ������');
    figure(210+porog*10) 
    plot(idata,sumErr,'r-')
    title('��������� ������')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(220+porog*10) 
    plot(idata,posErr,'g-')
    title('���� ������� ��� �� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    figure(230+porog*10) 
    plot(idata,negErr,'b-')
    title('�� ���� ������� ��� ����')
    xlabel('���������� ��������');
    ylabel('������� ������');
    
end  
    
%% 
%         MainPath = 'C:\Users\User\Desktop\';
%         TrainFileX = strcat(MainPath,'audio-inputALL.mat' );
%         save(TrainFileX, 'x');
%         TrainFileT = strcat(MainPath,'audio-targetALL.mat' );
%         save(TrainFileT, 't');
%         netfile=strcat(MainPath,'netALL.mat' );   
%         save(netfile,'net')
        %% 
% 
% figure(122) 
% plot(idata,pr,'r--o')
% xlabel('���������� ��������');
% ylabel('�������� ������� ������');
% %% 
% disp(y)
%% 

