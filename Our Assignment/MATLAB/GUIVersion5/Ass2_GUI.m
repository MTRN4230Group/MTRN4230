function varargout = Ass2_GUI(varargin)
    % ASS2_GUI MATLAB code for Ass2_GUI.fig
    %      ASS2_GUI, by itself, creates a new ASS2_GUI or raises the existing
    %      singleton*.
    %
    %      H = ASS2_GUI returns the handle to a new ASS2_GUI or the handle to
    %      the existing singleton*.
    %
    %      ASS2_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in ASS2_GUI.M with the given input arguments.
    %
    %      ASS2_GUI('Property','Value',...) creates a new ASS2_GUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before Ass2_GUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to Ass2_GUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help Ass2_GUI

    % Last Modified by GUIDE v2.5 17-Sep-2018 21:42:40

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Ass2_GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @Ass2_GUI_OutputFcn, ...
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


% --- Executes just before Ass2_GUI is made visible.
% -------------------------------------------------------------------------
% --- This function will create all the global variables necessary 
% --- for the correct passing of data between individual gui functions and 
% --- between SendAndRecieve() and the gui.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function Ass2_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    
    % Test python server to recieve and send information. Written to test
    % TCP functions for MATLAB until RAPID is completed. Comment out when
    % submitting.
    !python trialserver.py &
    
    % Choose default command line output for Ass2_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes Ass2_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
 
    % Create the socket object
    global CommSocket               
    CommSocket = tcpcomms();

    % Create a command queue
    % All commands will be added to the queue to be processed in sequence by
    % function SendAndRecieve firing through a timer function
    global CommandQueue             
    CommandQueue = [];

    % Struct to store Speed, Mode and Frame params
    % Sets the default values to the value seen on the first option of the
    % popup menu.
    global Params                  
    Params.Speed = cellstr(get(handles.SetSpeedPopup,'String'));
    Params.Speed = Params.Speed{get(handles.SetSpeedPopup,'Value')};
    
    Params.Mode = cellstr(get(handles.SetModePopup,'String'));
    Params.Mode = Params.Mode{get(handles.SetModePopup,'Value')};
    
    Params.Frame = cellstr(get(handles.SetFramePopup,'String'));
    Params.Frame = Params.Frame{get(handles.SetFramePopup,'Value')};

    % Struct to store the pose input from the user
    global TargetPose                     
    TargetPose.PoseXZY = [];
    TargetPose.PoseJoints = [];

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
    
    % Global variable to store the Jog State.
    global Jog
    Jog = [];
    
    % Global variable to store the increment value.
    % Sets the default value to the first string shown in the popup menu.
    global Increment
    Increment = cellstr(get(handles.IncrementPopup,'String'));
    Increment = Increment{get(handles.IncrementPopup,'Value')};
    
    % Global variable to store the state of program control.
    % Allows the sytem to resume, pause, cancel programs.
    global ProgControl
    ProgControl = [];
    
    global RelPosition
    RelPosition = [];
    
    % Fnd all availble camera inputs
    adaptor = imaqhwinfo;
    adaptor = adaptor.InstalledAdaptors;
    adaptor = adaptor{1};
    
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
        
        start(Cameras.TableCam.Obj);
    catch
    end
    
    try
        % Try to access the second adaptor, this will belong to the
        % conveyor camera. Configure a trigger, return images in RGB and 
        % start recieving data from the camera.
        Cameras.ConvCam.Obj = videoinput(adaptor,2);
        triggerconfig(Cameras.ConvCam.Obj, 'manual');
        set(Cameras.ConvCam.Obj,'ReturnedColorSpace','RGB');

        start(Cameras.ConvCam.Obj);
    catch
    end
        
    % Create a timer which will fire the Send And Recieve Function. 
    global CommTimer
    CommTimer = timer('TimerFcn',@SendAndRecieve,'StartDelay',1,'Period',0.1,'ExecutionMode','fixedSpacing');
end

% --- Outputs from this function are returned to the command line.
function varargout = Ass2_GUI_OutputFcn(hObject, eventdata, handles) 
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
    global CommSocket
    global CommTimer
    global TableCam
    global ConvCam
    
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
        set(handles.EndEffectorPanel,'Visible','On');
        set(handles.CompliancePanel,'Visible','Off');
        set(handles.MainControlPanel,'Visible','On');
    
       % Check the connection and ensure tcp socket has the correct IP and
       % Port
        CommSocket.connectionCheck(handles);
        start(CommTimer);
        
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
    CommandQueue = [CommandQueue,"Control"];
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
    CommandQueue = [CommandQueue,"Control"];
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
    CommandQueue = [CommandQueue,"Control"];
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
    global IO
    global CommandQueue
    global TargetPose
    global Params
      
    IO.VacSol = 0;
    IO.VacPump = 0;
    IO.ConvRun = 0;
    Params.Speed = "V200";
    X = get(handles.EEX,'String');
    Y = get(handles.EEY,'String');
    TargetPose.PoseXYZ = [str2double(X),str2double(Y),200];
    TargetPose.PoseJoints = [0,0,0,0,0,0];
    
    CommandQueue = [CommandQueue,"SetSpeed"];
    CommandQueue = [CommandQueue,"ConvRun"];
    CommandQueue = [CommandQueue,"VacSol"];
    CommandQueue = [CommandQueue,"VacPump"]; 
    CommandQueue = [CommandQueue,"SetTargetXYZ"];
    CommandQueue = [CommandQueue,"SetTargetJoints"];
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
    global TargetPose
    global CommandQueue
    
    axes(Handles.axes1);
    
    robotCentre = [799, 1178];
    convertX = 0.659062103929024;
    convertY = 0.654895104895105;

    load('cameraParamsTable.mat');
    
    [inx,iny] = ginput(1);
    UndistortedPoints = undistortPoints([inx,iny], cameraParameters);
    xCamera = UndistortedPoints(1);
    yCamera = 1200-UndistortedPoints(2);
    
    worldXPoint = (-yCamera + robotCentre(2)) * convertY;
    worldYPoint = (xCamera-robotCentre(1)) * convertX;
    worldZPoint = 30;
    
    TargetPose.PoseXYZ = [worldXPoint,worldYPoint,worldZPoint];
    CommandQueue = [CommandQueue,"SetTargetXYZ"];
end

% --- Executes on button press in ConvRunBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Conveyor Run button is pressed. 
% --- This will toggle the state of the DIO to either turn on or off. Will
% --- add command to queue to be sent to RAPID.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function ConvRunBtn_Callback(hObject, eventdata, handles)
    global IO
    global CommandQueue
    
    % Toggle State of the Conveyor Run Functionality
    IO.ConvRun = get(hObject,'Value');
    
    % Add to command queue
    CommandQueue = [CommandQueue,"ConvRun"];
end

% --- Executes on button press in VacSolBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Vacuum Solenoid button is 
% --- pressed. This will toggle the state of the DIO to either turn on or 
% --- off. Will add command to queue to be sent to RAPID.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function VacSolBtn_Callback(hObject, eventdata, handles)
    global IO
    global CommandQueue
    
    % Toggle State of the vacuum solenoid
    IO.VacSol = get(hObject,'Value');
    
    % Add to command queue
    CommandQueue = [CommandQueue,"VacSol"];  
end

% --- Executes on button press in ConvDirBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Conveyor Directionbutton is 
% --- pressed. This will toggle the state of the DIO to change the direction
% --- of the conveyor from towards the robot or away from the robot.
% --- Command will then be added command queue to be sent to RAPID.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function ConvDirBtn_Callback(hObject, eventdata, handles)
    global IO
    global CommandQueue
    
    % Toggle State of the conveyor direction to toggle direction.
    IO.ConvDir = get(hObject,'Value');
    
    % Add to command queue
    CommandQueue = [CommandQueue,"ConvDir"];
end

% --- Executes on button press in VacPumpBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the VACUUM PUMP button is 
% --- pressed. This will toggle the state of the DIO to change the state of
% --- the DIO. Command will then be added command queue to be sent to 
% --- RAPID.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function VacPumpBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to VacPumpBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global IO
    global CommandQueue
    
    % Toggle State
    IO.VacPump = get(handles.VacPumpBtn,'Value');
    
    % Add to command queue
    CommandQueue = [CommandQueue,"VacPump"];    
end

% --- Executes on button press in JogXPlusBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the X+ button is 
% --- pressed. This is a toggle state button to ensure smooth movements. It
% --- will add a command to tell RAPID to start a jog loop. When the button
% --- state is off, it sends a command to RAPID to quit the jog loop, to
% --- stop jogging.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function JogXPlusBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global Jog
    
    % Obtain the toggle state of the button. 
    % Send the command to jog when it is pressed (state 1);
    % Set background colors to visually see the state.
    
    if (get(hObject,'Value')==1)
        Jog = [1,0,0,0,0,0];
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        Jog = [-1,0,0,0,0,0];
        set(hObject,'BackgroundColor',[0.86 0.12 0.12]);
    end
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"Jog"];
end

% --- Executes on button press in JogXMinusBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the X- button is 
% --- pressed. This is a toggle state button to ensure smooth movements. It
% --- will add a command to tell RAPID to start a jog loop. When the button
% --- state is off, it sends a command to RAPID to quit the jog loop, to
% --- stop jogging.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function JogXMinusBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global Jog
    
    % Obtain the toggle state of the button. 
    % Send the command to jog when it is pressed (state 1);
    % Set background colors to visually see the state.
    if (get(hObject,'Value')==1)
        Jog = [0,1,0,0,0,0];
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        Jog = [0,-1,0,0,0,0];
        set(hObject,'BackgroundColor',[0.86 0.12 0.12]);
    end
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"Jog"];
end

% --- Executes on button press in JogYPlusBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Y+ button is 
% --- pressed. This is a toggle state button to ensure smooth movements. It
% --- will add a command to tell RAPID to start a jog loop. When the button
% --- state is off, it sends a command to RAPID to quit the jog loop, to
% --- stop jogging.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function JogYPlusBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global Jog

    % Obtain the toggle state of the button. 
    % Send the command to jog when it is pressed (state 1);
    % Set background colors to visually see the state.
    if (get(hObject,'Value')==1)
        Jog = [0,0,1,0,0,0];
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        Jog = [0,0,-1,0,0,0];
        set(hObject,'BackgroundColor',[0.86 0.12 0.12]);
    end
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"Jog"];
end

% --- Executes on button press in JogYMinusBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Y- button is 
% --- pressed. This is a toggle state button to ensure smooth movements. It
% --- will add a command to tell RAPID to start a jog loop. When the button
% --- state is off, it sends a command to RAPID to quit the jog loop, to
% --- stop jogging.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function JogYMinusBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global Jog
    
    % Obtain the toggle state of the button. 
    % Send the command to jog when it is pressed (state 1);
    % Set background colors to visually see the state.
    if (get(hObject,'Value')==1)
        Jog = [0,0,0,1,0,0];
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        Jog = [0,0,0,-1,0,0];
        set(hObject,'BackgroundColor',[0.86 0.12 0.12]);
    end
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"Jog"];
end


% --- Executes on button press in JogZPlusBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Z+ button is 
% --- pressed. This is a toggle state button to ensure smooth movements. It
% --- will add a command to tell RAPID to start a jog loop. When the button
% --- state is off, it sends a command to RAPID to quit the jog loop, to
% --- stop jogging.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function JogZPlusBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global Jog

    % Obtain the toggle state of the button. 
    % Send the command to jog when it is pressed (state 1);
    % Set background colors to visually see the state.
    if (get(hObject,'Value')==1)
        Jog = [0,0,0,0,1,0];
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        Jog = [0,0,0,0,-1,0];
        set(hObject,'BackgroundColor',[0.86 0.12 0.12]);
    end
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"Jog"];
end

% --- Executes on button press in JogZMinusBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Z- button is 
% --- pressed. This is a toggle state button to ensure smooth movements. It
% --- will add a command to tell RAPID to start a jog loop. When the button
% --- state is off, it sends a command to RAPID to quit the jog loop, to
% --- stop jogging.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function JogZMinusBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    global Jog
     
    % Obtain the toggle state of the button. 
    % Send the command to jog when it is pressed (state 1);
    % Set background colors to visually see the state.
    if (get(hObject,'Value')==1)
        Jog = [0,0,0,0,0,1];
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        Jog = [0,0,0,0,0,-1];
        set(hObject,'BackgroundColor',[0.86 0.12 0.12]);
    end
    
    % Add the command to the command queue.
    CommandQueue = [CommandQueue,"Jog"];
end


% --- Executes on button press in Move2PoseXYZBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Move XYZ button is 
% --- pressed. This is a push button which takes the value entered into the
% --- edit text boxes and sets the global variable TargetPose.PoseXYZ to
% --- the input values. Then adds a command to the command queue to send 
% --- the desired target pose values to RAPID to control the robot.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function Move2PoseXYZBtn_Callback(hObject, eventdata, handles)
    global TargetPose
    global CommandQueue
    
    % Obtain the user input values from the edit text boxes related to 
    % X Y Z values.
    X = str2double(get(handles.PoseX,'String'));
    Y = str2double(get(handles.PoseY,'String'));
    Z = str2double(get(handles.PoseZ,'String'));
    
    % Set the global variable.
    TargetPose.PoseXYZ = [X,Y,Z];
    
    % Add command to command queue.
    CommandQueue = [CommandQueue,"SetTargetXYZ"];
end

% --- Executes on button press in Move2PoseJointsBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the Move Joints button is 
% --- pressed. This is a push button which takes the value entered into the
% --- edit text boxes and sets the global variable TargetPose.PoseJoints to
% --- the input values. Then adds a command to the command queue to send 
% --- the desired target pose values to RAPID to control the robot.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function Move2PoseJointsBtn_Callback(hObject, eventdata, handles)
    global TargetPose
    global CommandQueue
    
    % Obtain the user input values from the edit text boxes related to 
    % Q1, Q2, Q3, Q4, Q5, Q6 values.
    Q1 = str2double(get(handles.PoseQ1,'String'));
    Q2 = str2double(get(handles.PoseQ2,'String'));
    Q3 = str2double(get(handles.PoseQ3,'String'));
    Q4 = str2double(get(handles.PoseQ4,'String'));
    Q5 = str2double(get(handles.PoseQ5,'String'));
    Q6 = str2double(get(handles.PoseQ6,'String'));
    
    % Set the global variable.
    TargetPose.PoseJoints = [Q1,Q2,Q3,Q4,Q5,Q6];
    
    % Add command to command queue.
    CommandQueue = [CommandQueue,"SetTargetJoints"];
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
    
    % Open a dialogue box showing the current IP address and port number.
    % This gives the user the option to double check IP and port or change
    % if necessary. 
    question = {'Enter IP Address:','Enter Port Number:'};
    title = 'Server Connection';
    dims = [1 35];
    definput = {CommSocket.IP,num2str(CommSocket.PORT)};
    input = inputdlg(question,title,dims,definput);
    
    ip = input{1};
    port = str2num(input{2});
    
    % Call function to set/maintain IP and port.
    CommSocket.manualConnect(ip,port);
    
    % Check the connection to the server with new/existing IP and
    % portnumber.
    CommSocket.connectionCheck(handles);
end

% --- Executes on selection change in SetSpeedPopup.
% -------------------------------------------------------------------------
% --- This function will be called when the speed setting is selected. Then
% --- assigns the value to the global variable to be used.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetSpeedPopup_Callback(hObject, eventdata, handles)
    global Params
    
    % Obtain the current selected value of the speed and set the global
    % variable to this speed setting.
    speed = cellstr(get(hObject,'String'));
    Params.Speed = speed{get(hObject,'Value')};
    
end

% --- Executes on selection change in SetModePopup.
% -------------------------------------------------------------------------
% --- This function will be called when the motion mode setting is selected. 
% --- Then assigns the value to the global variable to be used.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetModePopup_Callback(hObject, eventdata, handles)
    global Params
    
    % Obtain the current selected value of the motion mode and set the global
    % variable to this motion mode setting.
    mode = cellstr(get(hObject,'String'));
    Params.Mode = mode{get(hObject,'Value')};
end

% --- Executes on selection change in SetFramePopup.
% -------------------------------------------------------------------------
% --- This function will be called when the frame setting is selected. Then
% --- assigns the value to the global variable to be used.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetFramePopup_Callback(hObject, eventdata, handles)
    global Params
    
    % Obtain the current selected value of the frame and set the global
    % variable to this frame setting.
    frame = cellstr(get(hObject,'String'));
    Params.Frame = frame{get(hObject,'Value')};
end

% --- Executes on selection change in IncrementPopup.
% -------------------------------------------------------------------------
% --- This function will be called when the increment setting is selected. 
% --- Then assigns the value to the global variable to be used.
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function IncrementPopup_Callback(hObject, eventdata, handles)  
    global Increment
    Increment = cellstr(get(hObject,'String'));
    Increment = Increment{get(hObject,'Value')};
end

% --- Executes on button press in SetRelPosBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the RELATIVE TO button is pressed. 
% --- Then adds commands to set the RELATIVE location to the command queue 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetRelPosBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    
    CommandQueue = [CommandQueue,"SetRelPos"];
end

% --- Executes on button press in SetFrameBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the FRAME button is pressed. 
% --- Then adds commands to set the FRAME to the command queue 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetFrameBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    
    CommandQueue = [CommandQueue,"SetFrame"];
end

% --- Executes on button press in SetModeBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the MODE button is pressed. 
% --- Then adds commands to set the MODE to the command queue 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetModeBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    
    CommandQueue = [CommandQueue,"SetMode"];
end

% --- Executes on button press in SetIncrementBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the INCREMENT button is pressed. 
% --- Then adds commands to set the INCREMENT to the command queue 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetIncrementBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    
    CommandQueue = [CommandQueue,"SetIncrement"];
end

% --- Executes on button press in SetSpeedBtn.
% -------------------------------------------------------------------------
% --- This function will be called when the SPEED button is pressed. 
% --- Then adds commands to set the SPEED to the command queue 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetSpeedBtn_Callback(hObject, eventdata, handles)
    global CommandQueue
    
    CommandQueue = [CommandQueue,"SetSpeed"];
end

% --- Executes on selection change in SetRelPosPopup.
% -------------------------------------------------------------------------
% --- This function will be called when the RELATIVE position is selected. 
% --- It will store the RELATIVE TO position in the global variable. 
% --- Written by: Angat Vora (z3422540)
% -------------------------------------------------------------------------
function SetRelPosPopup_Callback(hObject, eventdata, handles)
    global RelPosition
    
    RelPosition = get(hObject,'String');
    RelPosition = RelPosition{get(hObject,'Value')};
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

function PoseMoveXText_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseMoveXText_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseMoveYText_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseMoveYText_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseMoveZText_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseMoveZText_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseMoveQ1Text_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ1Text_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseMoveQ2Text_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ2Text_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseMoveQ3Text_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ3Text_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseMoveQ4Text_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ4Text_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

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

function PoseQ5_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseQ5_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseQ6_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseQ6_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes during object creation, after setting all properties.
function SetSpeedPopup_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
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

function JogXPlusBtn_ButtonDownFcn(hObject, eventdata, handles)
     %raises error if not there
end

% --- Executes during object creation, after setting all properties.
function SetModePopup_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function SWPaccept_CreateFcn(hObject, eventdata, handles)
% MATLAB raising error if not present.
end

function ConvStatusBtn_CreateFcn(hObject, eventdata, handles)
% MATLAB raises error if not present
end
% --- Executes on button press in ConvStatusBtn.
function ConvStatusBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to ConvStatusBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes during object creation, after setting all properties.
function SetFramePopup_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseX_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseX_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseY_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseY_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseZ_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseZ_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseQ1_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseQ1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseQ2_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseQ2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseQ3_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseQ3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function PoseQ4_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function PoseQ4_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes during object creation, after setting all properties.
function IncrementPopup_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function SetRelPosPopup_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
