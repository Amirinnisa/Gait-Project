function scatall(ic,tc,data)
sdt=size(data);
T=data(:,1);
figure
for dt=2:sdt(2)
    data1=data(:,dt);
    
    iA1=1;
    for iA=1:length(ic)
        pi= T==ic(iA,1);
        data1_i(iA1)=data1(pi);
        iA1=iA1+1;
    end
    iA2=1;
    for iiA=1:length(tc)
        pii= T==tc(iiA,1);
        data1_ii(iA2)=data1(pii);
        iA2=iA2+1;
    end

    subplot(sdt(2)-1,1,(dt-1)),plot(T,data1),
    hold on,
    scatter(ic(:,1),data1_i,'d','filled'), %valleys ic points
    scatter(tc(:,1),data1_ii,'o','filled'), %valleys tc points
    hold off,
end

end
