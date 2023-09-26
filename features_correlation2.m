%% create a simple ML model, fully connected, from forcings, outputs and
% ancillary data such as topography, soil and land cover

clear
clc
close all


%% deciding the model

% JULES, ORCHIDEE, HTESSEL, SURFEX, PCR
models={'ceh','polytechfr','ecmwf','metfr','uu'};
models2={'JULES', 'ORCHIDEE', 'HTESSEL', 'SURFEX', 'PCR'};


%% loading data
cd("../Data")
load forcings
load outputs
load('./Inputs/topo.mat')
topo(:,1)=[]; % removing topography


%% Loop Model and Hydrological Index

for im=1:length(models2)
    disp(models2{im})

    % loading data
    load(['./Inputs/lc_' models2{im} '.mat'])
    load(['./Inputs/soil_' models2{im} '.mat'])


    if im==1
        lc(:,9)=[];
    end

    % loading data
    load domain
    xx=xx2;

    % preparing data
    fcg=FORCING(im).info; % input
    fcg(:,13:16)=fcg(:,13:16)*3600*24*365; % mm/d
    fcg(:,13)=fcg(:,13)+fcg(:,15); % adding rainfall and snowfall
    fcg(:,[1:2 14:16])=[]; % removing LongWave Radiation and snowfall
    fcg(:,[2:2:10])=[]; % removing std deviations
% 
% figure
%     map=NaN(1440,720);
%     map(xx)=fcg(xx,13);
%     imagesc(map')
%     set(gca,'ydir','normal')
%     colorbar
%     caxis([0 3000])
    
    
    % number of features
    [~,nfc]=size(fcg);
    [~,nsoil]=size(soil);
    [~,nlc]=size(lc);
    nprec=1;
    nfc=nfc-nprec;
    [~,ntopo]=size(topo);
    
    % checking the size of the input
    [lixo,nin]=size([fcg soil lc topo]); % lixo is nx*ny
    disp(nin)


    disp(length(xx)/lixo)
    
    
    %% spliting validation and training data
    
    % creating the data vector 
    DATA=[fcg(xx,:) soil(xx,:) lc(xx,:) topo(xx,:)];
    
    % creating columns names
    nfc2=nfc; nprec2=nfc2+nprec; nsoil2=nsoil+nprec2; nlc2=nlc+nsoil2; ntopo2=ntopo+nlc2;
    list_num=[nfc2 nprec2 nsoil2 nlc2 ntopo2];
    list_names={'fcg','prec','soil','lc','topo'};
    names=giving_names(list_num,list_names);

    
    % CORRELATION
    feat_corr=corr(DATA,'type','Spearman');


    % FIGURES
    figure

    %subplot(1,2,1)
    title(models2{im})
    imagesc(abs(feat_corr))
    
    load mymap2
    caxis([0 1])
    colormap(gca,mymap)
    colorbar

    hold on

    color={'r','b','y','g','m'};

    A=zeros(nin);
    v_ticks=sort([1,list_num, list_num(1:end-1)+1]);

    for i=1:length(v_ticks)/2
        A = plot_square(v_ticks(2*(i-1)+1), v_ticks(2*i), color{i}, A, i);
    end
    
    xticks(unique(v_ticks))
    yticks(unique(v_ticks))
%     xticklabels(names(v_ticks))
    xticklabels([])
    yticklabels(names(unique(v_ticks)))

    %% removing correlated features from different groups
    
    [i,j]=find(A==0 & abs(feat_corr)>+0.75);
    k=[i j];
    x=unique(sort(k,2),'rows');
    x=x(:,2);
    
    % removing variables
    A(x,:)=[];
    A(:,x)=[];
    feat_corr(x,:)=[];
    feat_corr(:,x)=[];
    DATA(:,x)=[];

    % correcting order
    x=diag(A);
    [~,x]=unique(x);
    x=x-1;
    list_num=[x(2:end)' x(end)+1];
    names=giving_names2(list_num,list_names);


    %% removing strongly correlated features from the same groups
    [i,j]=find(abs(feat_corr)>+0.9);
    x=i-j;
    x=find(x==0);
    i(x)=[]; j(x)=[];
    k=[i j];
    x=[];
    % removing the variables that are correlated to more variables
    while (length(k)>0)
       y=mode(k,'all');
       % removing y from 1st column
       k(k(:,1)==y,:)=[];
       % removing y from 2nd column
       k(k(:,2)==y,:)=[];
       x=[x y];
    end
    
    % removing variables
    A(x,:)=[];
    A(:,x)=[];
    feat_corr(x,:)=[];
    feat_corr(:,x)=[];
    DATA(:,x)=[];

    % correcting order
    x=diag(A);
    [~,x]=unique(x);
    x=x-1;
    list_num=[x(2:end)' x(end)+1];
    names=giving_names2(list_num,list_names);



    % FIGURE CORRECTED

    figure
    %subplot(1,2,2)
    imagesc(abs(feat_corr))
    
    load mymap2
    caxis([0 1])
    colormap(gca,mymap)
    colorbar
    


    hold on

    color={'r','b','y','g','m'};


    v_ticks=sort([1,list_num, list_num(1:end-1)+1]);

    for i=1:length(v_ticks)/2
        plot_square(v_ticks(2*(i-1)+1), v_ticks(2*i), color{i}, [],[]);
    end
 
    xticks(unique(v_ticks))
    yticks(unique(v_ticks))
%     xticklabels(names(v_ticks))
    xticklabels([])
    yticklabels(names(unique(v_ticks)))

    %set(gcf,'position',[48 110 1850 793])
    set(gcf,'Position', [680 395 653 583])

    %saveas(gcf,['./figures_correlation/' models2{im} '_3.png'])

    %save(['inputs_' models2{im} '_xx2.mat'],"names","DATA")

end


function matrix = plot_square(lower,up,color,matrix,index)

    plot([lower-0.5 up+0.5],[up+0.5 up+0.5],color,'LineWidth',2)
    plot([lower-0.5 up+0.5],[lower-0.5 lower-0.5],color,'LineWidth',2)
    plot([up+0.5 up+0.5],[lower-0.5 up+0.5],color,'LineWidth',2)
    plot([lower-0.5 lower-0.5],[lower-0.5 up+0.5],color,'LineWidth',2)

    if length(matrix)>1
        matrix(lower:up,lower:up)=index;
    end

end

function names= giving_names(list_num,list_names)

    names=[];
    j=1;
    i2=1;
    for i=1:list_num(end)
        if i<=list_num(j)   
            names=[names list_names{j} num2str(i2) ','];
        else
            j=j+1;
            i2=1;
            names=[names list_names{j} num2str(i2) ','];
        end
        i2=i2+1;
    end

end

function names= giving_names2(list_num,list_names)

    names=[];
    j=1;
    i2=1;
    for i=1:list_num(end)
        if i<=list_num(j)   
            names{i}=[list_names{j} num2str(i2)];
        else
            j=j+1;
            i2=1;
            names{i}=[list_names{j} num2str(i2)];
        end
        i2=i2+1;
    end
    
end