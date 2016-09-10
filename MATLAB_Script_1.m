%% Create all necessary folders to run the analysis and add them to path.
% Go into the images directory where you want to store your analysis and
% then run the section below to create all folders.

AnalysisDate = 'NAME OF THE FOLDER TO CONTAIN DATA TO BE ANALYZED';
mkdir(AnalysisDate);
cd (AnalysisDate);
mkdir('ImagesOriginal');
mkdir('rootCell');
cd('rootCell');
mkdir('ImageData');
mkdir('SegmentationMasks');
mkdir('AnalysisDi');
mkdir('cell masks');
mkdir('Cell plot images');
mkdir('SpotsData');
cd('ImageData');
mkdir('GFP');
mkdir('RFP');
cd ..\..\;

addpath(genpath('C:\Users\PATH FOR THE FOLDER CONTAINING ->\MATLAB\AroSpotFindingSuite'));
addpath(genpath('C:\Users\PATH FOR THE FOLDER CONTAINING ->\MATLAB\Software-master'));
addpath(genpath(strcat('C:\Users\PATH FOR THE FOLDER CONTAINING ->\MATLAB\', AnalysisDate)));

clear AnalysisDate;

%% Rename the files according to the script requirements
%Images have to be rename to PosX.ext, where X=number of the image and
%ext=file extension
%Move a copy of the RAW files to the ImagesOriginal folder.
raw_files = dir(fullfile(strcat(pwd,'\ImagesOriginal')));
raw_files = raw_files(3:end);
rename_files = cell(length(raw_files),2);
for i = 1:length(raw_files)
    rename_files(i,1) = cellstr(raw_files(i).name);
    rename_files(i,2) = cellstr(strcat('Pos', num2str(i)));
end;
rename_files;

%% Double check the correct name structure was printed before actually changing the names.

save('renaming_table.mat','rename_files')

for i =1:size(rename_files,1)
    movefile(rename_files{i,1},rename_files{i,2});
end;


%% Create the position identifier Mask files with the function below. 
% You must be in the rootCell directory 

rootfolder = pwd;
numimg = size(dir(strcat(rootfolder, '\cell masks')),1) - 2;

date = 'Analyses date';

parfor i = 1:numimg
    createSegmenttrans(strcat('Pos',num2str(i)));
end;
%% Apply the mask to the TIFF files
createSegImages('tif');
%% This section perform a non-supervised round of Spot detection 
doEvalFISHStacksForAll
%% To create this training set you should use the images representing the overall data to be analyzed. Repeating the command below.
% This should include all the different experimentnal samples.
createSpotTrainingSet('RFP_Pos1','')
%% To create this training set you should use the images representing the overall data to be analyzed. Repeating the command below.
% This should include all the different experimentnal samples
createSpotTrainingSet('GFP_Pos1','NDC1')
%% This section loads the training set(non-supervised spot detection) previously created.
load trainingSet_GFP_Nup157.mat
trainingSet=trainRFClassifier(trainingSet);
load trainingSet_RFP_Nup170.mat
trainingSet=trainRFClassifier(trainingSet);
%% %% This section classifies the spots previously identified by the script.
load trainingSet_GFP_Nup157.mat
classifySpotsOnDirectory(1,trainingSet,'GFP')
load trainingSet_RFP_Nup170.mat
classifySpotsOnDirectory(1,trainingSet,'RFP')
%% Run the function reviewFISHClassification('dye_PosX') in the 2012a version of MATLAB. 
% Use an image different from the one used to create the training set and repeat the process for all channels.
% I used images Pos1, 11, 21, 31, 41 and 50 to cover all experimental.
load trainingSet_RFP_Nup170.mat
trainingSet=trainRFClassifier(trainingSet); 
classifySpotsOnDirectory(1,trainingSet,'RFP')
load trainingSet_GFP_Nup157.mat
trainingSet=trainRFClassifier(trainingSet);
classifySpotsOnDirectory(1,trainingSet,'GFP')
% You'll have to do it manually and in the 2015 version of MATLAB. After
% retraining and detecting the spots repeat the reviewFISHClassification
% for new images (choose a different experimental condition). Repeat at
% least 3 or 4 times until you don't see much error in the classifications.


%% FROM HERE ON, USE THE Script_2 to acquired the percentage of colocalization.
