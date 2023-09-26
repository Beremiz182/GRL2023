function [] = plotBarStackGroups2(stackData, groupLabels)
%% Plot a set of stacked bars, but group them according to labels provided.
%%
%% Params: 
%%      stackData is a 3D matrix (i.e., stackData(i, j, k) => (Group, Stack, StackElement)) 
%%      groupLabels is a CELL type (i.e., { 'a', 1 , 20, 'because' };)
%%
%% Copyright 2011 Evan Bollig (bollig at scs DOT fsu ANOTHERDOT edu
%%
%% 
NumGroupsPerAxis = size(stackData, 1);
NumStacksPerGroup = size(stackData, 2);
% Count off the number of bins
groupBins = 1:NumGroupsPerAxis;
MaxGroupWidth = 0.8; % Fraction of 1. If 1, then we have all bars in groups touching
groupOffset = MaxGroupWidth/NumStacksPerGroup;

x=[      0    0.4470    0.7410;
    0.8500    0.3250    0.0980;
    0.9290    0.6940    0.1250;
    0.4940    0.1840    0.5560;
    0.4660    0.6740    0.1880];
    x([4 5],:)=x([5 4],:);
    x(2,:)=x(2,:)*0.9;

%figure
    hold on; 
for i=1:NumStacksPerGroup
    Y = squeeze(stackData(:,i,:));
    
    % Center the bars:
    
    internalPosCount = i - ((NumStacksPerGroup+1) / 2);
    
    % Offset the group draw positions:
    groupDrawPos = (internalPosCount)* groupOffset + groupBins;
 
    h(i,:)= bar(Y, 'stacked');
    set(h(i,:),'BarWidth',groupOffset);
    set(h(i,:),'XData',groupDrawPos);
    set(gca,'colororder',x)


end
 
for i=1:NumStacksPerGroup

    k=stackData(:,i,:);
    if all(isnan(k(:)))
        continue
    end
    % Center the bars:
    
    internalPosCount = i - ((NumStacksPerGroup+1) / 2);
    
    % Offset the group draw positions:
    groupDrawPos = (internalPosCount)* groupOffset + groupBins;
 
    plot(groupDrawPos(i)+(groupOffset/2+0.001)*[-1 1],[1 1],'r',LineWidth=3)
    plot(groupDrawPos(i)+(groupOffset/2+0.001)*[-1 -1],[0 1],'k',LineWidth=2)
    plot(groupDrawPos(i)+(groupOffset/2+0.001)*[1 1],[0 1],'k',LineWidth=2)

end

hold off;
set(gca,'XTickMode','manual');
set(gca,'XTick',1:NumGroupsPerAxis);
set(gca,'XTickLabelMode','manual');
set(gca,'XTickLabel',groupLabels);

end