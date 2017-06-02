 function new_pos_max=midsw(peaks,th)
% jika dalam range t1 terdapat dua peaks, pilih yang terbesar
% t1 = 0.5s
pos_max=find(peaks(:,3)>th);
new_pos_max=[];
index=0;
i=1;
while(i<=length(pos_max))
    if (i~=length(pos_max))        
        if(peaks(pos_max(i+1),2)-peaks(pos_max(i),2)<0.5)
           if( peaks(pos_max(i+1),3)>peaks(pos_max(1),3))
               new_pos_max(index+1)=pos_max(i+1);
               index=index+1;
               i = i+2;
           else
               new_pos_max(index+1)=pos_max(i);
               index=index+1;
               i = i+2;
           end    
        else
            new_pos_max(index+1)=pos_max(i);
            index=index+1;
            i = i+1;
        end
    else
        new_pos_max(index+1)=pos_max(i);
        index=index+1;
        i = i+1;
    end
end
end