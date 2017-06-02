function all=datasensor(kal,data)
% function all=datasensor()

% clear;clc;close all
% JANGAN LUPA CEK "NAMA FILE", "KOLOM", "RANGE", & "INDEX" (untuk i)
% -------------------------------------------------------------------
% UNTUK FILE EXCEL
% lihat ekstensi file excel "*.XLS" (excel 2003) atau "*.XLSX" (excel 2007)

%     kal='kal1.xlsx';
%     data='data1.xlsx';

% -------------------------------------------------------------------    
% kal1ibrasi giroskop XYZ -> G0 = [G0X G0Y G0Z]
% "G0" = giroskop raw values saat diam/kal1ibrasi
% "Tkal1" = waktu saat giroskop raw values saat diam/kal1ibrasi
% "s" = shank
% UNTUK FILE EXCEL
% lihat ekstensi file excel "*.XLS" (excel 2003) atau "*.XLSX" (excel 2007)
    A0s   = xlsread(kal,'E2:G1001');
    G0s   = xlsread(kal,'H2:J1001');

    % konversi waktu ms -> s
%     T0s = xlsread(kal1,'A2:A1001');
%     T = T0s/1000;
    
    % nilai kal1ibrasi -> nilai rata-rata unit G0X, G0Y, G0Z
    Acals = mean(A0s);
    Gcals = mean(G0s);
% -------------------------------------------------------------------    

% data giroskop XYZ -> Gus = [GusX GusY GusZ]
% "Gu" = nilai giroskop raw values saat berjalan
% "FB" = Fast Bit; bit indikator untuk mode cepat (rollfast, pitchfast,
% yawpast)
% "s" = shank
% UNTUK FILE EXCEL
    Tus = xlsread(data,'A2:A1001');
    Tu = Tus/1000;
    Aus = xlsread(data,'E2:G1001');
    Gus = xlsread(data,'H2:J1001');
    FBs = xlsread(data,'B2:D1001');
    
    dt=zeros(999,1);
    for t=2:1000
        dt(t-1,1)=Tu(t,1)-Tu(t-1,1);
    end
    mean_t=mean(dt);
    fs=1/mean_t;
% -------------------------------------------------------------------
% REFERENSI UNTUK KALIBRASI
% uref = 8192; unit referensi
% vref = 1350; mV referensi	
% vds = 2.27; mV/deg/s 
% dref = vref/vds = 594.7136564 deg/s 
% dalam (unit/deg/s)--> referensi unit: udref = uref/dref   
udref = 13.7746963;
% -------------------------------------------------------------------
i=1000;
% nilai kecepatan angular giroskop (dalam deg/s -> sensor frame) setelah dikalibrasi
GSs=zeros(i,3);
% G1s=zeros(i,3);
 for j=1:i
    for m=1:3
        if (FBs(j,m) == 0)
            GSs(j,m) = (Gus(j,m)- Gcals(1,m))/udref;
%             G1s(j,m) = (G0s(j,m)- Gcals(1,m))/udref;
        else
            GSs(j,m) = ((Gus(j,m)- Gcals(1,m))/udref)*(2000/440);
%             G1s(j,m) = ((G0s(j,m)- Gcals(1,m))/udref)*(2000/440);
        end
    end
 end

%  Gave=mean(G1s);
%  incl=zeros(1000,3);
%  for j=1:i
%     for m=1:3
%         if (j==1)
%             incl(j,m) = (GSs(j,m)-Gave(1,m))/fs;
%         else
%             incl(j,m) = incl(j-1,m)+(GSs(j,m)-Gave(1,m))/fs;
%         end
%     end
%  end


%koordinat giroskop wiimotionplus berbeda dari wiimote
G    = [GSs(:,3), -1*GSs(:,2), GSs(:,1)];
% deg  = [incl(:,3), -1*incl(:,2), incl(:,1)];
all  = [Tu, Aus, G];
xlswrite('coba.xls',all);
% figure
% subplot(211),plot(Tu, G(:,1),Tu, G(:,2),Tu, G(:,3)),legend('Gx','Gy','Gz')
% subplot(212),plot(Tu, deg(:,1),Tu, deg(:,2),Tu, deg(:,3)),legend('degx','degy','degz')

end
