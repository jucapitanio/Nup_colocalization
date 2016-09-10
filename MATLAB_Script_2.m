%% Add all necessary folder paths to functions and data:
AnalysisDate = 'NAME OF THE FOLDER TO BE ANALYZED';
addpath(genpath('C:\Users\->Path for the folder containing data to be analysed'));
addpath(genpath('C:\Users\-> Path for the folder containing script'));
addpath(genpath(strcat('C:\Users\Path for the folder containing\MATLAB\', AnalysisDate)));


%% This section find and analyze the colocalization of the identified spots. 
rootfolder = pwd;
numimg = size(dir(strcat(rootfolder, '\cell masks')),1) - 2;

RFP_spotStats_files = dir(fullfile(strcat(rootfolder,'\Analysis\SpotStats\RFP'), 'RFP_Pos*_spotStats.mat'));
GFP_spotStats_files = dir(fullfile(strcat(rootfolder,'\Analysis\SpotStats\GFP'), 'GFP_Pos*_spotStats.mat'));
cellsegmask = dir(fullfile(strcat(rootfolder,'\SegmentationMasks'), 'segmenttrans_Pos*.mat'));

RFPcountstt = struct('total',{},'colocalized',{},'colocpercent',{}, 'Pos', {});
GFPcountstt = struct('total',{},'colocalized',{},'colocpercent',{}, 'Pos', {});
RFPcountsmidtt = struct('total',{},'colocalized',{},'colocpercent',{}, 'Pos', {});
GFPcountsmidtt = struct('total',{},'colocalized',{},'colocpercent',{}, 'Pos', {});


for i = 2:numimg
      
    RFP_spotStats_file = RFP_spotStats_files(i).name;
    GFP_spotStats_file = GFP_spotStats_files(i).name;
    [ locsR ] = goodspots( RFP_spotStats_file );
    [ locsG ] = goodspots( GFP_spotStats_file );
    locsGmid=locsG(locsG(:,3)> max(locsG(:,3))/2 - 2 & locsG(:,3)<max(locsG(:,3))/2 + 2,:);
    
    load(RFP_spotStats_file)
    locs=spotStats{1}.locAndClass(:,1:3);
    locsR = [];
    locsR(:,1) = locs(:,2); 
    locsR(:,2) = locs(:,1);
    locsR(:,3) = (locs(:,3) * 3.19) - 3.19;
    locsRmid=locsR(locsR(:,3)> max(locsR(:,3))/2 - 2 & locsR(:,3)<max(locsR(:,3))/2 + 2,:);

    % this parameter allows to change the distance required for 2 focis be counted as overlapping  
    [ colocalizedRFP, colocalizedGFP ] = colocalized( locsR, locsG, 5 );
    [ colocmidRFP, colocmidGFP ] = colocalized( locsRmid, locsGmid, 5 );
    
    if not(isempty(colocalizedRFP)) && not(isempty(colocalizedGFP))

       
        [ RFPcounts ] = countsum( locsR, colocalizedRFP, RFP_spotStats_file(5:10) );
        [ GFPcounts ] = countsum( locsG, colocalizedGFP, GFP_spotStats_file(5:10) );
        
        RFPcountstt = [RFPcountstt, RFPcounts];
        GFPcountstt = [GFPcountstt, GFPcounts];
        clear GFPcounts RFPcounts;
    end;
    
    if not(isempty(colocmidRFP)) && not(isempty(colocmidGFP))

       
        [ RFPcountsmid ] = countsum( locsRmid, colocmidRFP, RFP_spotStats_file(5:10) );
        [ GFPcountsmid ] = countsum( locsGmid, colocmidGFP, GFP_spotStats_file(5:10) );
        
        RFPcountsmidtt = [RFPcountsmidtt, RFPcountsmid];
        GFPcountsmidtt = [GFPcountsmidtt, GFPcountsmid];
        clear GFPcountsmid RFPcountsmid;
    end;
        
    
end;

% If you re-run this again it will alway rewrite the csv files. Change the
% name if needed.
%struct2csv(RFPcountstt, 'RFPcountstt.csv'); 
%struct2csv(GFPcountstt, 'GFPcountstt.csv');
%struct2csv(RFPcountsmidtt, 'RFPcountsmidtt.csv'); 
%struct2csv(GFPcountsmidtt, 'GFPcountsmidtt.csv');
% Ainda falta criar e salvar todas as figuras, apagar variaveis inuteis e
% salvar tudo num arquivo .mat
%clear cellsegmask rootfolder numimg;
%save('AnalysisSummary.mat');

%% This section makes a 3D figures containing green, red and colocalized focis
scatter3(locsG(:,1), locsG(:,2), locsG(:,3),50,'MarkerEdgeColor','green','Marker','.');
hold on;
scatter3(locsR(:,1), locsR(:,2), locsR(:,3),50,'MarkerEdgeColor','red','Marker','.');
hold on;
scatter3(colocalizedGFP(:,1), colocalizedGFP(:,2), colocalizedGFP(:,3),50,'MarkerEdgeColor','blue','Marker','.');
hold on;
scatter3(colocalizedRFP(:,1), colocalizedRFP(:,2), colocalizedRFP(:,3),50,'MarkerEdgeColor','yellow','Marker','.');

%% If you want you can also export the files to csv.

struct2csv(RFPcountstt, 'RFPcountstt.csv')
struct2csv(RFPcountsmidtt, 'RFPmidcountstt.csv')
struct2csv(GFPcountsmidtt, 'GFPmidcountstt.csv')
struct2csv(GFPcountstt, 'GFPcountstt.csv')
