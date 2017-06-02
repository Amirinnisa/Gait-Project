function gait(T,Ax,Ay,Az,Gx,Gy,Gz)
clear; clc; close all;
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% DATA SEBELUM PRE-PROCESSING  
% data = datasensor();
% WAKTU, FS, FC
% T = data(:,1);
    dt=zeros(999,1);
    for t=2:1000
        dt(t-1,1)=T(t,1)-T(t-1,1);
    end
    mean_t=mean(dt);
    fs=1/mean_t;
    fc=fs/5;

% PERCEPATAN AKSELEROMETER
% Ax = data(:,2);
% Ay = data(:,3);
% Az = data(:,4);

% KECEPATAN ANGULAR GIROSKOP
%koordinat giroskop wiimotionplus berbeda dari wiimote
%     Gz1 = data(:,5);

% Gx = data(:,5);
% Gy = data(:,6);
% Gz = data(:,7);

% -------------------------------------------------------------------
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% PRE-PROCESSING
% LOWPASS FILTERING --> AX1GZ1  
Gz1=filter(lp5orbt(fs,fc),Gz);
Ax1=filter(lp5orbt(fs,fc),Ax);

% Gz1=filter(lpcheb(fs,fc),Gz);
% Ax1=filter(lpcheb(fs,fc),Ax);

figure
subplot(221),plot(T,Gz),legend('kecepatan sudut unfiltered')
subplot(222),plot(T,Gz1),legend('kecepatan sudut filter fc=fs/10')
subplot(223),plot(T,Ax),legend('percepatan unfiltered')
subplot(224),plot(T,Ax1),legend('percepatan sudut filter fc=fs/10')
saveas(gcf,'data1_AxGz','fig');
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% PROCESSING
% FIND PEAKS -> midswing || VALLEYS -> IC/HS,TC/TO
pk = findpeaks(T,Gz1,0,min(Gz1),1,4);
a = findvalleys(T,Gz1,0,min(Gz1),1,4);

% ADAPTIVE THRESHOLD CALCULATION
th=threshold(Gz1,pk);
    
new_pos_max=midsw(pk,th(1)); %deteksi posisi mid_swing pada "pk"
% pos_ic = icpoints(a,th(2),th(3),pk,new_pos_max);%pakai th(2) u/ th1
pos_ic = icpoints(a,th(4),th(3),pk,new_pos_max);%pakai th(4) (th1 tc) u/ th1 ic
pos_tc = tcpoints(a,th(4),th(6),pk,new_pos_max);

% -------------------------------------------------------------------
% -------------------------------------------------------------------
% TITIK MID-SWING, INITIAL CONTACT, TERMINAL CONTACT
max = [pk(new_pos_max,2) pk(new_pos_max,3)];
%pre-kondisi untuk waktu IC dan TC
if(length(max)==length(pos_ic))
pos_ic = pos_ic(1:length(pos_ic));
pos_tc = pos_tc(1:length(pos_tc));
else
    if(pos_ic(1)==pos_ic(2))
        pos_ic = pos_ic(2:length(pos_ic));
        pos_tc = pos_tc(2:length(pos_tc));
    else
        pos_ic = pos_ic(1:length(pos_ic)-1);
        pos_tc = pos_tc(1:length(pos_tc)-1);
    end    
end
ic = [a(pos_ic,2) a(pos_ic,3)];
tc = [a(pos_tc,2) a(pos_tc,3)];

scatall(ic,tc,[T Gz1 Ax1]);
saveas(gcf,'data1_AxGzSCAT','fig');
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% T==ic(1,1) ~ T==ic(length(ic),1)
t1_ic=T(T>=T(T==ic(1,1))&T<=T(T==ic(2,1)));
t2_ic=T(T>=T(T==ic(2,1))&T<=T(T==ic(3,1)));

gz1_ic=Gz(T>=T(T==ic(1,1))&T<=T(T==ic(2,1)));
gz2_ic=Gz(T>=T(T==ic(2,1))&T<=T(T==ic(3,1)));
gzf1_ic=Gz1(T>=T(T==ic(1,1))&T<=T(T==ic(2,1)));
gzf2_ic=Gz1(T>=T(T==ic(2,1))&T<=T(T==ic(3,1)));

ax1_ic=Ax(T>=T(T==ic(1,1))&T<=T(T==ic(2,1)));
ax2_ic=Ax(T>=T(T==ic(2,1))&T<=T(T==ic(3,1)));
axf1_ic=Ax1(T>=T(T==ic(1,1))&T<=T(T==ic(2,1)));
axf2_ic=Ax1(T>=T(T==ic(2,1))&T<=T(T==ic(3,1)));
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% SUDUT V.01 T=1:1000
% dengan regresi
% for iag=1:length(T)-1
%     deg(iag+1)=trapz(T(1:iag+1),Gz1(1:iag+1));
% end
% deg(1) = 0;

% REGRESI V.02 --> CARI KONSTANTA
% untuk cek balik differensialnya
% for ip=1:length(T)-1
%     Gz1a(ip:ip+1) = gradient(deg(ip:ip+1),T(ip+1)-T(ip));
% end
% % Cdeg = Gz1a'-Gz1;
% degnew = deg'-Cdeg;

% REGRESI v.01 --> PAKE POLYFIT
% pdeg=polyfit(T,deg',1); %regresi sudut
% odeg=pdeg(1)*T+pdeg(2); %offset sudut
% degnew=deg'-odeg; %sudut hasil regresi

% PARAMETER: KNEE ANGLES 1
% dg = 90-deg';
% dgnew = 90-degnew;
% 
% figure
% subplot(211),plot(T,deg,T,degnew),legend('sudut','sudut(reg)')
% subplot(212),plot(T,dg,T,dgnew),legend('90-sudut','90-sudut (reg)')
% -------------------------------------------------------------------
% SUDUT V.02 T==ic(1,1) ~ T==ic(length(ic),1)
incl1(1)=0;
for iag=1:length(t1_ic)-1
       incl1(iag+1)=trapz(t1_ic(1:iag+1),gzf1_ic(1:iag+1));
end
incl2(1)=0;
for iag=1:length(t2_ic)-1
       incl2(iag+1)=trapz(t2_ic(1:iag+1),gzf2_ic(1:iag+1));
end

% PARAMETER: KNEE ANGLES 
incl1=incl1';
incl2=incl2';
incl1g = 90-incl1;
incl2g = 90-incl2;

figure
subplot(311),plot(t1_ic,gzf1_ic,t2_ic,gzf2_ic),legend('kec.sudut ic1-ic2','kec.sudut ic2-ic3')
subplot(312),plot(t1_ic,incl1,t2_ic,incl2),legend('sudut ic1-ic2','sudut ic2-ic3')
subplot(313),plot(t1_ic,incl1g,t2_ic,incl2g),legend('90-sudut ic1-ic2','90-sudut ic2-ic3')
saveas(gcf,'data1_sudut','fig');
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% PARAMETER: TIMES
%stride times or CYCLE TIMES
idsr=1;
for ts=1:length(ic)-1
    tsr(idsr) = ic(ts+1,1)-ic(ts,1);
    idsr=idsr+1;
end
mean_tsr = mean(tsr);

% -------------------------------------------------------------------
% swing times
idsw=1;
for ts=1:length(ic)
    tsw(idsw) = ic(ts,1)-tc(ts,1);
    idsw=idsw+1;
end
mean_tsw = mean(tsw);

% -------------------------------------------------------------------
% stance times
idst=1;
for ts=1:length(tsr)
    tst(idst) = tsr(ts)-tsw(ts+1);
    idst=idst+1;
end
mean_tst = mean(tst);

temps = [max, tc, ic];
par_temps = [mean_tsr mean_tsw mean_tst];
% par_temp = {'t stride','t swing','t stance'; mean_tsr mean_tsw mean_tst};
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% PARAMETER: CADENCE (steps/minute)
% stride time = 120/cadence
cadence = 120/mean_tsr;
cadence_r=round(cadence);
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% PARAMETER: LENGTHS
% double integral Ax filtered T
vx1(1)=0;
disX1(1)=0;
for iag=1:length(T)-1
       vx1(iag+1)=trapz(T(1:iag+1),Ax1(1:iag+1));
       disX1(iag+1)=trapz(T(1:iag+1),vx1(1:iag+1));
end
% stride length T filtered (sum)
for n=1:length(ic)-1
    posl1=find(T==ic(n,1));
    posl2=find(T==ic(n+1,1));
    sl1(n)=disX1(posl2)-disX1(posl1);
end

figure
subplot(211),plot(T,vx1),legend('kec.linier filtered')
subplot(212),plot(T,disX1),legend('perpindahan filtered')
saveas(gcf,'data1_VxDxFilter','fig');

SL = mean(sl1(:));
V = SL*cadence/120;

% -------------------------------------------------------------------
% coba cara lain
       vx2=trapz(T,Ax1);
       disX2=trapz(T,vx1);

% PENTING
% untuk cek balik differensialnya
%     for ip=1:length(T)-1
%         pd(ip:ip+1) = gradient(p(ip:ip+1),T(ip+1)-T(ip));
%     end
%     
%     figure, plot(T,pd);

% integral
% x0 = T(1);
% y0 = Ax1(1);
% kecax1(1) = 0;
% for i=2:length(T)
%     kecax1(i)=(T(i)-x0)*(Ax1(i)+y0)/2;
% end
% s0 = kecax1(1);
% jarax1(1) = 0;
% for j=2:length(T)
%     jarax1(j)=(T(j)-x0)*(kecax1(j)+s0)/2;
% end
% figure
% subplot(211),plot(T,kecax1),legend('kecax1')
% subplot(212),plot(T,jarax1),legend('jarax1')

% -------------------------------------------------------------------
% -------------------------------------------------------------------
% double integral Ax filtered
% T==ic(1,1) ~ T==ic(length(ic),1)
vl1(1)=0;
for iag=1:length(t1_ic)-1
       vl1(iag+1)=trapz(t1_ic(1:iag+1),axf1_ic(1:iag+1));
       dlx1(iag+1)=trapz(t1_ic(1:iag+1),vl1(1:iag+1));
end
for iag=1:length(t2_ic)-1
       vl2(iag+1)=trapz(t2_ic(1:iag+1),axf2_ic(1:iag+1));
       dlx2(iag+1)=trapz(t2_ic(1:iag+1),vl2(1:iag+1));
end

DLX1=(dlx1(length(dlx1))-dlx1(1));
DLX2=(dlx2(length(dlx2))-dlx2(1));
VL1 = DLX1*cadence/120;
VL2 = DLX2*cadence/120;

% stride length ic1~ic3 filtered
DLX= mean([DLX1 DLX2]);
VL = DLX*cadence/120;
% -------------------------------------------------------------------
% double integral Ax unfiltered
% T==ic(1,1) ~ T==ic(length(ic),1)
vu1(1)=0;
for iag=1:length(t1_ic)-1
       vu1(iag+1)=trapz(t1_ic(1:iag+1),ax1_ic(1:iag+1));
       dx1(iag+1)=trapz(t1_ic(1:iag+1),vu1(1:iag+1));
end
vu2(1)=0;
for iag=1:length(t2_ic)-1
       vu2(iag+1)=trapz(t2_ic(1:iag+1),ax2_ic(1:iag+1));
       dx2(iag+1)=trapz(t2_ic(1:iag+1),vu2(1:iag+1));
end

DX1 =(dx1(length(dx1))-dx1(1));
DX2 =(dx2(length(dx2))-dx2(1));
VU1 = DX1*cadence/120;
VU2 = DX2*cadence/120;

% stride length ic1~ic3 unfiltered
DX = mean([DX1 DX2]);
VU = DX*cadence/120;

figure
subplot(221),plot(t1_ic,axf1_ic),legend('aksel.linier ic1-ic2 filtered')
subplot(222),plot(t2_ic,axf2_ic),legend('aksel.linier ic2-ic3 filtered')
subplot(223),plot(t1_ic,ax1_ic),legend('aksel.linier ic1-ic2 unfiltered')
subplot(224),plot(t2_ic,ax2_ic),legend('aksel.linier ic2-ic3 unfiltered')
saveas(gcf,'data1_Aksel','fig');

figure
subplot(221),plot(t1_ic,vl1,t2_ic,vl2),legend('kec.linier ic1-ic2 filtered','kec.linier ic2-ic3 filtered')
subplot(222),plot(t1_ic,dlx1,t2_ic,dlx2),legend('jarak ic1-ic2 filtered','jarak ic2-ic3 filtered')
subplot(223),plot(t1_ic,vu1,t2_ic,vu2),legend('kec.linier ic1-ic2 unfiltered','kec.linier ic2-ic3 unfiltered')
subplot(224),plot(t1_ic,dx1,t2_ic,dx2),legend('jarak ic1-ic2 unfiltered','jarak ic2-ic3 unfiltered')
saveas(gcf,'data1_KecJarak','fig');
% -------------------------------------------------------------------
% -------------------------------------------------------------------

% stride length
% for n=1:length(ic)-1
%     posl1=find(T==ic(n,1));
%     posl2=find(T==ic(n+1,1));
%     sl(n)=jarak(posl2)-jarak(posl1);
% end
% mean_sl = mean(sl);

% -------------------------------------------------------------------
% swing length
% for n=1:length(ic)
%     posw1=find(T==tc(n,1));
%     posw2=find(T==ic(n,1));
%     sw(n)=jarak(posw2)-jarak(posw1);
% end
% mean_sw = mean(sw);

% -------------------------------------------------------------------
% stance length
% for n=1:length(ic)-1
%     post1=find(T==ic(n,1));
%     post2=find(T==tc(n+1,1));
%     st(n)=jarak(post2)-jarak(post1);
% end
% mean_st = mean(st);

% -------------------------------------------------------------------
% step length
% mean_stepl = mean([mean_sw mean_st]);

% -------------------------------------------------------------------
% lengths = [sl', sw', st'];
% par_lengths = {'stride','swing','stance','step'; mean_sl mean_sw mean_st mean_stepl};

% -------------------------------------------------------------------
% -------------------------------------------------------------------
% PARAMETER: SPEEDS
% speed (m/s) = stride length (m)/cycle time (s)

% v = mean_sl/mean_tsr;
% CV = {'Cadence(steps/min)','Walking Speed (m/s)'; cadence v};


% for n=1:length(ic)-1
%     sumXY(n) = sum([disX(:,n) disY(:,n)]);
%     V(n) = sumXY(n)/tsr(n);
% end

% -------------------------------------------------------------------
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% SIMPAN DAN TAMPIL GRAFIK DATA TURUNAN AX1 -> KECEPATAN+JARAK 
% figure
%     subplot(211), plot(T,vlin);
%     subplot(212), plot(T,jarak);
% scatall(ic,tc, vjar);
%     saveas(gcf,'13febVS_13jan_data1','fig');

% TAMPIL GRAFIK DENGAN TITIK2 IC DAN TC
% DATA AWAL
% scatall(ic,tc, data);

% SIMPAN DAN TAMPIL GRAFIK DENGAN TITIK2 MID-SWING,IC, DAN TC
% GZ1+AX1+sudut
% data2=[T, deg, ang];
% scatpts(max, ic, tc, Gz1, data2);

% -------------------------------------------------------------------
% -------------------------------------------------------------------
% -------------------------------------------------------------------
% SIMPAN DAN TAMPIL GRAFIK DATA AWAL (ALL) 
% TANPA TITIK2 MID-SWING,IC, DAN TC

% TAMPIL GRAFIK [AX AY AZ] [GX GY GZ] dan [all]
figure ('Name','data1_AX','NumberTitle','off')
    title('Grafik Akselerasi X');
    xlabel('Waktu (s)');
    ylabel('Akselerasi (m/s2)');
    line(T,Ax,'marker','.','color','black');
    saveas(gcf,'data1_AX','fig');
figure ('Name','data1_AY','NumberTitle','off')
    title('Grafik Akselerasi Y');
    xlabel('Waktu (s)');
    ylabel('Akselerasi (m/s2)');
    line(T,Ay,'marker','.','color','red');
    saveas(gcf,'data1_AY','fig');
figure ('Name','data1_AZ','NumberTitle','off')
    title('Grafik Akselerasi Z');
    xlabel('Waktu (s)');
    ylabel('Akselerasi (m/s2)');
    line(T,Az,'marker','.','color','blue');
    saveas(gcf,'data1_AZ','fig');
    
figure ('Name','data1_GX','NumberTitle','off')
    title('Grafik Kecepatan Sudut X');
    xlabel('Waktu (s)');
    ylabel('Kecepatan Sudut (sudut/s)');
    line(T,Gx,'marker','.','color','black');
    saveas(gcf,'data1_GX','fig');
figure ('Name','data1_GY','NumberTitle','off')
    title('Grafik Kecepatan Sudut Y');
    xlabel('Waktu (s)');
    ylabel('Kecepatan Sudut (sudut/s)');
    line(T,Gy,'marker','.','color','red');
    saveas(gcf,'data1_GY','fig');
figure ('Name','data1_GZ','NumberTitle','off')
    title('Grafik Kecepatan Sudut Z');
    xlabel('Waktu (s)');
    ylabel('Kecepatan Sudut (sudut/s)');
    line(T,Gz,'marker','.','color','blue');
    saveas(gcf,'data1_GZ','fig');
    
figure ('Name','data1_all','NumberTitle','off')
    subplot(6,1,1);line(T,Ax,'marker','.','color','black');
    title('Grafik Akselerasi dan Kecepatan Sudut');
    subplot(6,1,2);line(T,Ay,'marker','.','color','red');
    ylabel('Akselerasi (m/s2)');
    subplot(6,1,3);line(T,Az,'marker','.','color','blue');
    subplot(6,1,4);line(T,Gx,'marker','.','color','black');
    subplot(6,1,5);line(T,Gy,'marker','.','color','red');
    ylabel('Kecepatan Sudut (sudut/s)');
    subplot(6,1,6);line(T,Gz,'marker','.','color','blue');
    xlabel('Waktu (s)');
    saveas(gcf,'data1_all','fig');
end