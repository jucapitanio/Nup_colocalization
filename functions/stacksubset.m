function [ spotsubset ] = stacksubset( spotpointcoord, start, stop )
%stacksubset subset point coordnate files only for given Z stacks.

spotsubset=spotpointcoord(spotpointcoord(:,3)>start & spotpointcoord(:,3)<stop,:);


end

