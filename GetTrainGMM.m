function [TrainGMMs,M] = GetTrainGMM
    global MainPath;
    TrainGMMs = cell(1,1);
    GMMPath1 = strcat(MainPath, 'TrainData\GMM\');
    GMMFileList1 = dir(GMMPath1);
    Cnt = 0;
    M = length(GMMFileList1);
    for I = 1:M
        if GMMFileList1(I).isdir() == 0
            Cnt = Cnt + 1;
            GMMFile = strcat(GMMPath1,GMMFileList1(I).name);
            GMM1=load(GMMFile, 'GMModel');
            TrainGMMs{Cnt,1} = GMM1.GMModel;
            TrainGMMs{Cnt,2} = GMMFileList1(I).name(1:end-4);
        end;
    end;
end