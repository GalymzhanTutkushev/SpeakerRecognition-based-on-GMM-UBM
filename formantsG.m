
function FrsCell = formantsG(Y, Fs)

preemph = [1 0.97];%коэфициенты фильтрв
     
     Y=Y - mean(Y);                 %центрируем сигнал
     Y = filter(1,preemph,Y);

    
 FrsCell = CalcFormants(Y,Fs);
        nC = size(FrsCell);


end