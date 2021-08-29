function block=BuildBlocks(s)
ii=1;
 s=vertcat([0 0 0],s,[0 0 0]);
for i=1:length(s)-1
    
    if(s(i+1,3)==1 && s(i,3)==0) 
        
        Beg=s(i+1,1)-1;
        block(ii,1)=Beg;
    end
    if (s(i+1,3)==0 && s(i,3)==1) 
        End=s(i,2);
        block(ii,2)=End;
        if (End-Beg)>800
        ii=ii+1;
        end
    end
        
    
end

end