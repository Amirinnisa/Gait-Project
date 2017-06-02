function th=threshold(Gz1,pk)
% ADAPTIVE THRESHOLD CALCULATION
% mean value of Gz signal
th5_Gz1 = mean(Gz1); 
    gr_meanGz1 = Gz1(Gz1>th5_Gz1);
    ls_meanGz1 = Gz1(Gz1<th5_Gz1);
    mean_Gz1a  = mean(gr_meanGz1);
    mean_Gz1b  = mean(ls_meanGz1);

%for peaks -> mid-swing @gait cycle
    th1_Gz1 = 0.6*(max(pk(:,3))); %valid local max: prec.min >= th1a
    th1a = max(pk(:,3))-th1_Gz1; %valid local max: prec.min >= th1a
%for peaks -> mid-swing @stride,each leg
    th2_Gz1 = 0.8*(mean_Gz1a); 
    
% for valleys -> IC, TC points
    th3_Gz1 = 0.8*abs(mean_Gz1b); %for IC, valid local minimum: prec.max > (local min+th3)
    th4_Gz1 = 0.8*(mean_Gz1b); %for TC, local minima < th4
    %th5_Gz1 for IC, local minima < th5
    th6_Gz1 = 2*th3_Gz1; %for TC, local minimum: prec.max > (local min+th6)
    
 ths=[th1_Gz1, th2_Gz1, th3_Gz1, th4_Gz1, th5_Gz1, th6_Gz1];
 th=ths';
end
