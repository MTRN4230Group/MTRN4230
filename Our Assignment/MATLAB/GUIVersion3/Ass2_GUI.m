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

    % Last Modified by GUIDE v2.5 26-Aug-2018 15:12:27

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
function Ass2_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Ass2_GUI (see VARARGIN)

    % Choose default command line output for Ass2_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes Ass2_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    clear global;
    % Create global variables for use
    global CommSocket;


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

% --- Executes on button press in SWPcb5.
function SWPcb5_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb5
end

% --- Executes on button press in SWPcb8.
function SWPcb8_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb8
end

% --- Executes on button press in SWPcb10.
function SWPcb10_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb10
end

% --- Executes on button press in SWPcb2.
function SWPcb2_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb2
end

% --- Executes on button press in SWPcb3.
function SWPcb3_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb3
end

% --- Executes on button press in SWPcb4.
function SWPcb4_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb4
end

% --- Executes on button press in SWPcb7.
function SWPcb7_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb7
end

% --- Executes on button press in SWPcb9.
function SWPcb9_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb9
end

% --- Executes on button press in SWPcb1.
function SWPcb1_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb1
end

% --- Executes on button press in SWPcb6.
function SWPcb6_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPcb6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of SWPcb6
end

% --- Executes on button press in SWPskip.
function SWPskip_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPskip (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    SWPValues = SWPGET(handles);
    SWPValues = ~SWPValues;
    SWPSET(SWPValues,handles);
end

function SWPaccept_CreateFcn(hObject, eventdata, handles)
% MATLAB raising error if not present.
end
% --- Executes on button press in SWPaccept.
function SWPaccept_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPaccept (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global CommSocket
    SWP = SWPGET(handles);
    zero = find(SWP ~= 1);
    if (isempty(zero))
        % Effectly changing 'screens'
        set(handles.ProgramControlPanel,'Visible','On');
        set(handles.EventRecorderPanel,'Visible','On');
        set(handles.JointAnglesPanel,'Visible','On');
        set(handles.EndEffectorPanel,'Visible','On');
        set(handles.CompliancePanel,'Visible','Off');
        set(handles.MainControlPanel,'Visible','On');

        % Start Camera feed
        % Presently will start device camera;
        % Attempt to automatically detect which system you have/ mac/windows;
        adaptor = imaqhwinfo;
        adaptor = adaptor.InstalledAdaptors;
        adaptor = adaptor{1};
        try
            axes(handles.axes1);
            tablecam = videoinput(adaptor,1);
            hImage = image(zeros(500,1200,3),'Parent',handles.axes1);
            preview(tablecam,hImage);
        end

        try
            axes(handles.axes3);
            conveyorcam = videoinput(adaptor,2);
            hImage2 = image(zeros(500,1200,3),'Parent',handles.axes3);
            preview(conveyorcam,hImage2);
        end
          
        % Small test script to ensure command box is working properly
%         makeStatement(handles)
        
        % Create the connection object and check the connection then
        % display stats on main gui
        CommSocket = tcpcomms;
        CommSocket.connectionCheck(handles);
    else
        msgbox('You must accept all checklist items');
    end
end

% --- Executes on button press in SWPdecline.
function SWPdecline_Callback(hObject, eventdata, handles)
    % hObject    handle to SWPdecline (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

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

function makeStatement(handles)

    global EventTX
    for itr = 1:12
        state = sprintf("hello: %d",itr);
        EventTX{length(EventTX)+1} = state;
%         set(handles.TXcommands,'Value',length(EventTX));
        pause(1);
        set(handles.TXcommands,'String',EventTX);
        set(handles.TXcommands,'ListboxTop',length(EventTX));
    end
end

% --- Executes on button press in StartProgram.
function StartProgram_Callback(hObject, eventdata, handles)
    % hObject    handle to StartProgram (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in StopProgram.
function StopProgram_Callback(hObject, eventdata, handles)
    % hObject    handle to StopProgram (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on selection change in TXcommands.
function TXcommands_Callback(hObject, eventdata, handles)
    % hObject    handle to TXcommands (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns TXcommands contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from TXcommands
end

% --- Executes during object creation, after setting all properties.
function TXcommands_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to TXcommands (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in RXcommands.
function RXcommands_Callback(hObject, eventdata, handles)
    % hObject    handle to RXcommands (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns RXcommands contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from RXcommands

end
% --- Executes during object creation, after setting all properties.
function RXcommands_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to RXcommands (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in PauseProgram.
function PauseProgram_Callback(hObject, eventdata, handles)
    % hObject    handle to PauseProgram (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in StopProgram.
function pushbutton21_Callback(hObject, eventdata, handles)
    % hObject    handle to StopProgram (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

function ConvEnableBtn_CreateFcn(hObject, eventdata, handles)
% MATLAB raises error if not present
end


% --- Executes on button press in ConvEnableBtn.
function ConvEnableBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to ConvEnableBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    toggleState = get(hObject,'Value');
    if (toggleState==1)
        %Enable Conveyor
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        set(hObject,'BackgroundColor',[0.78 0 0]);
    end
end

% --- Executes on button press in ConvRunBtn.
function ConvRunBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to ConvRunBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    toggleState = get(hObject,'Value');
    if (toggleState==1)
        % Start Conveyor
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        set(hObject,'BackgroundColor',[0.78 0 0]);
    end
end

% --- Executes on button press in VacSolBtn.
function VacSolBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to VacSolBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    toggleState = get(hObject,'Value');
    if (toggleState==1)
        %Enable Vacuum Solenoid
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        set(hObject,'BackgroundColor',[0.78 0 0]);
    end
end

% --- Executes on button press in ConvDirBtn.
function ConvDirBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to ConvDirBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    toggleState = get(hObject,'Value');
    if (toggleState==1)
        % Change Directions
        set(hObject,'String','ConvDir:  <<<');
    else
        set(hObject,'String','ConvDir:  >>>');
    end
end

% --- Executes on button press in VacPumpBtn.
function VacPumpBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to VacPumpBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    toggleState = get(hObject,'Value');
    if (toggleState==1)
        %Enable Vacuum Pump
        set(hObject,'BackgroundColor',[0.47 0.67 0.19]);
    else
        set(hObject,'BackgroundColor',[0.78 0 0]);
    end
end
function JogXPlusBtn_ButtonDownFcn(hObject, eventdata, handles)
     %raises error if not there
end
% --- Executes on button press in JogXPlusBtn.
function JogXPlusBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to JogXPlusBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)\
end

% --- Executes on button press in JogYPlusBtn.
function JogYPlusBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to JogYPlusBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in JogYMinusBtn.
function JogYMinusBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to JogYMinusBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in JogXMinusBtn.
function JogXMinusBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to JogXMinusBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in JogZPlusBtn.
function JogZPlusBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to JogZPlusBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in JogZMinusBtn.
function JogZMinusBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to JogZMinusBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in Move2PoseBtn.
function Move2PoseBtn_Callback(hObject, eventdata, handles)
    % hObject    handle to Move2PoseBtn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global CommSocket
    speed = getSpeedSetting(handles.PoseSpeedPopup);
    mode = getModeSetting(handles.PoseModePopup);
    CommSocket.setSpeed(speed)
    CommSocket.setMode(mode)
end

function speed = getSpeedSetting(fromhandle)
    speed = cellstr(get(fromhandle,'String'));
    speed = speed{get(fromhandle,'Value')};
end

function mode = getModeSetting(fromhandle)
    mode = cellstr(get(fromhandle,'String'));
    mode = mode{get(fromhandle,'Value')};
end

function PoseMoveXText_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseMoveXText (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: get(hObject,'String') returns contents of PoseMoveXText as text
    %        str2double(get(hObject,'String')) returns contents of PoseMoveXText as a double
end

% --- Executes during object creation, after setting all properties.
function PoseMoveXText_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseMoveXText (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function PoseMoveYText_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseMoveYText (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: get(hObject,'String') returns contents of PoseMoveYText as text
    %        str2double(get(hObject,'String')) returns contents of PoseMoveYText as a double
end

% --- Executes during object creation, after setting all properties.
function PoseMoveYText_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseMoveYText (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function PoseMoveZText_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseMoveZText (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: get(hObject,'String') returns contents of PoseMoveZText as text
    %        str2double(get(hObject,'String')) returns contents of PoseMoveZText as a double
end

% --- Executes during object creation, after setting all properties.
function PoseMoveZText_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseMoveZText (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function PoseMoveQ1Text_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ1Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: get(hObject,'String') returns contents of PoseMoveQ1Text as text
    %        str2double(get(hObject,'String')) returns contents of PoseMoveQ1Text as a double
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ1Text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ1Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function PoseMoveQ2Text_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ2Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: get(hObject,'String') returns contents of PoseMoveQ2Text as text
    %        str2double(get(hObject,'String')) returns contents of PoseMoveQ2Text as a double
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ2Text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ2Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function PoseMoveQ3Text_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ3Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: get(hObject,'String') returns contents of PoseMoveQ3Text as text
    %        str2double(get(hObject,'String')) returns contents of PoseMoveQ3Text as a double
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ3Text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ3Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function PoseMoveQ4Text_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ4Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: get(hObject,'String') returns contents of PoseMoveQ4Text as text
    %        str2double(get(hObject,'String')) returns contents of PoseMoveQ4Text as a double
end

% --- Executes during object creation, after setting all properties.
function PoseMoveQ4Text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseMoveQ4Text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in PoseModePopup.
function PoseModePopup_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseModePopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: contents = cellstr(get(hObject,'String')) returns PoseModePopup contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from PoseModePopup
    
    selectedOption = get(hObject,'Value');
    set(handles.JogModePopup,'Value',selectedOption');
end

% --- Executes during object creation, after setting all properties.
function PoseModePopup_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseModePopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in PoseSpeedPopup.
function PoseSpeedPopup_Callback(hObject, eventdata, handles)
    % hObject    handle to PoseSpeedPopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: contents = cellstr(get(hObject,'String')) returns PoseSpeedPopup contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from PoseSpeedPopup 
    
    selectedOption = get(hObject,'Value');
    set(handles.JogSpeedPopup,'Value',selectedOption');
end

% --- Executes during object creation, after setting all properties.
function PoseSpeedPopup_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to PoseSpeedPopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in JogSpeedPopup.
function JogSpeedPopup_Callback(hObject, eventdata, handles)
    % hObject    handle to JogSpeedPopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: contents = cellstr(get(hObject,'String')) returns JogSpeedPopup contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from JogSpeedPopup
    
    selectedOption = get(hObject,'Value');
    set(handles.PoseSpeedPopup,'Value',selectedOption');
end

% --- Executes during object creation, after setting all properties.
function JogSpeedPopup_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to JogSpeedPopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in JogModePopup.
function JogModePopup_Callback(hObject, eventdata, handles)
    % hObject    handle to JogModePopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: contents = cellstr(get(hObject,'String')) returns JogModePopup contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from JogModePopup
    
    selectedOption = get(hObject,'Value');
    set(handles.PoseModePopup,'Value',selectedOption');
end

% --- Executes during object creation, after setting all properties.
function JogModePopup_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to JogModePopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
