function P=findpeaks(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup)
% function P=findpeaks(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup)
% Function to locate the positive peaks in a noisy x-y data
% set.  Detects peaks by looking for downward zero-crossings
% in the first derivative that exceed SlopeThreshold.
% Returns list (P) containing peak number and
% position, height, and width of each peak. SlopeThreshold,
% AmpThreshold, and smoothwidth control sensitivity
% Higher values will neglect smaller features. Peakgroup
% is the number of points around the "top part" of the peak.
% T. C. O'Haver, 1995.  Version 3  Last revised June, 2011
smoothwidth=round(smoothwidth);
peakgroup=round(peakgroup);
d=fastsmooth(deriv(y),smoothwidth);
n=round(peakgroup/2+1);
P=[0 0 0 0];
vectorlength=length(y);
peak=1;
AmpTest=AmpThreshold;
for j=smoothwidth:length(y)-smoothwidth,
   if sign(d(j)) > sign (d(j+1)), % Detects zero-crossing
     if d(j)-d(j+1) > SlopeThreshold*y(j), % if slope of derivative is larger than SlopeThreshold
        if y(j) > AmpTest,  % if height of peak is larger than AmpThreshold
          for k=1:peakgroup, % Create sub-group of points near peak
              groupindex=j+k-n+1;
              if groupindex<1, groupindex=1;end
              if groupindex>vectorlength, groupindex=vectorlength;end
            xx(k)=x(groupindex);yy(k)=y(groupindex);
          end
          [coef,S,MU]=polyfit(xx,log(abs(yy)),2);  % Fit parabola to log10 of sub-group with centering and scaling
          c1=coef(3);c2=coef(2);c3=coef(1);
          PeakX=-((MU(2).*c2/(2*c3))-MU(1));   % Compute peak position and height of fitted parabola
          PeakY=exp(c1-c3*(c2/(2*c3))^2);
          MeasuredWidth=norm(MU(2).*2.35703/(sqrt(2)*sqrt(-1*c3)));
          % if the peak is too narrow for least-squares technique to work
          % well, just use the max value of y in the sub-group of points near peak.
          if peakgroup<7,
             PeakY=max(yy);
             pindex=val2ind(yy,PeakY);
             PeakX=xx(pindex(1));
          end    
          % Construct matrix P. One row for each peak 
          % detected, containing the peak number, peak 
          % position (x-value) and peak height (y-value).
          P(peak,:) = [round(peak) PeakX PeakY MeasuredWidth];
          peak=peak+1;
        end
      end
   end
end
% ----------------------------------------------------------------------
function [index,closestval]=val2ind(x,val)
% Returns the index and the value of the element of vector x that is closest to val
% If more than one element is equally close, returns vectors of indicies and values
% Tom O'Haver (toh@umd.edu) October 2006
% Examples: If x=[1 2 4 3 5 9 6 4 5 3 1], then val2ind(x,6)=7 and val2ind(x,5.1)=[5 9]
% [indices values]=val2ind(x,3.3) returns indices = [4 10] and values = [3 3]
dif=abs(x-val);
index=find((dif-min(dif))==0);
closestval=x(index);

function d=deriv(a)
% First derivative of vector using 2-point central difference.
%  T. C. O'Haver, 1988.
n=length(a);
d(1)=a(2)-a(1);
d(n)=a(n)-a(n-1);
for j = 2:n-1;
  d(j)=(a(j+1)-a(j-1)) ./ 2;
end

function SmoothY=fastsmooth(Y,w,type,ends)
% fastbsmooth(Y,w,type,ends) smooths vector Y with smooth 
%  of width w. Version 2.0, May 2008.
% The argument "type" determines the smooth type:
%   If type=1, rectangular (sliding-average or boxcar) 
%   If type=2, triangular (2 passes of sliding-average)
%   If type=3, pseudo-Gaussian (3 passes of sliding-average)
% The argument "ends" controls how the "ends" of the signal 
% (the first w/2 points and the last w/2 points) are handled.
%   If ends=0, the ends are zero.  (In this mode the elapsed 
%     time is independent of the smooth width). The fastest.
%   If ends=1, the ends are smoothed with progressively 
%     smaller smooths the closer to the end. (In this mode the  
%     elapsed time increases with increasing smooth widths).
% fastsmooth(Y,w,type) smooths with ends=0.
% fastsmooth(Y,w) smooths with type=1 and ends=0.
% Example:
% fastsmooth([1 1 1 10 10 10 1 1 1 1],3)= [0 1 4 7 10 7 4 1 1 0]
% fastsmooth([1 1 1 10 10 10 1 1 1 1],3,1,1)= [1 1 4 7 10 7 4 1 1 1]
%  T. C. O'Haver, May, 2008.
if nargin==2, ends=0; type=1; end
if nargin==3, ends=0; end
  switch type
    case 1
       SmoothY=sa(Y,w,ends);
    case 2   
       SmoothY=sa(sa(Y,w,ends),w,ends);
    case 3
       SmoothY=sa(sa(sa(Y,w,ends),w,ends),w,ends);
  end

function SmoothY=sa(Y,smoothwidth,ends)
w=round(smoothwidth);
SumPoints=sum(Y(1:w));
s=zeros(size(Y));
halfw=round(w/2);
L=length(Y);
for k=1:L-w,
   s(k+halfw-1)=SumPoints;
   SumPoints=SumPoints-Y(k);
   SumPoints=SumPoints+Y(k+w);
end
s(k+halfw)=sum(Y(L-w+1:L));
SmoothY=s./w;
% Taper the ends of the signal if ends=1.
  if ends==1,
    startpoint=(smoothwidth + 1)/2;
    SmoothY(1)=(Y(1)+Y(2))./2;
    for k=2:startpoint,
       SmoothY(k)=mean(Y(1:(2*k-1)));
       SmoothY(L-k+1)=mean(Y(L-2*k+2:L));
    end
    SmoothY(L)=(Y(L)+Y(L-1))./2;
  end
% ----------------------------------------------------------------------

