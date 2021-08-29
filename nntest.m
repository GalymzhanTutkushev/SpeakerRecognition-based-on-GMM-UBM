PathSpeechTest='C:\Users\User\Desktop\t\';
    FileListTest = GetFileList(PathSpeechTest,2);

   Nt = length(FileListTest);
   [C_test,ID_test]=NN_train_VADst(1,Nt,PathSpeechTest,FileListTest);
 y = net(C_test');
       for ii=1:length(y)
            if(y(ii)>=0.5)
                y(ii)=1;
            else
                y(ii)=0;
            end
        end
 e = gsubtract(ID_test',y);
 figure, plotconfusion(ID_test',y)
 figure, ploterrhist(e)