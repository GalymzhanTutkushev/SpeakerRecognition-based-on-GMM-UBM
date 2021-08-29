function Res = CmprFmnt(nPos)

global MainPath;
tic

GMMPath1 = strcat(MainPath, 'TrainData\GMM\');
TestDataFileDir = strcat(MainPath, 'TestData\Data\');
%TrainDataFileDir = strcat(MainPath, 'TrainData\Data\');
UBMFile = strcat(MainPath,'UBM\GMM\UBM_GMM.mat');
UBM_GMM = load(UBMFile, 'GMModel');
UBM = UBM_GMM.GMModel;
trials = [1 1];
models = cell(1,1);

GMMFileList1 = dir(GMMPath1);
TestDataList = dir(TestDataFileDir);

R=zeros(1,3);
Cnt = 0;

for I=1:length(GMMFileList1)
    if GMMFileList1(I).isdir() == 0
        %DataFile1 = strcat(TrainDataFileDir,GMMFileList1(I).name(1:end-4),'.txt');
        %V = load(DataFile1);
        %F01 = mean(V(:,4));
        GMMFile = strcat(GMMPath1,GMMFileList1(I).name);
        GMM1=load(GMMFile, 'GMModel');
        models{1} = GMM1.GMModel;
        for J=1:length(TestDataList)
            if TestDataList(J).isdir() == 0
                DataFile2 = strcat(TestDataFileDir,TestDataList(J).name);
                V = load(DataFile2);
                nV=size(V,1);
                %F02 = mean(V(:,4));
                %if abs(F01-F02)/max(F01,F02)<0.2
                if nV>10
                    TestData = V(:,5:40);
                    nT=size(TestData,1);
%                     y1 = log(pdf(GMM1.GMModel, TestData));
%                     y2 = log(pdf(UBM_GMM.GMModel, TestData));
%                     dy = y1-y2;
                     %%%%%TestData = mat2cell(TestData');
                     dy = score_gmm_trials(models, TestData, trials, UBM);
                    
%                     nCnt = 50;
%                     Beg = 1;
%                     End = nCnt;
%                     nTot = 0;
%                     nCor = 0;
%                     while End<=nT
%                         nTot = nTot + 1;
%                         DY = sum(dy(Beg:End))/nCnt;
%                         if (DY > 0.2)
%                             nCor = nCor+1;
%                         end;
%                         Beg = Beg + 1;
%                         End = Beg + nCnt;
%                     end;                   
                    
                    Idx = find(dy>0);
                    Sim = 100*numel(Idx)/nT;
%                     Sim = 100*nCor/nTot;
                    Cnt = Cnt + 1;
                    R(Cnt,1)=I;
                    R(Cnt,2)=J;
                    R(Cnt,3)=Sim;
                end;
            end;
        end;
    end;
end;
toc
% xlFile = strcat(MainPath,'Result\Res.xls');
R = sortrows(R,[1 -3]);
n=size(R,1);
Cur = 0;
J=0;
K=0;
Res=cell(1,3);
for I=1:n
    if R(I,1)~=Cur
        Cur=R(I,1);
        K=1;
        
        if I~=1
            J=J+1;
            Res{J,1} = '---------';
            Res{J,2} = '---------';
            Res{J,3} = '-100';
        end;
    else
        K=K+1;
    end;
    if K<=nPos
        J=J+1;
        Res{J,1}=GMMFileList1(R(I,1)).name(1:end-4);
        Res{J,2}=TestDataList(R(I,2)).name(1:end-4);
        Res{J,3}=R(I,3);
%         d = {GMMFileList2(Res(I,2)).name(1:end-4);Res(I,3)};
%         sheet = GMMFileList1(Res(I,1)).name(1:end-4);
%         xlRange = strcat('A',num2str(K));
%         xlswrite(xlFile, d', sheet, xlRange)
    end;
end;