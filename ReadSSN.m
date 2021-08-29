function [buff0_16, buff1_16] = ReadSSN(fileName)
warning('off');
global MainPath;

dllPath  = strcat(MainPath, 'SSN\ssn-parser-dll');
headerPath = strcat(MainPath, 'SSN\ssn-client-cplus-header');
%загрузка библиотеки
loadlibrary(dllPath,headerPath);

 MAX_SPEECH_SIZE_INBYTE =  7200000;

 %указатели на массивы и переменные
 buf0 = libpointer('uint8Ptr',zeros(MAX_SPEECH_SIZE_INBYTE,1));
 buf1 = libpointer('uint8Ptr',zeros(MAX_SPEECH_SIZE_INBYTE,1));
 buf0len = libpointer('int32Ptr',0);
 buf1len = libpointer('int32Ptr',0);
 
 libName = 'ssn0x2Dparser0x2Ddll';
 funcName = 'main_decode';
 fileNameSize = length(fileName);
 
 %вызов функций с библиотеки
 calllib(libName,funcName,fileName,fileNameSize,buf0,buf1,buf0len,buf1len);
 
 %получаем значени€
 buffer0 = buf0.Value;
 buffer1 = buf1.Value;
 buff0Length = buf0len.Value;
 buff1Length = buf1len.Value;
 
 buffer0 = buffer0(1:buff0Length);
 buffer1 = buffer1(1:buff1Length);
 
 buff0_16Len = fix(buff0Length/2);
 buff0_16 = zeros(1,buff0_16Len);
 
 buff1_16Len = fix(buff1Length/2);
 buff1_16 = zeros(1,buff1_16Len); 
%%
%–асчет значений сигнала по двум байтам(LSB,MSB) дл€ 1-ого спикера
 b0LSB = buffer0(1:2:buff0Length);
 b0MSB = buffer0(2:2:buff0Length);
 
 parfor (idx = 1:buff0_16Len,4)
  
    shiftedMSB = bitshift(int16(b0MSB(idx)),8,'int16');
    buff0_16(idx) = double(bitor(shiftedMSB,int16(b0LSB(idx))));
    
 end;
 
 buff0_16 = buff0_16 - mean(buff0_16);
 buff0_16 = buff0_16/max(abs(buff0_16));
 
 %%
 %–асчет значений сигнала по двум байтам(LSB,MSB) дл€ 2-ого спикера
 b1LSB = buffer1(1:2:buff1Length);
 b1MSB = buffer1(2:2:buff1Length);
 
 parfor (jdx = 1:buff1_16Len,4)
  
    shiftedMSB = bitshift(int16(b1MSB(jdx)),8,'int16');
    buff1_16(jdx) = double(bitor(shiftedMSB,int16(b1LSB(jdx))));
    
 end;
 
 buff1_16 = buff1_16 - mean(buff1_16);
 buff1_16 = buff1_16/max(abs(buff1_16));
 
%выгрузка библиотеки
unloadlibrary('ssn0x2Dparser0x2Ddll');
end