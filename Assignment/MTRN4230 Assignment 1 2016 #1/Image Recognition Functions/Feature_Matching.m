%Author:Vivek Desai
%Date: 03/06/2016
%Description : matching of template and workspace points 

function[indexTemplatePoints,indexWorkspacePoints] = Feature_Matching(WorkspaceFeatures,TemplateFeatures,valid_Workspace_Points,valid_Template_Points,Thresh,Ratio)
    %identify the index locations of matched points
    [indexPairs, ~] = matchFeatures(WorkspaceFeatures, TemplateFeatures,'Method' ,'Exhaustive','MatchThreshold',Thresh,'MaxRatio' ,Ratio,'Metric','SSD');
    
    indexTemplatePoints = valid_Template_Points(indexPairs(:,2));
    
    indexWorkspacePoints = valid_Workspace_Points(indexPairs(:,1));
    
end