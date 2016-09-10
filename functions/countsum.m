
function [ counts ] = countsum( locs, colocalized, Pos )
%countsummary This will collect the number of spots in each cell location
%and and create a summary in a structure for cy3 and cy5. The input files
%come from the cellLocspot function. The Pos input refers to the name of
%the file evaluated eg. Pos_59

totalSpots = size(locs);
totalSpots = totalSpots(1);

colocSpots = size(colocalized);
colocSpots = colocSpots(1);

colocpercent = colocSpots/totalSpots;

counts = struct('total',totalSpots, 'colocalized',colocSpots, 'colocpercent',colocpercent, 'Pos', Pos);

end