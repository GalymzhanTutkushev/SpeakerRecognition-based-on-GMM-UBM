
function FrsCell = formantsG(Y, Fs)

preemph = [1 0.97];%����������� �������
     
     Y=Y - mean(Y);                 %���������� ������
     Y = filter(1,preemph,Y);

    
 FrsCell = CalcFormants(Y,Fs);
        nC = size(FrsCell);


end