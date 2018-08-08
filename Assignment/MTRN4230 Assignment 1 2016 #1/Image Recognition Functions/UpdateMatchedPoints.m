%Author:Vivek Desai
%Date: 03/06/2016
%Description : removal of matched surfpoints when a chocolate is
%succesfully identified.

function[matchedWorkspacePoints,matchedTemplatePoints] = UpdateMatchedPoints(matchedWorkspacePoints,matchedTemplatePoints,rectangle)

usedpoints = inpolygon(matchedWorkspacePoints.Location(:,1),matchedWorkspacePoints.Location(:,2),rectangle(:,1),rectangle(:,2));
    clear = find(usedpoints==1);
    
    for i = length(clear):-1:1
        matchedWorkspacePoints(clear(i)) = [];
        matchedTemplatePoints(clear(i)) = [];
    end;   
end