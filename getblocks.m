function blocks=getblocks(block)

nblock=size(block,1);
bbb=0;ii=0;
for i=1:nblock
    
    if(block(i,3)==1)
    
    bbb=bbb+1;
    else
        if(bbb>1)
    if(block(i-1,3)==1)
    End=block(i,2);
    Begin=block(i-bbb,1);
    ii=ii+1;
    blocks(ii,1)=Begin;
    blocks(ii,2)=End;
    bbb=0;
    end
        end
    end
    
end