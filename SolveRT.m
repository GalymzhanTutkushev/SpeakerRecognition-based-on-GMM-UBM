function Result = SolveRT(ResFmnt2,ResMFCC2,fw,mw)
Res=cell(1,4);
R = fw*ResFmnt2{3}+mw*ResMFCC2{3};
 R = sortrows(R,[1 -3]);
 Result = R;
end

f=cell(4,1)
f{1}=['a' 'd']
f{2}= [5 ;2]
