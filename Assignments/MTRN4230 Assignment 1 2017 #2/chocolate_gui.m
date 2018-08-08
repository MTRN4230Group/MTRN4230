% Chocolate labelling GUI for MTRN4230.
%
% Sam Marden 2014.
% Steven Zheng 2015.
% Julie Tang 2017.

function varargout = chocolate_gui(varargin)
% CHOCOLATE_GUI MATLAB code for chocolate_gui.fig
%      CHOCOLATE_GUI, by itself, creates a new CHOCOLATE_GUI or raises the existing
%      singleton*.
%
%      H = CHOCOLATE_GUI returns the handle to a new CHOCOLATE_GUI or the handle to
%      the existing singleton*.
%
%      CHOCOLATE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOCOLATE_GUI.M with the given input arguments.
%
%      CHOCOLATE_GUI('Property','Value',...) creates a new CHOCOLATE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chocolate_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chocolate_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chocolate_gui

% Last Modified by GUIDE v2.5 01-Aug-2017 15:54:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chocolate_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @chocolate_gui_OutputFcn, ...
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


% --- Executes just before chocolate_gui is made visible.
function chocolate_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chocolate_gui (see VARARGIN)

% Choose default command line output for chocolate_gui
handles.output = hObject;

handles = init_userdata(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chocolate_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = chocolate_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openbutton.
function openbutton_Callback(hObject, eventdata, handles)
% hObject    handle to openbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_path, file_name] = open_file_path;

if ~isempty(file_path)
    handles = init_userdata(handles);
    im = imread([file_path, file_name]);
    im = im(end:-1:1,:,:);
    handles.userdata.image = im;
    handles.userdata.image_handle = imshow(handles.userdata.image);
    handles.userdata.image_file_name = file_name;
    handles.userdata.image_file_path = [file_path, file_name];
end

handles = draw_rectangles(handles);

guidata(hObject, handles);


% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = init_userdata(handles);

[file_path, file_name] = open_file_path;

handles = load_rectangles(handles, file_path, file_name);
handles.userdata.image = handles.userdata.image(end:-1:1,:,:);
% handles.userdata.image = handles.userdata.image(:,end:-1:1,:);
handles.userdata.image_handle = imshow(handles.userdata.image);
    
handles = draw_rectangles(handles);

guidata(hObject, handles);


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save_rectangles(handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.userdata.mouse_down = true;

mouse_location = get(handles.imageaxes, 'CurrentPoint');
mouse_location = mouse_location(1, 1:2);
% if strcmp(handles.userdata.move_mode, 'zoom')
%     handles.userdata.zoom_start = mouse_location;
% else
%     handles.userdata.zoom_start = [];
% end

if isempty(handles.userdata.image) || ...
   mouse_out_of_bounds(handles, mouse_location)
    guidata(hObject, handles);
    return;
end

listbox_value = get_listbox_value(handles);

if strcmp(listbox_value, 'Add')
    handles = add_rectangle(handles, mouse_location);
elseif strcmp(listbox_value, 'Modify')
    handles = find_nearest_rectangle(handles, mouse_location);
elseif strcmp(listbox_value, 'Delete')
    handles = find_nearest_rectangle(handles, mouse_location);
    handles = delete_rectangle(handles);
end

handles = update_checkboxes(handles);

handles = draw_rectangles(handles);
handles.userdata.previous_mouse_location = mouse_location;
guidata(hObject, handles);


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

listbox_value = get_listbox_value(handles);
if strcmp(listbox_value, 'Modify')
    set(handles.zoombutton, 'Visible', 'on');
else
    set(handles.zoombutton, 'Visible', 'off');
end

mouse_location = get(handles.imageaxes, 'CurrentPoint');
mouse_location = mouse_location(1, 1:2);

if isempty(handles.userdata.image_handle) || ...
   ~handles.userdata.mouse_down || ...
   mouse_out_of_bounds(handles, mouse_location)
    guidata(hObject, handles);
    return;
end

handles = move_rectangle(handles, mouse_location);
handles = draw_rectangles(handles);
handles.userdata.previous_mouse_location = mouse_location;
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.userdata.mouse_down = false;

mouse_location = get(handles.imageaxes, 'CurrentPoint');
mouse_location = mouse_location(1, 1:2);

if isempty(handles.userdata.image_handle) || ...
   mouse_out_of_bounds(handles, mouse_location)
    guidata(hObject, handles);
    return;
end

handles.userdata.previous_mouse_location = mouse_location;
guidata(hObject, handles);


% --- Executes on selection change in actionlistbox.
function actionlistbox_Callback(hObject, eventdata, handles)
% hObject    handle to actionlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns actionlistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from actionlistbox

listbox_value = get_listbox_value(handles);
if strcmp(listbox_value, 'Modify')
    set(handles.zoombutton, 'Visible', 'on');
else
    set(handles.zoombutton, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function actionlistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to actionlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reachablecheckbox.
function reachablecheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to reachablecheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reachablecheckbox

if handles.userdata.rectangle_idx < 1
    return;
end

handles.userdata.rectangles(handles.userdata.rectangle_idx, ...
    handles.userdata.rectangle_reachable_idx) = get(hObject, 'Value');

handles = draw_rectangles(handles);

guidata(hObject, handles);


% --- Executes on selection change in showtextlistbox.
function showtextlistbox_Callback(hObject, eventdata, handles)
% hObject    handle to showtextlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns showtextlistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from showtextlistbox

listbox_contents = cellstr(get(hObject, 'String'));
listbox_value = listbox_contents{get(hObject, 'Value')};

if strcmp(listbox_value, 'On All')
    handles.userdata.show_text = 'all';
elseif strcmp(listbox_value, 'On Selected')
    handles.userdata.show_text = 'selected';
elseif strcmp(listbox_value, 'On None')
    handles.userdata.show_text = 'none';
end

handles = draw_rectangles(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function showtextlistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showtextlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key, 'shift')
    handles.userdata.shift = true;
end

guidata(hObject, handles);


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key, 'shift')
    handles.userdata.shift = false;
end

guidata(hObject, handles);


% --- Executes on button press in zoombutton.
function zoombutton_Callback(hObject, eventdata, handles)
% hObject    handle to zoombutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(handles.userdata.zoom, 'on')
    handles.userdata.zoom = 'off';
    set(handles.zoombutton, 'String', 'Enable Zoom');
else
    handles.userdata.zoom = 'on';
    set(handles.zoombutton, 'String', 'Disable Zoom');
end

guidata(hObject, handles);


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on selection change in shapelistbox.
function shapelistbox_Callback(hObject, eventdata, handles)
% hObject    handle to shapelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns shapelistbox contents as cell array
if handles.userdata.rectangle_idx < 1
    return;
end

listbox_index = get(handles.shapelistbox, 'Value');

handles.userdata.rectangles(handles.userdata.rectangle_idx, ...
    handles.userdata.rectangle_shape_idx) = listbox_index - 1;

handles = draw_rectangles(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function shapelistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shapelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in colourlistbox.
function colourlistbox_Callback(hObject, eventdata, handles)
% hObject    handle to colourlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colourlistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colourlistbox
if handles.userdata.rectangle_idx < 1
    return;
end

listbox_index = get(handles.colourlistbox, 'Value');

handles.userdata.rectangles(handles.userdata.rectangle_idx, ...
    handles.userdata.rectangle_colour_idx) = listbox_index - 1;

handles = draw_rectangles(handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function colourlistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colourlistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
