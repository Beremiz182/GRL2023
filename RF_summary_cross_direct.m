% python tests

clear
clc
close all
%figure


%% deciding the model

% JULES, ORCHIDEE, HTESSEL, SURFEX, PCR
models2={'JULES', 'ORCHIDEE', 'HTESSEL', 'SURFEX', 'PCR'};
nm=length(models2);
cd("../Data")
load outputs_direct


R2 = nan(5,5,4);
FI = nan(5,5,5,4);
ij = 1;

% 1st level
for im=1:nm
    disp(models2{im})

    % 2nd level
    for i_out=1:4
        disp(['  ' indices{i_out}])
        
        % 3rd level
        for im2=1:nm
            disp(['    ' models2{im2}])

            if im2==im
                folder='.\OUTPUT_FILES_final\';                
                p = num2str(ij);
                p2 = 'z_';
            else
                folder='.\OUTPUT_FILES_cross\';
                p = models2{im2};
                p2=[];
            end

            k=importdata([folder p2 'result_test_' models2{im} '_' indices{i_out} '_' p '.csv'],',',1);
            data2=k.data;
            data2(:,1)=[];
    
            k2=importdata([folder 'FI_' models2{im} '_' indices{i_out} '_' p '.csv'],',',1);
            data=k2.data;
            data(:,1)=[];


            %% getting the number of soil input features
            load(['inputs_' models2{im2} '.mat'])
            nsoil=max(strfind(names,'soil'));
            nsoil=str2num(names(nsoil+4));
        
            
            %% feature importance
            
            data3=[data(:,6) sum(data(:,1:5),2) sum(data(:,7:6+nsoil),2) sum(data(:,7+nsoil:end-1),2) data(:,end)];
            FI(im,im2,:,i_out) = median(data3,1)./sum(median(data3,1));
        
            %% calculating R2
        
            R2(im2,im,i_out) = 1 - sum((data2(:,1)-data2(:,end)).^2)/sum((data2(:,1)-mean(data2(:,1))).^2);

        end

    end
end

cd("../Codes")


%% Plotting

sym_col={'^b','or','sg','xm','*k'}; % symbol and color
xvec=1:5;

% loop to build the figure
for i_out=1:4
    
    figure
    hold on
    
    for im2=1:nm
        %for im2=1:nm
            r2=R2(im2,:,i_out);
            plot(xvec(:),r2(:),sym_col{im2},'markersize',10,'LineWidth',2)
        %end
    end
    
    legend(models2,'location','southeast')
    xlim([0.5 5.5])
    xticks(1:5)
    xticklabels(models2)
    ylabel('R2')
    
    if i_out==3
        ylim([0.7 1])
        yticks([0.7 0.8:0.05:1])
        yticklabels({'0','0.8','0.85','0.9','0.95','1'})
    elseif i_out<3
        ylim([0.9 1])
        yticks([0.9 0.94:0.02:1])
        yticklabels({'0','0.94','0.96','0.98','1'})
    else
        ylim([0.85 1])
        yticks([0.85 0.9:0.02:1])
        yticklabels({'0','0.9','0.92','0.94','0.96','0.98','1'})
    end

    grid on
    set(gcf,'Position', [300 350 350 420])
    title(['TESTING - ' indices{i_out}])
    set(gca,'color',[0.92 0.92 0.92])
    

    %% BREAK POINT
    axes('Position',[.1 0.22 .05 .05]);
    px=[1 5];
    py1=[1 2];
    height=1;
    py2=py1+height;
    plot(px,py1,'k','LineWidth',2);hold all;
    plot(px,py2,'k','LineWidth',2);hold all;
    fill([px flip(px)],[py1 flip(py2)],'w','EdgeColor','none');
    box off;
    axis off;
    
    %saveas(gca,['./figures/RF_fitness_' indices{i_out} '.png'])
end
% 


%% Plotting 2

figure
for i_out=1:4
    subplot(3,4,i_out)
    plotBarStackGroups2(FI(:,:,:,i_out),models2)
    ylim([0 1])
    set(gca,'YGrid','on');
    %title([indices{i_out}])
    %set(gca,'fontsize',7)
    %saveas(gcf,['./figures/FI_direct.png'])
end
%set(gcf, 'Position', [100 75 1750 280])


% FI(im,im2,:,i_out)

%figure
for i_out=1:4
    subplot(3,4,i_out+4)
    for im=1:5
        FI2(im,:,i_out)=FI(im,im,:,i_out);
    end
    bar(FI2(:,:,i_out),'stacked')
    %     set(gcf,'Position',[300 100 900 700])
    ylim([0 1])
    set(gca,'YGrid','on');
    x=get(gca,'colororder');
    x([4 5],:)=x([5 4],:);
    x(2,:)=x(2,:)*0.9;
    set(gca,'colororder',x)
    %set(gca,'fontsize',7)
    xticklabels(models2)
    %title([indices{i_out}])% '-  Same Output, mean Features'])
end


for i_out=1:4
    subplot(3,4,i_out+8)
    bar(squeeze(mean(FI(:,:,:,i_out),2)),'stacked')
    %     set(gcf,'Position',[300 100 900 700])
    ylim([0 1])
    x=get(gca,'colororder');
    x([4 5],:)=x([5 4],:);
    x(2,:)=x(2,:)*0.9;
    set(gca,'YGrid','on');
    set(gca,'colororder',x)
    %set(gca,'fontsize',7)
    xticklabels(models2)
    %title([indices{i_out}])% '-  Same Output, mean Features'])
end


set(gcf, 'Position', [50 50 1400 900])
% saveas(gcf,['./figures/FI_direct.png'])