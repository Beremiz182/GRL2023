% python tests

clear
clc
close all
%figure


%% deciding the model

% JULES, ORCHIDEE, HTESSEL, SURFEX, PCR
models2={'JULES', 'ORCHIDEE', 'HTESSEL', 'SURFEX', 'PCR'};
nm=length(models2);

cd("../Data/")
load outputs_direct

    
R2 = nan(3,3,4,5);

for im=1:nm
    disp(models2{im})
    
    nfc=4;

    for i_out=1:4
    
        load domain
        out=OUTPUT(im).info; % output
        out=out(:,i_out);
        % finding nsoil
        load(['inputs_' models2{im} '.mat'])
        
        nsoil=max(strfind(names,'soil'));
        nsoil=str2num(names(nsoil+4));
    
    
        %% Reading Python Results
        for ij=1:3
 
            folder='.\OUTPUT_FILES_final\z_';
            
            k=importdata([folder 'result_test_' models2{im} '_' indices{i_out} '_' num2str(ij) '.csv'],',',1);
            data2=k.data;
            data2(:,1)=[];
    
        
            %% calculating R2
        
            for i=0:2        
                R2(i+1,ij,i_out,im) = 1 - sum((data2(:,1)-data2(:,end-i)).^2)/sum((data2(:,1)-mean(data2(:,1))).^2);
            end
        end

    end
end


R2=reshape(R2,[9,4,5]);
R2_std=std(R2);
R2_std=reshape(R2_std,[4,5]);
disp(R2_std);
