clear
clc
close all

cd("../Data/")
load outputs_direct
load("inputs_JULES_xx2.mat")
load("inputs/topo.mat")
load domain.mat

models2={'JULES', 'ORCHIDEE', 'HTESSEL', 'SURFEX', 'PCR'};


%% topography

subplot(3,2,1)
mapa=nan(1440,720);
mapa(xx2)=topo(xx2,2);

imAlpha=ones(size(mapa'));
imAlpha(isnan(mapa'))=0;
imagesc(mapa','AlphaData',imAlpha);

set(gca,'ydir','normal')
caxis([0 300])
colorbar
title (['SLOPE PROXY'])

xticklabels([])
yticklabels([])

set(gcf,'Position', [350 130 1400 850])
set(gca,'position', [0.100 0.6800 0.35 0.26])

%% PRECIPITATION

P=DATA(:,6);
subplot(3,2,2)
mapa=nan(1440,720);
mapa(xx2)=P;

imAlpha=ones(size(mapa'));
imAlpha(isnan(mapa'))=0;
imagesc(mapa','AlphaData',imAlpha);

set(gca,'ydir','normal')
caxis([0 3000])
colorbar
title (['PRECIPITATION (mm)'])

xticklabels([])
yticklabels([])
set(gca,'position', [0.5300 0.6800 0.35 0.26])

%% MODELS
i2=3;
P=DATA(:,6);
for i=[1 4]
    out=OUTPUT(i).info;
    index=-1*out(xx2,3)./P;    
    subplot(3,2,i2)
    mapa=nan(1440,720);
    mapa(xx2)=index;

    imAlpha=ones(size(mapa'));
    imAlpha(isnan(mapa'))=0;
    imagesc(mapa','AlphaData',imAlpha);

    set(gca,'ydir','normal')
    title(['Qs/P - ' models2{i}])
    caxis([0 0.6])
    if i==3
        caxis([0 0.4])
    end
    colorbar
    if i==1
        set(gca,'position', [0.100 0.3800 0.35 0.26])
    else
        set(gca,'position', [0.100 0.0800 0.35 0.26])
    end
    
    xticklabels([])
    yticklabels([])
    i2=i2+1;

    out=OUTPUT(i).info;
    index=-1*out(xx2,4)./P;    
    subplot(3,2,i2)
    mapa=nan(1440,720);
    mapa(xx2)=index;

    imAlpha=ones(size(mapa'));
    imAlpha(isnan(mapa'))=0;
    imagesc(mapa','AlphaData',imAlpha);

    set(gca,'ydir','normal')
    title(['Qsb/P - ' models2{i}])
    caxis([0 0.6])
%     if i==3
%         caxis([0 0.4])
%     end
    colorbar

    xticklabels([])
    yticklabels([])
    i2=i2+1;
    if i==1
        set(gca,'position', [0.5300 0.3800 0.35 0.26])
    else
        set(gca,'position', [0.5300 0.0800 0.35 0.26])
    end

end
%set(gca,'position', [0.1300 0.0200 0.6992 0.28])