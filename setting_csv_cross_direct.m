%% create a simple ML model, fully connected, from forcings, outputs and
% ancillary data such as topography, soil and land cover

clear
clc
close all


%% deciding the model

% JULES, ORCHIDEE, HTESSEL, SURFEX, PCR
models={'ceh','polytechfr','ecmwf','metfr','uu'};
models2={'JULES', 'ORCHIDEE', 'HTESSEL', 'SURFEX', 'PCR'};

cd('../Data/')

%% loading data
load outputs_direct.mat


%% Loop Model and Hydrological Index

% 1st Level - Models 
for im=1:length(models2)
    disp(models2{im})
    
    % 2nd Level - Indices
    for i_out=1:4
        
        % loading data
        load domain
        
        % preparing data
        out=OUTPUT(im).info; % output
        
        % defining output being predicted
        out=out(:,i_out);
        
        % 3rd Level - Models        
        for im2=1:length(models2)

            if im==im2 % don't need to cross with originals
                continue
            end

            disp([models2{im} '-' indices{i_out} '-' models2{im2}])
            % finding nan in the output index, soil and lc vectors
            load(['./Inputs_' models2{im} '.mat'])
            DATA2=DATA;
            load(['./Inputs_' models2{im2} '.mat'])
                    
            
            %% spliting validation and training data
            
            % creating the data vector, keeping precipitation and climate of the original model 
            DATA=[DATA2(:,1:6) DATA(:,7:end) out(xx)];
            names=[names indices{i_out}];
                        
            % writing
            fid=fopen(['../Cross/csv_to_RF_final/' models2{im} '_' indices{i_out} '_' models2{im2} '.csv'],'w');
            fprintf(fid,'%s\n',names);
            dlmwrite(['../Cross/csv_to_RF_final/' models2{im} '_' indices{i_out} '_' models2{im2} '.csv'], DATA, 'delimiter', ',', '-append');
            fclose all;

        end

    end
end

cd('../Cross/')