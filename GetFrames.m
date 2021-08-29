function [mm,nn] = GetFrames(Block, Y0, Fs,modelGMM, UBM)

p = floor(3*log(Fs));%количество треугольных окон
preemph = [1 0.97];%коэфициенты фильтрв
%Frs = zeros(1,40);
DN=0.02*Fs;%длина кадра
NF=0.01*Fs;%шаг сдвига кадра
nBlocks = size(Block,1);
% no=cell(nBlocks,1);yes=cell(nBlocks,1);

 trials = [1 1];
 Y1 = cell(nBlocks,1);
 Gm=zeros(nBlocks,1);Gn=zeros(nBlocks,1);
 for I = 1:nBlocks
    Beg = Block(I,1);
    End = Block(I,2);
    Y1{I}=Y0(Beg:End);
 end
parfor (I = 1:nBlocks)

            Y=Y1{I};
            Y=Y - mean(Y);                 %центрируем сигнал
            Y = filter(1,preemph,Y);
         
            C = melcepst(Y,Fs,'dD',12,p,DN,NF);
%             disp(size(Y))

            nC = size(C,1);
%          C = length_norm(C);
%          C=cmvn(C);
%          C=wcmvn(C,301);
%          C=fea_warping(C,301);       
%          FrsCell{I} = C;
                         FrsCell = C'
                         [m,n]=size(FrsCell);
                         TestData=mat2cell(FrsCell,m,n)
         
                         dy = score_gmm_trials(modelGMM, TestData, trials, UBM)
                         
                         Id1 = find(dy>0&dy<0.5);
                         Id2 = find(dy>=0.5&dy<1);   
                         Id3 = find(dy>=1);
                         Idx = 0.25*numel(Id1)+0.75*numel(Id2)+numel(Id3);
                         S = 100*Idx/nC;
                         srednee=mean(dy);
                         
%                          disp(dy)
%                          disp(S)
%                          disp(srednee)
                    if(S>50 && srednee>0.25)
                        
                        Gm(I)=1;
%                         yes{I}=Y;
%                          audiowrite(strcat('yes',num2str(I),'.wav'),Y,Fs);
                    else
                        
                        Gn(I)=1;
%                        no{I}=Y;
%                        try
%                        audiowrite(strcat('no',num2str(I),'.wav'),Y,Fs);
%                        catch
%                            continue
%                        end
                    end

                    
end

                        mm=sum(Gm);
                        nn=sum(Gn);
end
 
                        
