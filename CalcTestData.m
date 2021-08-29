function TestData =  CalcTestData(Y0,J,Fs)

   Y=Y0(:,J);
   Blocks=SeparateWav(Y,Fs);
   Frs = GetFrameFormants(Blocks, Y, Fs);
   TestData = cell2mat(Frs);
        
end
