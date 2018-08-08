% Author: Niels Alston, Xiangfen Yang
% Last Modified: 31/5/2016
% Purpose: This contains the functions for operating the GUI, it mainly
% contains calls to functions.

function varargout = ABB_GUI_Automated(varargin)
%{
    
    HOW TO CREATE A NEW TAB

    1. Create or copy PANEL and TEXT objects in GUI

    2. Rename tag of PANEL to "tabNPanel" and TEXT for "tabNtext", where N
    - is a sequential number. 
    Example: tab3Panel, tab3text, tab4Panel, tab4text etc.
    
    3. Add to Tab Code - Settings in m-file of GUI a name of the tab to
    TabNames variable

    Version: 1.0
    First created: January 18, 2016
    Last modified: January 18, 2016

    Author: WFAToolbox (http://wfatoolbox.com)
    Credit to: http://www.mathworks.com/matlabcentral/fileexchange/54992-simple-optimized-gui-tabs
%}

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ABB_GUI_Automated_OpeningFcn, ...
                   'gui_OutputFcn',  @ABB_GUI_Automated_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ABB_GUI_Automated is made visible.
function ABB_GUI_Automated_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ABB_GUI_Automated (see VARARGIN)

% Choose default command line output for ABB_GUI_Automated
handles.output = hObject;
% %% Timer object setup (Not using at the moment)
% handles.timer = timer(...
%         'ExecutionMode', 'fixedRate', ...
%         'Period', 1, ...
%         'TimerFcn', {@update_gui,hObject});
%% Image setups
tablevid = videoinput('winvideo',1,'RGB24_1600x1200');
conveyorvid = videoinput('winvideo',2,'RGB24_1600x1200');
handles.tablevid = tablevid;
handles.conveyorvid = conveyorvid;
%% Tabs Code do not edit
% Settings
TabFontSize = 10;
TabNames = {'Sorting','Order Management','Debug Tab'};
FigWidth = 0.68; %0.265;

% Figure resize
set(handles.SimpleOptimizedTab,'Units','normalized')
pos = get(handles. SimpleOptimizedTab, 'Position');
set(handles. SimpleOptimizedTab, 'Position', [pos(1) pos(2) FigWidth pos(4)])

% Tabs Execution
handles = TabsFun(handles,TabFontSize,TabNames);


handles.chocType={'N/A','Milk','Orange','Mint','Dark'};
handles.chocColor=[[1 1 1];[0.3 0.75 0.93];[0.93 0.69 0.13];[0.1 1 0.1];[.5 0.5 0.5]];
handles.stackStates=ones(6,4);
handles.order=zeros(4,1); % number of choc in stack,in the order milk, orange, mint, dark
handles.availableChoc=zeros(4,1);
% Update handles structure
guidata(hObject, handles);
reset_order_Callback(handles.reset_order,eventdata,handles);

% UIWAIT makes ABB_GUI_Automated wait for user response (see UIRESUME)
% uiwait(handles.SimpleOptimizedTab);

% --- TabsFun creates axes and text objects for tabs
function handles = TabsFun(handles,TabFontSize,TabNames)

% Set the colors indicating a selected/unselected tab
handles.selectedTabColor=get(handles.tab1Panel,'BackgroundColor');
handles.unselectedTabColor=handles.selectedTabColor-0.1;

% Create Tabs
TabsNumber = length(TabNames);
handles.TabsNumber = TabsNumber;
TabColor = handles.selectedTabColor;
for i = 1:TabsNumber
    n = num2str(i);
    
    % Get text objects position
    set(handles.(['tab',n,'text']),'Units','normalized')
    pos=get(handles.(['tab',n,'text']),'Position');

    % Create axes with callback function
    handles.(['a',n]) = axes('Units','normalized',...
                    'Box','on',...
                    'XTick',[],...
                    'YTick',[],...
                    'Color',TabColor,...
                    'Position',[pos(1) pos(2) pos(3) pos(4)+0.01],...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);
                    
    % Create text with callback function
    handles.(['t',n]) = text('String',TabNames{i},...
                    'Units','normalized',...
                    'Position',[pos(3),pos(2)/2+pos(4)],...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','middle',...
                    'Margin',0.001,...
                    'FontSize',TabFontSize,...
                    'Backgroundcolor',TabColor,...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);

    TabColor = handles.unselectedTabColor;
end
            
% Manage panels (place them in the correct position and manage visibilities)
set(handles.tab1Panel,'Units','normalized')
pan1pos=get(handles.tab1Panel,'Position');
set(handles.tab1text,'Visible','off')
for i = 2:TabsNumber
    n = num2str(i);
    set(handles.(['tab',n,'Panel']),'Units','normalized')
    set(handles.(['tab',n,'Panel']),'Position',pan1pos)
    set(handles.(['tab',n,'Panel']),'Visible','off')
    set(handles.(['tab',n,'text']),'Visible','off')
end

% --- Callback function for clicking on tab
function ClickOnTab(hObject,~,handles)
m = str2double(get(hObject,'Tag'));

for i = 1:handles.TabsNumber;
    n = num2str(i);
    if i == m
        set(handles.(['a',n]),'Color',handles.selectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.selectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','on')
    else
        set(handles.(['a',n]),'Color',handles.unselectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.unselectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','off')
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = ABB_GUI_Automated_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when tab1Panel is resized.
function tab1Panel_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to tab1Panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pause_stop3.
function pause_stop3_Callback(hObject, eventdata, handles)
% hObject    handle to pause_stop3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f=get(hObject,'Value');
if f==0
    set(hObject,'Backgroundcolor','green')
else
    set(hObject,'Backgroundcolor','red')
end

% Do communication
% Hint: get(hObject,'Value') returns toggle state of pause_stop3

% --- Executes on button press in vacuum_power.
function vacuum_power_Callback(hObject, eventdata, handles)

if get(hObject, 'Value')
    set(hObject, 'Backgroundcolor', 'g');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Vacuum power on';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(35,1,1,handles.socket); %Vacuum is running
else
    set(hObject, 'Backgroundcolor', 'r');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Vacuum power off';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(35,0,1,handles.socket);%Vacuum is not running
end

% --- Executes on button press in vacuum_solenoid.
function vacuum_solenoid_Callback(hObject, eventdata, handles)
if get(hObject, 'Value')
    set(hObject, 'Backgroundcolor', 'g');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Solenoid power on';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(36,1,1,handles.socket); %Vacuum solenoid is on
else
    set(hObject, 'Backgroundcolor', 'r');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Solenoid power off';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(36,0,1,handles.socket); %Vacuum solenoid is off
end


% --- Executes on button press in conveyor_power.
function conveyor_power_Callback(hObject, eventdata, handles)
if get(hObject, 'Value')
    set(hObject, 'Backgroundcolor', 'g');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Conveyor power on';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(34,1,1,handles.socket);%Conveyer is running
else
    set(hObject, 'Backgroundcolor', 'r');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Conveyor power off';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(34,0,1,handles.socket); %Conveyer is not running
end

% Hint: get(hObject,'Value') returns toggle state of conveyor_power


% --- Executes on button press in conveyor_direction.
function conveyor_direction_Callback(hObject, eventdata, handles)
get(hObject, 'Value')
if get(hObject, 'Value')
    set(hObject, 'Backgroundcolor', 'g');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Conveyor direction forwards';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(33,0,1,handles.socket); %Conveyer direction is away
else
    set(hObject, 'Backgroundcolor', 'r');
%     previous_messages = get(handles.message_log, 'String');
%     previous_messages{end+1} = 'Conveyor direction backwards';
%     set(handles.message_log, 'String', previous_messages);
%     set(handles.message_log, 'Value', size(previous_messages,1));
    communicateToRobot(33,1,1,handles.socket); %Conveyer direction is toward
end

% Hint: get(hObject,'Value') returns toggle state of conveyor_direction


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
slider_val = get(hObject, 'Value');
set(handles.q1_display, 'String', slider_val);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%communicateToRobot(08,slider_val,0,handles.socket); %Get joint6 value
communicateToRobot(08,slider_val,1,handles.socket); %Set joint6 value




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
minval = -165;
maxval = 165;
range = maxval-minval;

set(hObject, 'min', minval);
set(hObject, 'max', maxval);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/range, 10/range]);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
slider_val = get(hObject, 'Value');
set(handles.q2_display, 'String', slider_val);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%communicateToRobot(09,slider_val,0,handles.socket); %Get joint2 value
communicateToRobot(09,slider_val,1,handles.socket); %Set joint2 value


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
minval = -110;
maxval = 110;
range = maxval-minval;

set(hObject, 'min', minval);
set(hObject, 'max', maxval);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/range, 10/range]);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
slider_val = get(hObject, 'Value');
set(handles.q3_display, 'String', slider_val);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%communicateToRobot(10,slider_val,0,handles.socket); %Get joint3 value
communicateToRobot(10,slider_val,1,handles.socket); %Set joint3 value

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
minval = -110;
maxval = 70;
range = maxval-minval;

set(hObject, 'min', minval);
set(hObject, 'max', maxval);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/range, 10/range]);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
slider_val = get(hObject, 'Value');
set(handles.q4_display, 'String', slider_val);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%communicateToRobot(11,slider_val,0,handles.socket); %Get joint4 value
communicateToRobot(11,slider_val,1,handles.socket); %Set joint4 value

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
minval = -160;
maxval = 160;
range = maxval-minval;

set(hObject, 'min', minval);
set(hObject, 'max', maxval);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/range, 10/range]);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
slider_val = get(hObject, 'Value');
set(handles.q5_display, 'String', slider_val);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%communicateToRobot(12,slider_val,0,handles.socket); %Get joint5 value
communicateToRobot(12,slider_val,1,handles.socket); %Set joint5 value

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
minval = -120;
maxval = 120;
range = maxval-minval;

set(hObject, 'min', minval);
set(hObject, 'max', maxval);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/range, 10/range]);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)

slider_val = get(hObject, 'Value');
set(handles.q6_display, 'String', slider_val);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%communicateToRobot(13,slider_val,0,handles.socket); %Get joint6 value
%communicateToRobot(13,slider_val,1,handles.socket); %Set joint6 value


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
minval = -400;
maxval = 400;
range = maxval-minval;

set(hObject, 'min', minval);
set(hObject, 'max', maxval);
set(hObject, 'Value', 0);
set(hObject, 'SliderStep', [1/range, 10/range]);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in reset_all_joints.
function reset_all_joints_Callback(hObject, eventdata, handles)


set(handles.slider1, 'Value', 0);
set(handles.slider2, 'Value', 0);
set(handles.slider3, 'Value', 0);
set(handles.slider4, 'Value', 0);
set(handles.slider5, 'Value', 0);
set(handles.slider6, 'Value', 0);
set(handles.q1_display, 'String', 0);
set(handles.q2_display, 'String', 0);
set(handles.q3_display, 'String', 0);
set(handles.q4_display, 'String', 0);
set(handles.q5_display, 'String', 0);
set(handles.q6_display, 'String', 0);



% --- Executes on button press in load_order.
function load_order_Callback(hObject, eventdata, handles)
scan = getsnapshot(handles.conveyorvid);
BoxData = DetectBox(scan, 2);
snap = getsnapshot(handles.tablevid); % get snap from feed
ChocolateData = z3373202_MTRN4230_ASST2(snap, 1);
[blockingChocs,nonBlockingChocs] = StackingPosClear(ChocolateData);
setValue = [nonBlockingChocs.xpos(1) nonBlockingChocs.ypos(1) ...
                    148 nonBlockingChocs.theta(1) ...
                    BoxData.xpos BoxData.ypos 28 ...
                    28 BoxData.theta];
chocolateCommands(15, setValue, handles.socket);
% check the stack if valid
k=0;
for i=1:4
    f=0;
    for j=1:6
        s=handles.stackStates(j,i);
            if s~=1 
               
               handles.order(s)=handles.order(s)+1;
            else
                f=1;
            end
            if f==1 && s~=1
               k=1; 
            end
    end
end
if k==1
    msgbox({'Invalid order, some intermediate gaps in stack ', 'Place order from bottom' })
else
    snap = getsnapshot(handles.tablevid); % get snap from feed
    ChocolateData = z3373202_MTRN4230_ASST2(snap, 1); % process snap
    MilkStack = InitialiseChocStack(200 , 100 , 90 , 0);
    DarkStack = InitialiseChocStack(200 , 200 , 90 , 0);
    OrangeStack = InitialiseChocStack(200 , 300 , 90 , 0);
    MintStack = InitialiseChocStack(200 , 400 , 90 , 0);
    if (size(ChocolateData, 2) >= 1)
        %Check stacking positions clear if not figure out how to clear
        [blockingChocs,nonBlockingChocs] = StackingPosClear(ChocolateData); % needs to be implemented
        if ((size(blockingChocs.type, 1) >=1) && (size(blockingChocs.type, 2) >= 1))
            tempStack = defineTempStack(nonBlockingChocs);
            for i=1:size(blockingChocs.type, 1) % clears stacking area and adds chocolates to temp stack
                setValue = [blockingChocs.xpos(i) blockingChocs.ypos(i) ...
                    148 blockingChocs.theta(i) ...
                    tempStack.StackXpos tempStack.StackYpos tempStack.height*4+148 ...
                    tempStack.StackTheta];
                chocolateCommands(12, setValue, handles.socket);
                tempStack = AddToChocStack(tempStack, blockingChocs.type(i));
            end
            % defines the predefined stacks
            while (tempStack.height > 0)
                switch(tempStack.TypeAtTop)
                    case 1 %milk
                        setValue = [tempStack.StackXpos tempStack.StackYpos ...
                            tempStack.height*4+148 tempStack.StackTheta ...
                            MilkStack.StackXpos MilkStack.StackYpos ...
                            MilkStack.height*4+148 MilkStack.StackTheta];
                        chocolateCommands(12, setValue, handles.socket);
                        MilkStack = AddToChocStack(MilkStack, 1);
                        [tempStack ~] = RemoveFromChocStack(tempStack);
                    case 2 %dark
                        setValue = [tempStack.StackXpos tempStack.StackYpos ...
                            tempStack.height*4+148 tempStack.StackTheta ...
                            DarkStack.StackXpos DarkStack.StackYpos ...
                            DarkStack.height*4+148 DarkStack.StackTheta];
                        chocolateCommands(12, setValue, handles.socket);
                        DarkStack = AddToChocStack(DarkStack, 2);
                        [tempStack ~] = RemoveFromChocStack(tempStack);
                    case 3 %orange
                        setValue = [tempStack.StackXpos tempStack.StackYpos ...
                            tempStack.height*4+148 tempStack.StackTheta ...
                            OrangeStack.StackXpos OrangeStack.StackYpos ...
                            OrangeStack.height*4+148 OrangeStack.StackTheta];
                        chocolateCommands(12, setValue, handles.socket);
                        OrangeStack = AddToChocStack(OrangeStack, 3);
                        [tempStack ~] = RemoveFromChocStack(tempStack);
                    case 4 %mint
                        setValue = [tempStack.StackXpos tempStack.StackYpos ...
                            tempStack.height*4+148 tempStack.StackTheta ...
                            MintStack.StackXpos MintStack.StackYpos ...
                            MintStack.height*4+148 MintStack.StackTheta];
                        chocolateCommands(12, setValue, handles.socket);
                        MintStack = AddToChocStack(MintStack, 4);
                        [tempStack ~] = RemoveFromChocStack(tempStack);
                    case 5 %upside down
                        %flips chocolate and returns it to the temp stack
                        flipChocolate(handles, tempStack.StackXpos, tempStack.StackYpos, ...
                            tempStack.height*4+148, tempStack.StackTheta);
                    otherwise
                        fprintf('Invalid chocolate type in stack\n');
                end

            end
        end
        for i=1:size(nonBlockingChocs.type, 1)
            switch nonBlockingChocs.type(i)
                case 1
                    setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
                148 nonBlockingChocs.theta(i) ...
                MilkStack.StackXpos MilkStack.StackYpos MilkStack.height*4+148 ...
                MilkStack.StackTheta];
                MilkStack = AddToChocStack(MilkStack, 1);
                case 2
                    setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
                148 nonBlockingChocs.theta(i) ...
                DarkStack.StackXpos DarkStack.StackYpos DarkStack.height*4+148 ...
                DarkStack.StackTheta];
                DarkStack = AddToChocStack(DarkStack, 2);
                case 3
                    setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
                148 nonBlockingChocs.theta(i) ...
                OrangeStack.StackXpos OrangeStack.StackYpos OrangeStack.height*4+148 ...
                OrangeStack.StackTheta];
                OrangeStack = AddToChocStack(OrangeStack, 3);
                case 4
                    setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
                148 nonBlockingChocs.theta(i) ...
                MintStack.StackXpos MintStack.StackYpos MintStack.height*4+148 ...
                MintStack.StackTheta];
                MintStack = AddToChocStack(MintStack, 4);
            end

            chocolateCommands(12, setValue, handles.socket);
            pause(20);
        end

    end
    
    % check order fullfilable
    % do stacking
% important !!!!  Please write numbers to the <<handles.availableChoc>>
    wanted=handles.order;
    handles.availableChoc(1) = MilkStack.height;
    handles.availableChoc(2) = OrangeStack.height;
    handles.availableChoc(3) = DarkStack.height;
    handles.availableChoc(4) = MintStack.height;
    available=handles.availableChoc;
    checks=0;
    for ii=1:4
        if wanted(ii)>available(ii)
            checks=1;
        end
    end
    if checks==1
        msgbox('No Enough Choclate on the table');
    else
        scan = getsnapshot(handles.conveyorvid);
        BoxData = DetectBox(scan, 2);
        Stack1 = InitialiseChocStack(BoxData.Stack1.StackXpos , BoxData.Stack1.StackYpos , 28 , BoxData.Stack1.StackTheta);
        Stack2 = InitialiseChocStack(BoxData.Stack2.StackXpos , BoxData.Stack2.StackYpos , 28 , BoxData.Stack2.StackTheta);
        Stack3 = InitialiseChocStack(BoxData.Stack3.StackXpos , BoxData.Stack3.StackYpos , 28 , BoxData.Stack3.StackTheta);
        Stack4 = InitialiseChocStack(BoxData.Stack4.StackXpos , BoxData.Stack4.StackYpos , 28 , BoxData.Stack4.StackTheta);
        for b=1:4
            switch b
                case 1
                    setDestination = [Stack1.StackXpos Stack1.StackYpos Stack1.height*4+148 ...
                Stack1.StackTheta];
            case 2
                    setDestination = [Stack2.StackXpos Stack2.StackYpos Stack2.height*4+148 ...
                Stack2.StackTheta];
            case 3
                    setDestination = [Stack3.StackXpos Stack3.StackYpos Stack3.height*4+148 ...
                Stack3.StackTheta];
            case 4
                    setDestination = [Stack4.StackXpos Stack4.StackYpos Stack4.height*4+148 ...
                Stack4.StackTheta];
            end
           
           for c=1:6
              switch(handles.stackStatus(c,b))
                  case 2
                      setPick = [MilkStack.StackXpos MilkStack.StackYpos MilkStack.height*4+148 ...
                MilkStack.StackTheta];
                        MilkStack = RemoveFromChocStack(MilkStack);
                  case 3
                      setPick = [OrangeStack.StackXpos OrangeStack.StackYpos OrangeStack.height*4+148 ...
                OrangeStack.StackTheta];
                        OrangeStack = RemoveFromChocStack(OrangeStack);
                  case 4
                      setPick = [MintStack.StackXpos MintStack.StackYpos MintStack.height*4+148 ...
                MintStack.StackTheta];
                        MintStack = RemoveFromChocStack(MintStack);
                  case 5
                      setPick = [DarkStack.StackXpos DarkStack.StackYpos DarkStack.height*4+148 ...
                DarkStack.StackTheta];
                        DarkStack = RemoveFromChocStack(DarkStack);
              end
           end
           setValue = [setPick setDestination];
           chocolateCommands(15, setValue, handles.socket);
        end
        % send load order instruction
        % send the order for process 
    end    
end






% --- Executes on button press in order_stack_61.
function order_stack_61_Callback(hObject, eventdata, handles)
n=handles.stackStates(6,1);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(6,1)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_62.
function order_stack_62_Callback(hObject, eventdata, handles)
n=handles.stackStates(6,2);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(6,2)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_63.
function order_stack_63_Callback(hObject, eventdata, handles)
n=handles.stackStates(6,3);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(6,3)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_64.
function order_stack_64_Callback(hObject, eventdata, handles)
n=handles.stackStates(6,4);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(6,4)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_51.
function order_stack_51_Callback(hObject, eventdata, handles)
n=handles.stackStates(5,1);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(5,1)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_52.
function order_stack_52_Callback(hObject, eventdata, handles)
n=handles.stackStates(5,2);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(5,2)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_53.
function order_stack_53_Callback(hObject, eventdata, handles)
n=handles.stackStates(5,3);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(5,3)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_54.
function order_stack_54_Callback(hObject, eventdata, handles)
n=handles.stackStates(5,4);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(5,4)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_41.
function order_stack_41_Callback(hObject, eventdata, handles)
n=handles.stackStates(4,1);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(4,1)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_42.
function order_stack_42_Callback(hObject, eventdata, handles)
n=handles.stackStates(4,2);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(4,2)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_43.
function order_stack_43_Callback(hObject, eventdata, handles)
n=handles.stackStates(4,3);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(4,3)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_44.
function order_stack_44_Callback(hObject, eventdata, handles)
n=handles.stackStates(4,4);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(4,4)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_31.
function order_stack_31_Callback(hObject, eventdata, handles)
n=handles.stackStates(3,1);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(3,1)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_32.
function order_stack_32_Callback(hObject, eventdata, handles)
n=handles.stackStates(3,2);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(3,2)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_33.
function order_stack_33_Callback(hObject, eventdata, handles)
n=handles.stackStates(3,3);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(3,3)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_34.
function order_stack_34_Callback(hObject, eventdata, handles)
n=handles.stackStates(3,4);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(3,4)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_21.
function order_stack_21_Callback(hObject, eventdata, handles)
n=handles.stackStates(2,1);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(2,1)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_22.
function order_stack_22_Callback(hObject, eventdata, handles)
n=handles.stackStates(2,2);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(2,2)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_23.
function order_stack_23_Callback(hObject, eventdata, handles)
n=handles.stackStates(2,3);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(2,3)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_24.
function order_stack_24_Callback(hObject, eventdata, handles)
n=handles.stackStates(2,4);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(2,4)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_11.
function order_stack_11_Callback(hObject, eventdata, handles)
% hObject    handle to order_stack_11 (see GCBO)
n=handles.stackStates(1,1);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(1,1)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in order_stack_12.
function order_stack_12_Callback(hObject, eventdata, handles)
n=handles.stackStates(1,2);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(1,2)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_13.
function order_stack_13_Callback(hObject, eventdata, handles)
n=handles.stackStates(1,3);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(1,3)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on button press in order_stack_14.
function order_stack_14_Callback(hObject, eventdata, handles)
n=handles.stackStates(1,4);
n=n+1;
if n==6
    n=1;
end
handles.stackStates(1,4)=n;
type=handles.chocType(n);
color=handles.chocColor(n,:);
set(hObject,'String',type);
set(hObject,'Backgroundcolor',color );
guidata(hObject,handles);


% --- Executes on selection change in message_log.
function message_log_Callback(hObject, eventdata, handles)
% hObject    handle to message_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns message_log contents as cell array
%        contents{get(hObject,'Value')} returns selected item from message_log


% --- Executes during object creation, after setting all properties.
function message_log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to message_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset_order.
function reset_order_Callback(hObject, eventdata, handles)

    handles.stackStates(:,:)=5;
    order_stack_11_Callback(handles.order_stack_11,eventdata,handles);
    order_stack_12_Callback(handles.order_stack_12,eventdata,handles);
    order_stack_13_Callback(handles.order_stack_13,eventdata,handles);
    order_stack_14_Callback(handles.order_stack_14,eventdata,handles);
    order_stack_21_Callback(handles.order_stack_21,eventdata,handles);
    order_stack_22_Callback(handles.order_stack_22,eventdata,handles);
    order_stack_23_Callback(handles.order_stack_23,eventdata,handles);
    order_stack_24_Callback(handles.order_stack_24,eventdata,handles);
    order_stack_31_Callback(handles.order_stack_31,eventdata,handles);
    order_stack_32_Callback(handles.order_stack_32,eventdata,handles);
    order_stack_33_Callback(handles.order_stack_33,eventdata,handles);
    order_stack_34_Callback(handles.order_stack_34,eventdata,handles);
    order_stack_41_Callback(handles.order_stack_41,eventdata,handles);
    order_stack_42_Callback(handles.order_stack_42,eventdata,handles);
    order_stack_43_Callback(handles.order_stack_43,eventdata,handles);
    order_stack_44_Callback(handles.order_stack_44,eventdata,handles);
    order_stack_51_Callback(handles.order_stack_51,eventdata,handles);
    order_stack_52_Callback(handles.order_stack_52,eventdata,handles);
    order_stack_53_Callback(handles.order_stack_53,eventdata,handles);
    order_stack_54_Callback(handles.order_stack_54,eventdata,handles);
    order_stack_61_Callback(handles.order_stack_61,eventdata,handles);
    order_stack_62_Callback(handles.order_stack_62,eventdata,handles);
    order_stack_63_Callback(handles.order_stack_63,eventdata,handles);
    order_stack_64_Callback(handles.order_stack_64,eventdata,handles);
    handles.stackStates(:,:)=1;
    guidata(hObject,handles)
    
    


function send_order_Callback(hObject, eventdata, handles)


% hObject    handle to send_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pause_stop2.
function pause_stop2_Callback(hObject, eventdata, handles)
% hObject    handle to pause_stop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f=get(hObject,'Value');
if f==0
    set(hObject,'Backgroundcolor','green');
    % send instruction
else
    set(hObject,'Backgroundcolor','red')
    % send instruction
end
% Hint: get(hObject,'Value') returns toggle state of pause_stop2


% --- Executes on button press in place_single.
function place_single_Callback(hObject, eventdata, handles)
% Finds a single chocolate and places it in the predefined position
snap = getsnapshot(handles.tablevid); % get snap from feed
ChocolateData = z337302_MTRN4230_ASST2(snap, 1); % process snap
if (size(ChocolateData, 1) >= 1)
    initialx = ChocolateData.xpos(1); %get values from snap
    initialy = ChocolateData.ypos(1);
    initialtheta = ChocolateData.theta(1);
    initialz = 148; % should be constant
    setValue = [initialx initialy initialz initialtheta 200 100 initialz 0];
    chocolateCommands(12, setValue, handles.socket);
end

% hObject    handle to place_single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles) % not sure which button this is referring to
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sorting_table.
function sorting_table_Callback(hObject, eventdata, handles)
% Purpose: Performs image processing, clears the stacking positions and
% stacks chocolates in the predefined positions.
snap = getsnapshot(handles.tablevid); % get snap from feed
ChocolateData = z3373202_MTRN4230_ASST2(snap, 1); % process snap
MilkStack = InitialiseChocStack(200 , 100 , 90 , 0);
DarkStack = InitialiseChocStack(200 , 200 , 90 , 0);
OrangeStack = InitialiseChocStack(200 , 300 , 90 , 0);
MintStack = InitialiseChocStack(200 , 400 , 90 , 0);
if (size(ChocolateData, 2) >= 1)
    %Check stacking positions clear if not figure out how to clear
    [blockingChocs,nonBlockingChocs] = StackingPosClear(ChocolateData);
    if ((size(blockingChocs.type, 1) >=1) && (size(blockingChocs.type, 2) >= 1))
        tempStack = defineTempStack(nonBlockingChocs);
        for i=1:size(blockingChocs.type, 1) % clears stacking area and adds chocolates to temp stack
            setValue = [blockingChocs.xpos(i) blockingChocs.ypos(i) ...
                148 blockingChocs.theta(i) ...
                tempStack.StackXpos tempStack.StackYpos tempStack.height*4+148 ...
                tempStack.StackTheta];
            chocolateCommands(12, setValue, handles.socket);
            tempStack = AddToChocStack(tempStack, blockingChocs.type(i));
        end
        % defines the predefined stacks
        while (tempStack.height > 0)
            switch(tempStack.TypeAtTop)
                case 1 %milk
                    setValue = [tempStack.StackXpos tempStack.StackYpos ...
                        tempStack.height*4+148 tempStack.StackTheta ...
                        MilkStack.StackXpos MilkStack.StackYpos ...
                        MilkStack.height*4+148 MilkStack.StackTheta];
                    chocolateCommands(12, setValue, handles.socket);
                    MilkStack = AddToChocStack(MilkStack, 1);
                    [tempStack ~] = RemoveFromChocStack(tempStack);
                case 2 %dark
                    setValue = [tempStack.StackXpos tempStack.StackYpos ...
                        tempStack.height*4+148 tempStack.StackTheta ...
                        DarkStack.StackXpos DarkStack.StackYpos ...
                        DarkStack.height*4+148 DarkStack.StackTheta];
                    chocolateCommands(12, setValue, handles.socket);
                    DarkStack = AddToChocStack(DarkStack, 2);
                    [tempStack ~] = RemoveFromChocStack(tempStack);
                case 3 %orange
                    setValue = [tempStack.StackXpos tempStack.StackYpos ...
                        tempStack.height*4+148 tempStack.StackTheta ...
                        OrangeStack.StackXpos OrangeStack.StackYpos ...
                        OrangeStack.height*4+148 OrangeStack.StackTheta];
                    chocolateCommands(12, setValue, handles.socket);
                    OrangeStack = AddToChocStack(OrangeStack, 3);
                    [tempStack ~] = RemoveFromChocStack(tempStack);
                case 4 %mint
                    setValue = [tempStack.StackXpos tempStack.StackYpos ...
                        tempStack.height*4+148 tempStack.StackTheta ...
                        MintStack.StackXpos MintStack.StackYpos ...
                        MintStack.height*4+148 MintStack.StackTheta];
                    chocolateCommands(12, setValue, handles.socket);
                    MintStack = AddToChocStack(MintStack, 4);
                    [tempStack ~] = RemoveFromChocStack(tempStack);
                case 5 %upside down
                    %flips chocolate and returns it to the temp stack
                    flipChocolate(handles, tempStack.StackXpos, tempStack.StackYpos, ...
                        tempStack.height*4+148, tempStack.StackTheta);
                otherwise
                    fprintf('Invalid chocolate type in stack\n');
            end
                    
        end
    end
    for i=1:size(nonBlockingChocs.type, 1)
        switch nonBlockingChocs.type(i)
            case 1
                setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
            148 nonBlockingChocs.theta(i) ...
            MilkStack.StackXpos MilkStack.StackYpos MilkStack.height*4+148 ...
            MilkStack.StackTheta];
            MilkStack = AddToChocStack(MilkStack, 1);
            case 2
                setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
            148 nonBlockingChocs.theta(i) ...
            DarkStack.StackXpos DarkStack.StackYpos DarkStack.height*4+148 ...
            DarkStack.StackTheta];
            DarkStack = AddToChocStack(DarkStack, 2);
            case 3
                setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
            148 nonBlockingChocs.theta(i) ...
            OrangeStack.StackXpos OrangeStack.StackYpos OrangeStack.height*4+148 ...
            OrangeStack.StackTheta];
            OrangeStack = AddToChocStack(OrangeStack, 3);
            case 4
                setValue = [nonBlockingChocs.xpos(i) nonBlockingChocs.ypos(i) ...
            148 nonBlockingChocs.theta(i) ...
            MintStack.StackXpos MintStack.StackYpos MintStack.height*4+148 ...
            MintStack.StackTheta];
            MintStack = AddToChocStack(MintStack, 4);
        end

        chocolateCommands(12, setValue, handles.socket);
        pause(20);
    end
        
end
% handles.MilkStack = MilkStack;
% handles.DarkStack = DarkStack;
% handles.OrangeStack = OrangeStack;
% handles.MintStack = MintStack;
% guidata(hObject, handles);


% --- Executes on button press in unload.
function unload_Callback(hObject, eventdata, handles)

% send unload order

% hObject    handle to unload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pause_stop1.
function pause_stop1_Callback(hObject, eventdata, handles)
% hObject    handle to pause_stop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f=get(hObject,'Value');
if f==0
    set(hObject,'Backgroundcolor','green')
else
    set(hObject,'Backgroundcolor','red')
end
    
% Hint: get(hObject,'Value') returns toggle state of pause_stop1


% --- Executes on button press in connect_button.
function connect_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to connect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'Value')
    set(hObject, 'Backgroundcolor', 'g');
    socket = Server_Connect;
    handles.socket = socket;
% %     Timer start
%     if strcmp(get(handles.timer, 'Running'), 'off')
%         start(handles.timer);
%     end
    guidata(hObject, handles);
else
    set(hObject, 'Backgroundcolor', 'r');
    Server_Disconnect(handles.socket);
% %     Timer stop
%     if strcmp(get(handles.timer, 'Running'), 'on')
%         stop(handles.timer);
%     end
    % Need to test if deleting the object works properly
    delete(handles.socket);
    guidata(hObject, handles);
end
