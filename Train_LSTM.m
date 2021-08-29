clc;clear;
PathSpeech='C:\Users\User\Desktop\Galym stuff\matal\shahALL\';
FileListS = GetFileList(PathSpeech,2);
Ns = length(FileListS);
[XTrain,YTrain] = NN_train_VAD_RNN(1,Ns,PathSpeech,FileListS);

% [XTrain,YTrain] = japaneseVowelsTrainData;

% сортировка данных по длительности
numObservations = numel(XTrain);
for i=1:numObservations
    sequence = XTrain{i};
    sequenceLengths(i) = size(sequence,2);
end
[sequenceLengths,idx] = sort(sequenceLengths);
XTrain = XTrain(idx);    % вход сети
YTrain = YTrain(idx);    % выход сети = цели
XTrain=XTrain(1:8000);
YTrain=YTrain(1:8000);
size(YTrain)
% формирование и тренировка сети
inputSize = 12;          % количество входов
numHiddenUnits = 100;    % количество скрытых элементов
numClasses = 2;          % количество классов

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer()
    classificationLayer()];

maxEpochs = 1000;
miniBatchSize = 50;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','auto', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);

%%  тест сети и подсчет точности
PathSpeechTest='C:\Users\User\Desktop\Galym stuff\matal\AigulCom\';
FileListTest = GetFileList(PathSpeechTest,2);
Nt = length(FileListTest);
[XTest,YTest] = NN_train_VAD_RNN(1,Nt,PathSpeechTest,FileListTest);
% [XTest,YTest] = japaneseVowelsTestData;

% сортировка данных по длительности
numObservationsTest = numel(XTest);
for i=1:numObservationsTest
    sequence = XTest{i};
    sequenceLengthsTest(i) = size(sequence,2);
end
[sequenceLengthsTest,idx] = sort(sequenceLengthsTest);
XTest = XTest(idx);    % вход сети
YTest = YTest(idx);    % цели сети
XTrain
XTrain=XTrain(1:1000);
YTrain=YTrain(1:1000);

YPred = classify(net,XTest, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest');

acc = sum(YPred == YTest)./numel(YTest);  % точность сети
disp(acc);