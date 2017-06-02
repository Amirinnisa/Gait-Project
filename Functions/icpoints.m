function pos_ic=icpoints(a,th1,th2,pk,pos_max)
% RANGE IC = t(pos_max) - t2 seconds
% t2 = 0.5s 
% hanya data dalam range tsb yang dipertimbangkan
pos_min = find(a(:,3)<th1);
pos_ic=[];
tempid = 0;
for j=1:length(pos_max)
   for k=1:length(pos_min)
       if ((a(pos_min(k),2)<(pk(pos_max(j),2)+0.5)) && (a(pos_min(k),2)>(pk(pos_max(j),2))))
           tx = find(pk(:,2)<a(pos_min(k),2));
          if(pk(tx(length(tx)),3)>(a(pos_min(k),3)+th2))
              if(tempid==0 || j~=tempid)
                pos_ic(j)=pos_min(k);
                tempid=j;
            elseif(j==tempid)    
                if(pos_min(k) < pos_ic(j))
                     pos_ic(j)=pos_min(k);
                     tempid=j;
                end    
              end
          else
              pos_ic(j)=pos_min(k)-1;%ini bener gak ya penanganan ke-dua nya?
              tempid=j;
          end
        end 
    end
end

% for j=1:length(pos_max)
%    for k=1:length(pos_min)
%        if ((a(pos_min(k),2)<(pk(pos_max(j),2)+0.5)) && (a(pos_min(k),2)>(pk(pos_max(j),2))))
%            tx = find(pk(:,2)<a(pos_min(k),2));
%           if(pk(tx(length(tx)),3)>(a(pos_min(k),3)+th2))
%               if(tempid==0 || j~=tempid)
%                 pos_ic(j)=pos_min(k);
%                 tempid=j;
%             elseif(j==tempid)    
%                 if(pos_min(k) < pos_ic(j))
%                      pos_ic(j)=pos_min(k);
%                      tempid=j;
%                 end    
%               end
%           else
%               pos_ic(j)=pos_min(k)-1;%ini bener gak ya penanganan keduanya?
%               tempid=j;
%           end
%         end 
%     end
% end
end
