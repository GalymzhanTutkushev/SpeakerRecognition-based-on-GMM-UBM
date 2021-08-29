function FrsCell = GetFrameFormants(Block, Y0, Fs)

p = floor(3*log(Fs));%количество треугольных окон
preemph = [1 0.97];%коэфициенты фильтрв
%Frs = zeros(1,40);
DN=0.02*Fs;%длина кадра
NF=0.01*Fs;%шаг сдвига кадра

nBlocks = size(Block,1);

  FrsCell = cell(nBlocks,1);
 Y1 = cell(nBlocks,1);
 for I = 1:nBlocks
    Beg = Block(I,1);
    End = Block(I,2);
    Y1{I}=Y0(Beg:End);
 end
parfor (I = 1:nBlocks)

            Y=Y1{I};
            Y=Y - mean(Y);                 %центрируем сигнал
            Y = filter(1,preemph,Y);
         
            C = melcepst(Y,Fs,'dD',12,p,DN,NF)

        
%          C = length_norm(C);
%         C=cmvn(C);
%          C=wcmvn(C,301);
%          C=fea_warping(C,301); 
 
         FrsCell{I} = C;
        
     
                 

                    
end

end
 
                        
