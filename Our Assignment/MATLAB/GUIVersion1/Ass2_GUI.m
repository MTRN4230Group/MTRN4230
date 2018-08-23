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

    % Last Modified by GUIDE v2.5 23-Aug-2018 03:56:16

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
        axes(handles.axes1);
        tablecam = videoinput(adaptor,1);
        hImage = image(zeros(500,1200,3),'Parent',handles.axes1);
        preview(tablecam,hImage);

        % This is in a try block as many of you will only have one camera
        % atm.
        try
            axes(handles.axes3);
            conveyorcam = videoinput(adaptor,2);
            hImage2 = image(zeros(500,1200,3),'Parent',handles.axes3);
            preview(conveyorcam,hImage2);
        end
    
        % Small test script to ensure command box is working properly
        makeStatement(handles)
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
