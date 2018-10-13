function varargout = A3_GUI(varargin)
    % A3_GUI MATLAB code for A3_GUI.fig
    %      A3_GUI, by itself, creates a new A3_GUI or raises the existing
    %      singleton*.
    %
    %      H = A3_GUI returns the handle to a new A3_GUI or the handle to
    %      the existing singleton*.
    %
    %      A3_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in A3_GUI.M with the given input arguments.
    %
    %      A3_GUI('Property','Value',...) creates a new A3_GUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before A3_GUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to A3_GUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help A3_GUI

    % Last Modified by GUIDE v2.5 12-Oct-2018 02:47:01

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @A3_GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @A3_GUI_OutputFcn, ...
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
end


% --- Executes just before A3_GUI is made visible.
% -------------------------------------------------------------------------
% --- This function will create all the global variables necessary 
% --- for the correct passing of data between individual gui functions and 
% --- between SendAndRecieve() and the gui.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function A3_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    dbstop if error;
    
    
    % Test python server to recieve and send information. Written to test
    % TCP functions for MATLAB until RAPID is completed. Comment out when
    % submitting.
    !python trialserver.py &
    
    allTimers = timerfind();
    try
        stop(allTimers);
        delete(allTimers);
    catch
    end
    
    % Choose default command line output for A3_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes A3_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
 
    % Create the socket object
    global CommSocket               
    CommSocket = tcpcomms();

    % Create a command queue
    % All commands will be added to the queue to be processed in sequence by
    % function SendAndRecieve firing through a timer function
    global CommandQueue             
    CommandQueue = ["SetFrame","SetJoints"];

    % Struct to store Speed, Mode and Frame params
    % Sets the default values to the value seen on the first option of the
    % popup menu.
    global Params                  
    Params.Speed = "V500";  
    Params.Mode = " ";
    Params.Frame = "Table"      % Destination Frame
    Params.FrameCurrent = "Table";

    % Struct to store the pose input from the user
    global Pose
    Pose = [];
         
    global Joints
    Joints = [0,0,0,0,0,0];
    % Struct to store the states of the IO
    % 0 = off | 1 = on
    global IO
    IO = struct('ConvRun',0,'ConvDir',0,'VacSol',0,'VacPump',0);

    % Cell array to store all the commands sent.
    % This can then be used to update the command history log.
    global SentCommands
    SentCommands = {};

    % Cell array to store all the commands recieved.
    % This can then be used to update the command history log.
    global RecvCommands
    RecvCommands = {};
    
    % As handles will need to be passed to SendAndRecieve 
    % handles from GUI will be stored in a global variable.
    global Handles
    Handles = handles;

    % Ensuring the GUI is still running.
    global QUIT
    QUIT = false;
           
    % Global variable to store the state of program control.
    % Allows the sytem to resume, pause, cancel programs.
    global ProgControl
    ProgControl = [];
    
    % Define positions of the block points.
    global BlockPoints
    BlockPoints = zeros(21,3);
    BlockPoints(1,:) = [18,230 0];
    
    % Find all existing image objects and deletes them.
    try
        out = imaqfind();
        delete(out);
    catch
    end
    
    try
    % Fnd all availble camera inputs
    adaptor = imaqhwinfo;
    adaptor = adaptor.InstalledAdaptors;
    adaptor = adaptor{1};
    catch
    end
    % Create a struct to store the camera objects and images
    global Cameras
    Cameras = struct('TableCam',struct('CamObj',[],'Image',[]),'ConvCam',struct('CamObj',[],'Image',[]));
    
    try
        % Try to access the first adaptor, this will belong to the table
        % camera. Configure a trigger, return images in RGB and start
        % recieving data from the camera.
        Cameras.TableCam.Obj = videoinput(adaptor,1);
        triggerconfig(Cameras.TableCam.Obj, 'manual');
        set(Cameras.TableCam.Obj,'ReturnedColorSpace','RGB'); 
    catch
    end
    
    try
        % Try to access the second adaptor, this will belong to the
        % conveyor camera. Configure a trigger, return images in RGB and 
        % start recieving data from the camera.
        Cameras.ConvCam.Obj = videoinput(adaptor,2);
        triggerconfig(Cameras.ConvCam.Obj, 'manual');
        set(Cameras.ConvCam.Obj,'ReturnedColorSpace','RGB');    
    catch
    end
        
    % Create a timer which will fire the Send And Recieve Function. 
    global CommTimer
    CommTimer = timer('TimerFcn',@SendAndRecieve,'StartDelay',1,'Period',0.1,'ExecutionMode','fixedSpacing');
end

% --- Outputs from this function are returned to the command line.
function varargout = A3_GUI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on button press in SWPskip.
% -------------------------------------------------------------------------
% --- This function will be caled when the skip button is pressed. It calls
% --- a user written function which obtains all values of the checkboxes.
% --- It then sets those checkboxes with inverted values. This is a method
% --- to skip having to check every box on the safety information page.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SWPskip_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPskip (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    SWPValues = SWPGET(handles);
    SWPValues = ~SWPValues;
    SWPSET(SWPValues,handles);
end

% --- Executes on button press in SWPaccept.
% -------------------------------------------------------------------------
% --- This function is the callback function for when the accept button is
% --- pressed. Checks if all checkboxes have been ticked. If yes, the
% --- panel is hidden and main gui panels are made visible. 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SWPaccept_Callback(hObject, eventdata, handles)
    global Cameras
    
    % Get array of values from the checkboxes. 
    SWP = SWPGET(handles);
    zero = find(SWP ~= 1);
    
    % If none of them are zero, means all have been checked. 
    % The gui should then initialise all control panels
    
    if (isempty(zero))
        % Effectly changing 'screens'
        set(handles.ProgramControlPanel,'Visible','On');
        set(handles.EventRecorderPanel,'Visible','On');
        set(handles.JointAnglesPanel,'Visible','On');
        set(handles.CompliancePanel,'Visible','Off');
        set(handles.MainControlPanel,'Visible','On');
    
       % Check the connection and ensure tcp socket has the correct IP and
       % Port
%         CommSocket.connectionCheck(handles);
%         start(CommTimer);
    try
        start(Cameras.TableCam.Obj);
        start(Cameras.ConvCam.Obj);
    catch
    end
    else
        msgbox('You must accept all checklist items');
    end
end

% --- Executes on button press in SWPdecline.
% -------------------------------------------------------------------------
% --- Just adds for visual functionality. 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SWPdecline_Callback(hObject, eventdata, handles)  
    msgbox('WRONG CHOICE BUDDY. TRY AGAIN');
end

% --- Executes on button press in ResumeProgBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the RESUME button is pressed. This
% --- will send a command to RAPID to resume the current command.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function ResumeProgBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global ProgControl
    
    % Set program control value. This will determine what control measure
    % has been set.
    ProgControl = 1;
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"ProgCtrl"];
end

% --- Executes on button press in PauseProgBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the PAUSE button is pressed. This
% --- will send a command to RAPID to pause the current command.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function PauseProgBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global ProgControl
    
    % Set program control value. This will determine what control measure
    % has been set.
    ProgControl = 2;
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"ProgCtrl"];
end

% --- Executes on button press in CancelProgBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the CANCEL button is pressed. This
% --- will send a command to RAPID to cancel the current command and ready
% --- the robot to accept a new command.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function CancelProgBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global ProgControl

    % Set program control value. This will determine what control measure
    % has been set.
    ProgControl = 3;
    
    % Add the command to the command queue.
    CommandQueue = [];
    CommandQueue = ["ProgCtrl"];
end

% --- Executes on button press in ProgShutDownBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the SHUTDOWN button is pressed.
% --- This will programatically shut down all DIO, set the position of the
% --- end effector above the table and then sets all joints to 0 which will
% --- set the robot in the home position. These commands are sequentially
% --- added to the command queue to be sent to RAPID.
% --- will send a command to RAPID to cancel the current command and ready
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function ProgShutDownBtn_Callback(hObject, eventdata, handles)

    global CommandQueue
    global Params
    global Pose
    global Joints

    CommandQueue = ["VacOff"];
    CommandQueue = [CommandQueue,"ConvOff"];
    
    switch Params.FrameCurrent
        case "Table"
            Joints = [-90,0,0,0,0,0];
            CommandQueue = [CommandQueue,"SetJoints"];
            
        case "Conv"
            Pose = [0,0,300];
            CommandQueue = [CommandQueue,"SetPose"];
            Joints = [-90,0,0,0,0,0];
            CommandQueue = [CommandQueue,"SetJoints"];                 
    end
end

% --- Executes on button press in TableCamBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the TABLE CAMERA button is pressed. 
% --- This will allow the user to choose a point on the table to where the
% --- robot should be sent. Then sets the desired pose in the global
% --- variable and adds a command to the command queue to send pose to
% --- RAPID.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function TableCamBtn_Callback(hObject, eventdata, handles)
    global Handles
    global Target
    global CommandQueue
    
    robotCentre = [642, 1178];
    convertX = 0.6491;
    convertY = 0.6727;

    load('table_calib_param.mat');
    
    [inx,iny] = ginput(1);
    UndistortedPoints = undistortPoints([inx,iny], cameraParams);
    xCamera = UndistortedPoints(1);
    yCamera = 720-UndistortedPoints(2);
    
    worldXPoint = (-yCamera + robotCentre(2)) * convertY;
    worldYPoint = (xCamera-robotCentre(1)) * convertX;
    worldZPoint = 30;
    
    Target = [worldXPoint-175,worldYPoint,worldZPoint];
    CommandQueue = [CommandQueue,"SetTarget"];
end

% --- Executes on button press in ManualConnectBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Connect Button is pressed. This
% --- is only enabled when there is no connection. It will allow the user
% --- reconnect to the server. It will also open a dialogue box to allow
% --- the user to check the IP address and port number and can be changed
% --- if necessary without restarting the GUI.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function ManualConnectBtn_Callback(hObject, eventdata, handles)
    global CommSocket
    global CommTimer
    
    % Find all active timers;
    % stop if any are found, and delete them. 
    allTimers = timerfind();
    try
        stop(allTimers);
        %delete(allTimers);
    catch
    end
    %clear allTimers;

    % Call function to set/maintain IP and port.
    CommSocket.manualConnect();
    
    % Check the connection to the server with new/existing IP and
    % portnumber.
    CommSocket.connectionCheck(handles);
    
    if (CommSocket.STATUS)
        start(allTimers(1));
    end
end

% --- Executes on button press in LoadBtn.
function LoadBtn_Callback(hObject, eventdata, handles)
    global IO
    global CommandQueue
    global TimeKeep
    
    IO.ConvDir = 1;
    
    % Add to command queue
    CommandQueue = [CommandQueue,"ConvOn"];
    
    TimeKeep.Conv = tic;
end


% --- Executes on button press in ReloadBtn.
function ReloadBtn_Callback(hObject, eventdata, handles)
    global IO    
    global CommandQueue
    global TimeKeep
    
    IO.ConvDir = 0;
        
    % Add to command queue
    CommandQueue = [CommandQueue,"ConvOn"];
    
    TimeKeep.Conv = tic;
end

% --- Executes on button press in BP1BP2Btn.
function BP1BP2Btn_Callback(hObject, eventdata, handles)
    global BlockPoints
    global CommandQueue
    global Pose
    global Params
    global Joints
    global Handles
    
    tempCommQueue = [];
        
    switch Params.FrameCurrent
        
        case "Table"
            % Obtain target and location of desired target and destination
            % location.
            axes(Handles.axes1);
            [xt,yt] = ginput(1);
            axes(Handles.axes1);
            [xd,yd] = ginput(1);
            
            % Convert to base coordinates
            [xtarg,ytarg] = Table2Base(xt,yt);
            [xdest,ydest] = Table2Base(xd,yd);
            
            % Send arm to that location above the block;
            Pose = [xtarg,ytarg,50];
            tempCommQueue = ["SetPose"];
           
            % Place the arm down onto the block;
            Pose = [Pose; [xtarg,ytarg,0]];
            tempCommQueue = [tempCommQueue, "SetPose"];
            
            % Turn on the vacuum to hold block;
            tempCommQueue = [tempCommQueue,"VacOn"];
            
            % Lift the arm up
            Pose = [Pose; [xtarg,ytarg,50]];
            tempCommQueue = [tempCommQueue, "SetPose"];
            
            % Send To destination
            Pose = [Pose; [xdest,ydest,50]];
            tempCommQueue = [tempCommQueue, "SetPose"];
            
            % Lower the arm
            Pose = [Pose; [xdest,ydest,0]];
            tempCommQueue = [tempCommQueue, "SetPose"];
            
            % Turn the Vac Off
            tempCommQueue = [tempCommQueue, "VacOff"];
            
            % Raise the arm
            Pose = [Pose; [xdest,ydest,50]];
            tempCommQueue = [tempCommQueue, "SetPose"];

            Params.FrameCurrent = "Table";
            CommandQueue = tempCommQueue;
            
        case "Conv"
            % Obtain target and location of desired target and destination
            % location.
           
            axes(Handles.axes1);
            [xt,yt] = ginput(1);
            axes(Handles.axes1);
            [xd,yd] = ginput(1);

            % Convert to base coordinates
            [xtarg,ytarg] = Table2Base(xt,yt);
            [xdest,ydest] = Table2Base(xd,yd);
                       
            % If it as the conveyor, then raise the arm to avoid hitting
            % the table.
            Pose = [0,0,300];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            % Set the joints to position the arm to the middle of the
            % table.
            Joints = [0,30,0,0,0];
            tempCommQueue = [tempCommQueue,"SetJoints"];
            
            % Set Frame of reference
            Params.Frame = "Table";
            tempCommQueue = [tempCommQueue,"SetFrame"];
            
            % Set Target Above block
            Pose = [Pose;[xtarg, ytarg,50]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            % Lower the arm
            Pose = [Pose;[xtarg, ytarg,0]];
            tempCommQueue = [tempCommQueue,"SetPose"];

            % Send Command to turn solenoid and pump on
            tempCommQueue = [tempCommQueue,"VacOn"];
            
            % Raise the arm
            Pose = [Pose;[xtarg, ytarg,50]];
            tempCommQueue = [tempCommQueue,"SetPose"];

            % Move it over to the destination
            Pose = [Pose;[xdest, ydest,50]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            % Lower the arm
            Pose = [Pose;[xdest, ydest,0]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            % Send Command to turn solenoid and pump off
            tempCommQueue = [tempCommQueue,"VacOff"];
            
            % Move it over to the destination
            Pose = [Pose;[xdest, ydest,50]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            CommandQueue = tempCommQueue;

            Params.FrameCurrent = "Table";
    end
end

% --- Executes on button press in BPCONVBtn.
function BPCONVBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global Pose
    global Params
    global Joints
    global Handles
    
    tempCommQueue = [];
    
    switch Params.FrameCurrent
        
        case "Conv"
            % Obtain target and location of desired target and destination
            % location.
            axes(Handles.axes1);
            [xt,yt] = ginput(1);
            
            % Convert to base coordinates
            [xtarg,ytarg] = Table2Base(xt,yt);
            
            % If it as the conveyor, then raise the arm to avoid hitting
            % the table.
            Pose = [0,0,300];
            tempCommQueue = ["SetPose"];
            
            % Set the joints to position the arm to the middle of the
            % table.
            Joints = [0,30,0,0,0];
            tempCommQueue = [tempCommQueue,"SetJoints"];
            
            % Set Frame of reference
            Params.Frame = ["Table"];
            tempCommQueue = [tempCommQueue,"SetFrame"];
            
            % Set Target Above block
            Pose = [Pose;[xtarg, ytarg,50]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            % Lower the arm
            Pose = [Pose;[xtarg, ytarg,0]];
            tempCommQueue = [tempCommQueue,"SetPose"];

            % Send Command to turn solenoid and pump on
            tempCommQueue = [tempCommQueue,"VacOn"];
            
            % Raise the arm
            Pose = [Pose;[xtarg, ytarg,50]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            % Set the joints to position the arm to the middle of the
            % table.
            Joints = [Joints;[0,30,0,0,0]];
            tempCommQueue = [tempCommQueue,"SetJoints"];
            
            % Set the joints to position the arm over conveyor home.
            Joints = [Joints;[90,30,0,0,0]];
            tempCommQueue = [tempCommQueue,"SetJoints"];

            % Set Frame of reference
            Params.Frame = [Params.Frame;"Conv"];
            tempCommQueue = [tempCommQueue,"SetFrame"];
                        
            % Set Destination as conveyor home
            Pose = [Pose;[0, 0, 0]];
            tempCommQueue = [tempCommQueue,"SetPose"];            

            % Send Command to turn solenoid and pump on
            tempCommQueue = [tempCommQueue,"VacOff"];
            
            % If it as the conveyor, then raise the arm to avoid hitting
            % the table.
            Pose = [Pose;[0,0,300]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            CommandQueue = tempCommQueue;

            Params.FrameCurrent = "Conv";
            
        case "Table"
            % Obtain target and location of desired target and destination
            % location.
            axes(Handles.axes1);
            [xt,yt] = ginput(1);
            
            % Convert to base coordinates
            [xtarg,ytarg] = Table2Base(xt,yt);
            
            % Send arm to that location above the block;
            Pose = [xtarg,ytarg,50];
            tempCommQueue = ["SetPose"];
           
            % Place the arm down onto the block;
            Pose = [Pose; [xtarg,ytarg,0]];
            tempCommQueue = [tempCommQueue, "SetPose"];
            
            % Turn on the vacuum to hold block;
            tempCommQueue = [tempCommQueue,"VacOn"];
            
            % Lift the arm up
            Pose = [Pose; [xtarg,ytarg,50]];
            tempCommQueue = [tempCommQueue, "SetPose"];

            % Set the joints to position the arm to the middle of the
            % table.
            Joints = [0,30,0,0,0];
            tempCommQueue = [tempCommQueue,"SetJoints"];
            
            % Set the joints to position the arm over conveyor home.
            Joints = [Joints;[90,30,0,0,0]];
            tempCommQueue = [tempCommQueue,"SetJoints"];

            % Set Frame of reference
            Params.Frame = "Conv";
            tempCommQueue = [tempCommQueue,"SetFrame"];
                        
            % Set Destination as conveyor home
            Pose = [Pose;[0, 0, 0]];
            tempCommQueue = [tempCommQueue,"SetPose"];            

            % Send Command to turn solenoid and pump on
            tempCommQueue = [tempCommQueue,"VacOff"];
            
            % If it as the conveyor, then raise the arm to avoid hitting
            % the table.
            Pose = [Pose;[0,0,300]];
            tempCommQueue = [tempCommQueue,"SetPose"];
            
            CommandQueue = tempCommQueue;

            Params.FrameCurrent = "Conv";
    end
end

% --- Executes on button press in CONVBPBtn.
function CONVBPBtn_Callback(hObject, eventdata, handles)
    global BlockPoints
    global CommandQueue
    global Pose
    global Params
    global Joints
    
    
    switch (Params.FrameCurrent)
        
        case "Table"
            Pose.Avoid1 = [str2double(get(handles.EEX,"String"))-175,str2double(get(handles.EEY,"String")),40];
            CommandQueue = [CommandQueue,"SetAvoid1"];
            
            Joints.Target = [90,30,0,0,0,0];
            CommandQueue = [CommandQueue,"SetTargetJoints"];
            
            % Set Frame of Reference to the Conveyor frame for positioning
            Params.Frame1 = "Conv";

            % Send command to set Frame
            CommandQueue = [CommandQueue,"SetTargetFrame"];
            
            % Set target to those coordinates
            Pose.Target = [0,0,0];

            % Send command to set pose
            CommandQueue = [CommandQueue,"SetTarget"];
            
            % Send Command to turn solenoid and pump on
            CommandQueue = [CommandQueue,"VacOn"];
            
            Pose.Avoid2= [0,0,300];
            CommandQueue = [CommandQueue,"SetAvoid2"];
            
            Joints.Destination = [0,30,0,0,0,0];
            CommandQueue = [CommandQueue,"SetDestJoints"];
            
            Params.Frame2 = "Table";
            CommandQueue = [CommandQueue,"SetDestFrame"];
            
            % Find desired destination block position
            toBP = cellstr(get(handles.ToBPList,'String'));
            toBP = toBP{get(handles.ToBPList,'Value')};

            % Find it's coordinates
            BP2 = BlockPoints(str2num(toBP),:);

            Pose.Avoid3 = [BP1(1),BP1(2),40];
            CommandQueue = [CommandQueue,"SetAvoid3"];

            % Set target to those coordinates
            Pose.Destination = [BP2(1),BP2(2),40];

            % Send command to set pose
            CommandQueue = [CommandQueue,"SetDestination"];

            Pose.Avoid4 = [BP2(1),BP2(2),BP2(3)];
            CommandQueue = [CommandQueue,"SetAvoid4"];

            % Send Command to turn solenoid and pump off
            CommandQueue = [CommandQueue,"VacOff"];

            Params.FrameCurrent = "Table";
    
        case "Conv"
            % Set target to those coordinates
            Pose.Target = [0,0,0];

            % Send command to set pose
            CommandQueue = [CommandQueue,"SetTarget"];
            
            % Send Command to turn solenoid and pump on
            CommandQueue = [CommandQueue,"VacOn"];
            
            Pose.Avoid2= [0,0,300];
            CommandQueue = [CommandQueue,"SetAvoid2"];
            
            Joints.Destination = [0,30,0,0,0,0];
            CommandQueue = [CommandQueue,"SetDestJoints"];
            
            Params.Frame2 = "Table";
            CommandQueue = [CommandQueue,"SetDestFrame"];
            
            % Find desired destination block position
            toBP = cellstr(get(handles.ToBPList,'String'));
            toBP = toBP{get(handles.ToBPList,'Value')};

            % Find it's coordinates
            BP2 = BlockPoints(str2num(toBP),:);

            Pose.Avoid3 = [BP2(1),BP2(2),40];
            CommandQueue = [CommandQueue,"SetAvoid3"];

            % Set target to those coordinates
            Pose.Destination = [BP2(1),BP2(2),40];

            % Send command to set pose
            CommandQueue = [CommandQueue,"SetDestination"];

            Pose.Avoid4 = [BP2(1),BP2(2),BP2(3)];
            CommandQueue = [CommandQueue,"SetAvoid4"];

            % Send Command to turn solenoid and pump off
            CommandQueue = [CommandQueue,"VacOff"];

            Params.FrameCurrent = "Table";
    end
end


% --- Executes when user attempts to close figure1.
% -------------------------------------------------------------------------
% --- This function will be called when the CLOSE FIGURE button is pressed. 
% --- Then the gui begins to shutdown. All camera feeds will be stopped.
% --- The timer controlling the Send and Receive messages will be stopped.
% --- Quit message will be sent to RAPID to tell them that it is closing.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function figure1_CloseRequestFcn(hObject, eventdata, handles)  
    global QUIT
    global CommTimer
    global Cameras
    global CommSocket
    
    % If the camera feeds are active, stop them both.
    try
        stop(Cameras.TableCam.Obj);
        stop(Cameras.ConvCam.Obj);
        
        delete(Cameras.TableCam.Obj);
        delete(Cameras.ConvCam.Obj);
    catch
    end
    
    % Set variable to true. This will tell SENDANDRECEIVE not to recieve or
    % send any more messages.
    QUIT = true;
    pause(0.5);
    
    try
        % Stop the operation of SENDANDRECIEVE
        stop(CommTimer);
        delete(CommTimer);

        % Tell RAPID the gui is closing.
        fwrite(CommSocket.SENDSOCKET,'QUIT');
        fclose(CommSocket.SENDSOCKET);
    catch
    end
    % Close the gui
    delete(hObject);
end


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------- USER DEFINED HELPER FUNCTIONS ----------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% --- Helper function. Will get an array of values for each of the check
% --- boxes.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function val = SWPGET(handles)
    val(1) = get(handles.SWPcb1,'Value');
    val(2) = get(handles.SWPcb2,'Value');
    val(3) = get(handles.SWPcb3,'Value');
    val(4) = get(handles.SWPcb4,'Value');
    val(5) = get(handles.SWPcb5,'Value');
    val(6) = get(handles.SWPcb6,'Value');
    val(7) = get(handles.SWPcb7,'Value');
    val(8) = get(handles.SWPcb8,'Value');
    val(9) = get(handles.SWPcb9,'Value');
    val(10) = get(handles.SWPcb10,'Value');
end

% -------------------------------------------------------------------------
% --- Helper function. Will set the values of the all checkboxes in the
% --- Compliance panel.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SWPSET(values, handles)
    set(handles.SWPcb1,'Value',values(1))
    set(handles.SWPcb2,'Value',values(2))
    set(handles.SWPcb3,'Value',values(3))
    set(handles.SWPcb4,'Value',values(4))
    set(handles.SWPcb5,'Value',values(5))
    set(handles.SWPcb6,'Value',values(6))
    set(handles.SWPcb7,'Value',values(7))
    set(handles.SWPcb8,'Value',values(8))
    set(handles.SWPcb9,'Value',values(9))
    set(handles.SWPcb10,'Value',values(10))
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% ------------- UNMODIFIED FUNCTIONS ( ESSENTIAL FOR GUI ) ----------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% --- Executes on button press in SWPcb5.
function SWPcb1_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb8.
function SWPcb2_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb10.
function SWPcb3_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb2.
function SWPcb4_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb3.
function SWPcb5_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb4.
function SWPcb6_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb7.
function SWPcb7_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb9.
function SWPcb8_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb1.
function SWPcb9_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in SWPcb6.
function SWPcb10_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in ConvCamBtn.
function ConvCamBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to ConvCamBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on selection change in TXcommands.
function TXcommands_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function TXcommands_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in RXcommands
function RXcommands_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function RXcommands_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function SWPaccept_CreateFcn(hObject, eventdata, handles)
% MATLAB raising error if not present.
end

% --- Executes when selected object is changed in ConnectButton
function ConnectButtonGroup_SelectionChangedFcn(hObject, eventdata, handles)
	global CommSocket
    switch(get(eventdata.NewValue,'Tag'))
        case 'robotconnect'
            CommSocket.IP = "192.168.125.1";
            CommSocket.PORT = 1025;
        case 'localconnect'
            CommSocket.IP = "127.0.0.1";
            CommSocket.PORT = 56000;
    end
end

function [wpx,wpy] = Table2Base(xin,yin)
    load('cameraParamsTable.mat');

    ConvertedPoints = undistortPoints([xin,yin], cameraParamsTable);
%     x = ConvertedPoints(1,1);
%     y = ConvertedPoints(1,2);
x = xin;
y = yin;
    y = 1200 - y;

    if(x>1600) || (y>1200) || (x<0) || (y<0)
        x = NaN;
        y = NaN;
        z = NaN;
    end

    pxToMMx = 0.6494;
    pxToMMy = 0.6502;

    tableXoffsetPx = 800; 
    tableYoffsetPx = 1178;

    RobFramey = (x - tableXoffsetPx)*pxToMMx;
    RobFramex = (-y + tableYoffsetPx)*pxToMMy;    

    wpx = RobFramex-175;
    wpy = RobFramey;
end
