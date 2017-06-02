clear all
clc
close all

data='knee.xlsx';
T = xlsread(data,'M1:M101');

t1a   = xlsread(data,'A4:A102');
it1a   = xlsread(data,'B4:B102');
t1b   = xlsread(data,'C4:C92');
it1b   = xlsread(data,'D4:D92');

s1a   = xlsread(data,'N4:N94');
is1a   = xlsread(data,'O4:O94');
s1b   = xlsread(data,'P4:P100');
is1b   = xlsread(data,'Q4:Q100');
%--------------------------------------------------------------------------
t2a   = xlsread(data,'E4:E83');
it2a   = xlsread(data,'F4:F83');
t2b   = xlsread(data,'G4:G92');
it2b   = xlsread(data,'H4:H92');

s2a   = xlsread(data,'R4:R85');
is2a   = xlsread(data,'S4:S85');
s2b   = xlsread(data,'T4:T99');
is2b   = xlsread(data,'U4:U99');
%--------------------------------------------------------------------------
t3a   = xlsread(data,'I4:I77');
it3a   = xlsread(data,'J4:J77');
t3b   = xlsread(data,'K4:K77');
it3b   = xlsread(data,'L4:L77');

s3a   = xlsread(data,'V4:V85');
is3a   = xlsread(data,'W4:W85');
s3b   = xlsread(data,'X4:X87');
is3b   = xlsread(data,'Y4:Y87');
%--------------------------------------------------------------------------
p_t1a=polyfit(t1a,it1a,10);
p_t2a=polyfit(t2a,it2a,10);
p_t3a=polyfit(t3a,it3a,10);
p_s1a=polyfit(s1a,is1a,10);
p_s2a=polyfit(s2a,is2a,10);
p_s3a=polyfit(s3a,is3a,10);
p_t1b=polyfit(t1b,it1b,10);
p_t2b=polyfit(t2b,it2b,10);
p_t3b=polyfit(t3b,it3b,10);
p_s1b=polyfit(s1b,is1b,10);
p_s2b=polyfit(s2b,is2b,10);
p_s3b=polyfit(s3b,is3b,10);

for i=1:length(T)
nt1a(i)=p_t1a(1)*(T(i)^10)+p_t1a(2)*(T(i)^9)+p_t1a(3)*(T(i)^8)+p_t1a(4)*(T(i)^7)+p_t1a(5)*(T(i)^6)+p_t1a(6)*(T(i)^5)+p_t1a(7)*(T(i)^4)+p_t1a(8)*(T(i)^3)+p_t1a(9)*(T(i)^2)+p_t1a(10)*T(i)+p_t1a(11);
nt1b(i)=p_t1b(1)*(T(i)^10)+p_t1b(2)*(T(i)^9)+p_t1b(3)*(T(i)^8)+p_t1b(4)*(T(i)^7)+p_t1b(5)*(T(i)^6)+p_t1b(6)*(T(i)^5)+p_t1b(7)*(T(i)^4)+p_t1b(8)*(T(i)^3)+p_t1b(9)*(T(i)^2)+p_t1b(10)*T(i)+p_t1b(11);
nt2a(i)=p_t2a(1)*(T(i)^10)+p_t2a(2)*(T(i)^9)+p_t2a(3)*(T(i)^8)+p_t2a(4)*(T(i)^7)+p_t2a(5)*(T(i)^6)+p_t2a(6)*(T(i)^5)+p_t2a(7)*(T(i)^4)+p_t2a(8)*(T(i)^3)+p_t2a(9)*(T(i)^2)+p_t2a(10)*T(i)+p_t2a(11);
nt2b(i)=p_t2b(1)*(T(i)^10)+p_t2b(2)*(T(i)^9)+p_t2b(3)*(T(i)^8)+p_t2b(4)*(T(i)^7)+p_t2b(5)*(T(i)^6)+p_t2b(6)*(T(i)^5)+p_t2b(7)*(T(i)^4)+p_t2b(8)*(T(i)^3)+p_t2b(9)*(T(i)^2)+p_t2b(10)*T(i)+p_t2b(11);
nt3a(i)=p_t3a(1)*(T(i)^10)+p_t3a(2)*(T(i)^9)+p_t3a(3)*(T(i)^8)+p_t3a(4)*(T(i)^7)+p_t3a(5)*(T(i)^6)+p_t3a(6)*(T(i)^5)+p_t3a(7)*(T(i)^4)+p_t3a(8)*(T(i)^3)+p_t3a(9)*(T(i)^2)+p_t3a(10)*T(i)+p_t3a(11);
nt3b(i)=p_t3b(1)*(T(i)^10)+p_t3b(2)*(T(i)^9)+p_t3b(3)*(T(i)^8)+p_t3b(4)*(T(i)^7)+p_t3b(5)*(T(i)^6)+p_t3b(6)*(T(i)^5)+p_t3b(7)*(T(i)^4)+p_t3b(8)*(T(i)^3)+p_t3b(9)*(T(i)^2)+p_t3b(10)*T(i)+p_t3b(11);
ns1a(i)=p_s1a(1)*(T(i)^10)+p_s1a(2)*(T(i)^9)+p_s1a(3)*(T(i)^8)+p_s1a(4)*(T(i)^7)+p_s1a(5)*(T(i)^6)+p_s1a(6)*(T(i)^5)+p_s1a(7)*(T(i)^4)+p_s1a(8)*(T(i)^3)+p_s1a(9)*(T(i)^2)+p_s1a(10)*T(i)+p_s1a(11);
ns1b(i)=p_s1b(1)*(T(i)^10)+p_s1b(2)*(T(i)^9)+p_s1b(3)*(T(i)^8)+p_s1b(4)*(T(i)^7)+p_s1b(5)*(T(i)^6)+p_s1b(6)*(T(i)^5)+p_s1b(7)*(T(i)^4)+p_s1b(8)*(T(i)^3)+p_s1b(9)*(T(i)^2)+p_s1b(10)*T(i)+p_s1b(11);
ns2a(i)=p_s2a(1)*(T(i)^10)+p_s2a(2)*(T(i)^9)+p_s2a(3)*(T(i)^8)+p_s2a(4)*(T(i)^7)+p_s2a(5)*(T(i)^6)+p_s2a(6)*(T(i)^5)+p_s2a(7)*(T(i)^4)+p_s2a(8)*(T(i)^3)+p_s2a(9)*(T(i)^2)+p_s2a(10)*T(i)+p_s2a(11);
ns2b(i)=p_s2b(1)*(T(i)^10)+p_s2b(2)*(T(i)^9)+p_s2b(3)*(T(i)^8)+p_s2b(4)*(T(i)^7)+p_s2b(5)*(T(i)^6)+p_s2b(6)*(T(i)^5)+p_s2b(7)*(T(i)^4)+p_s2b(8)*(T(i)^3)+p_s2b(9)*(T(i)^2)+p_s2b(10)*T(i)+p_s2b(11);
ns3a(i)=p_s3a(1)*(T(i)^10)+p_s3a(2)*(T(i)^9)+p_s3a(3)*(T(i)^8)+p_s3a(4)*(T(i)^7)+p_s3a(5)*(T(i)^6)+p_s3a(6)*(T(i)^5)+p_s3a(7)*(T(i)^4)+p_s3a(8)*(T(i)^3)+p_s3a(9)*(T(i)^2)+p_s3a(10)*T(i)+p_s3a(11);
ns3b(i)=p_s3b(1)*(T(i)^10)+p_s3b(2)*(T(i)^9)+p_s3b(3)*(T(i)^8)+p_s3b(4)*(T(i)^7)+p_s3b(5)*(T(i)^6)+p_s3b(6)*(T(i)^5)+p_s3b(7)*(T(i)^4)+p_s3b(8)*(T(i)^3)+p_s3b(9)*(T(i)^2)+p_s3b(10)*T(i)+p_s3b(11);
end

l1a = nt1a-ns1a;
l2a = nt2a-ns2a;
l3a = nt3a-ns3a;
l1b = nt1b-ns1b;
l2b = nt2b-ns2b;
l3b = nt3b-ns3b;

figure
subplot(321), plot(t1a,it1a,T,nt1a,s1a,is1a,T,ns1a,T,l1a),legend('it1a','nt1a','is1a','ns1a','l1a')
subplot(322), plot(t1b,it1b,T,nt1b,s1b,is1b,T,ns1b,T,l1b),legend('it1b','nt1b','is1b','ns1b','l1b')
subplot(323), plot(t2a,it2a,T,nt2a,s2a,is2a,T,ns2a,T,l2a),legend('it2a','nt2a','is2a','ns2a','l2a')
subplot(324), plot(t2b,it2b,T,nt2b,s2b,is2b,T,ns2b,T,l2b),legend('it2b','nt2b','is2b','ns2b','l2b')
subplot(325), plot(t3a,it3a,T,nt3a,s3a,is3a,T,ns3a,T,l3a),legend('it3a','nt3a','is3a','ns3a','l3a')
subplot(326), plot(t3b,it3b,T,nt3b,s3b,is3b,T,ns3b,T,l3b),legend('it3b','nt3b','is3b','ns3b','l3b')