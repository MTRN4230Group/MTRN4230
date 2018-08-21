
function makeInfo=rtwmakecfg()
%RTWMAKECFG adds include and source directories to rtw make files.
%  makeInfo=RTWMAKECFG returns a structured array containing
%  following field:
%     makeInfo.includePath - cell array containing additional include
%                            directories. Those directories will be
%                            expanded into include instructions of rtw
%                            generated make files.
%
%     makeInfo.sourcePath  - cell array containing additional source
%                            directories. Those directories will be
%                            expanded into rules of rtw generated make
%                            files.
makeInfo.includePath = {};
makeInfo.sourcePath  = {};


%<S-Function Builder Insert tag. DO NOT REMOVE>

sfBuilderBlocksByMaskType = find_system(bdroot,'MaskType','S-Function Builder');
sfBuilderBlocksByCallback = find_system(bdroot,'OpenFcn','sfunctionwizard(gcbh)');
sfBuilderBlocks = {sfBuilderBlocksByMaskType{:} sfBuilderBlocksByCallback{:}};
sfBuilderBlocks = unique(sfBuilderBlocks);
if isempty(sfBuilderBlocks)
   return;
end
for idx = 1:length(sfBuilderBlocks)
   sfBuilderBlockNameMATFile{idx} = get_param(sfBuilderBlocks{idx},'FunctionName');
   sfBuilderBlockNameMATFile{idx} = ['.' filesep 'SFB__' char(sfBuilderBlockNameMATFile{idx}) '__SFB.mat'];
end
sfBuilderBlockNameMATFile = unique(sfBuilderBlockNameMATFile);
for idx = 1:length(sfBuilderBlockNameMATFile)
   if exist(sfBuilderBlockNameMATFile{idx})
      loadedData = load(sfBuilderBlockNameMATFile{idx});
      if isfield(loadedData,'SFBInfoStruct')
         makeInfo = UpdateMakeInfo(makeInfo,loadedData.SFBInfoStruct);
         clear loadedData;
      end
   end
end

function updatedMakeInfo = UpdateMakeInfo(makeInfo,SFBInfoStruct)
updatedMakeInfo = {};
if isfield(makeInfo,'includePath')
   if isfield(SFBInfoStruct,'includePath')
      updatedMakeInfo.includePath = {makeInfo.includePath{:} SFBInfoStruct.includePath{:}};
   else
      updatedMakeInfo.includePath = {makeInfo.includePath{:}};
   end
end
if isfield(makeInfo,'sourcePath')
   if isfield(SFBInfoStruct,'sourcePath')
      updatedMakeInfo.sourcePath = {makeInfo.sourcePath{:} SFBInfoStruct.sourcePath{:}};
   else
      updatedMakeInfo.sourcePath = {makeInfo.sourcePath{:}};
   end
end
if isfield(SFBInfoStruct,'additionalLibraries')
   % Copy over library and object files from their source folders to a
   % folder one folder above the *_target_rtw/ folder
   for idx=1:length(SFBInfoStruct.additionalLibraries)
      try
         if ~copyfile(SFBInfoStruct.additionalLibraries{idx})
            warning('Simulink:SFBuilder:rtwmakecfgCopyFailed', ...
                    sprintf('failed to copy %s to the current folder %s\n',...
                    SFBInfoStruct.additionalLibraries{idx}, pwd));
         end
      catch %Try catch is to avoid any hard errors due to copyfile
      end
   end
end
