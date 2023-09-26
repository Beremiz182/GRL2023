% python tests per model!

clear
clc
close all
%figure


%% deciding the model

% JULES, ORCHIDEE, HTESSEL, SURFEX, PCR
models={'ceh','polytechfr','ecmwf','metfr','uu'};
models2={'JULES', 'ORCHIDEE', 'HTESSEL', 'SURFEX', 'PCR'};
features={'cli','prec','soil','LC','slope'};


cd("../Data/")
load outputs_direct


% robust, feature groups, models and indices
data_tot=zeros(9,5,5,4);
for im=1:5
    disp(models2{im})

    R2 = zeros(3,4);    
    for i_out=1:4
    
        load domain
        out=OUTPUT(im).info; % output
        out=out(:,i_out);
        % finding nan in the output index, soil and lc vectors
        load(['inputs_' models2{im} '.mat'])
        nsoil=max(strfind(names,'soil'));
        nsoil=str2num(names(nsoil+4));
        %pause
    
        %% Reading Python Results
            
        folder='.\OUTPUT_FILES_final\';
        k=importdata([folder 'z_result_all_' models2{im} '_' indices{i_out} '_2.csv'],',',1);
        data2=k.data;
        
        for ij=1:3
            k2=importdata( [folder 'FI_' models2{im} '_' indices{i_out} '_' num2str(ij) '.csv'], ',', 1);
            data=k2.data;
            data(:,1)=[];
            if ij==1
                data3=[sum(data(:,1:5),2) data(:,6) sum(data(:,7:6+nsoil),2) sum(data(:,7+nsoil:end-1),2) data(:,end)];
            else
                data3=[data3; sum(data(:,1:5),2) data(:,6) sum(data(:,7:6+nsoil),2) sum(data(:,7+nsoil:end-1),2) data(:,end)];
            end
        end
        data_tot(:,:,im,i_out)=data3;
    
    
        %% calculating R2
    
        for i=0:2        
            R2(i+1,i_out) = 1 - sum((out(xx)-data2(:,end-i)).^2)/sum((out(xx)-mean(out(xx))).^2);
        end
    
    
        figure
%         subplot(1,2,1)
%         bar(median(data)')
%         [x,y]=max(data(2,:));
%         names2=split(names,',');
%         title(names2(y))
%         subplot(1,2,2)
        bar(data3')
        title([models2{im} '  ' indices{i_out}])    
        xticklabels(features)

    end

end

% std deviation analysis
data_std=std(data_tot);
data_std=reshape(data_std,[5,5,4]);
[maxval1,maxpos1]=max(data_std,[],'all'); 
% 1! - pos 12- Line 2 (Prec), column 3 (HTESSEL), Index 1 (Evap)

% percentage analysis
data_mean=mean(data_tot);
data_mean=reshape(data_mean,[5,5,4]);
data_percent=data_std./data_mean;
[maxval2,maxpos2]=max(data_percent,[],'all');
% 2! - pos 18- Line 3 (Soil), column 4 (SURFEX), Index 1 (Evap)

% values

maxval1_percent=data_percent(maxpos1);
disp([maxval1 maxval1_percent])
maxval2_abs=data_std(maxpos2);
disp([maxval2_abs maxval2])
mean_std=mean(data_std,'all');
mean_percent=mean(data_percent,'all');
disp([mean_std mean_percent])
