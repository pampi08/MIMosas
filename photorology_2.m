function varargout = photorology_2(varargin)
% PHOTOROLOGY_2 MATLAB code for photorology_2.fig
%      PHOTOROLOGY_2, by itself, creates a new PHOTOROLOGY_2 or raises the existing
%      singleton*.
%
%      H = PHOTOROLOGY_2 returns the handle to a new PHOTOROLOGY_2 or the handle to
%      the existing singleton*.
%
%      PHOTOROLOGY_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTOROLOGY_2.M with the given input arguments.
%
%      PHOTOROLOGY_2('Property','Value',...) creates a new PHOTOROLOGY_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before photorology_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to photorology_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help photorology_2

% Last Modified by GUIDE v2.5 07-Nov-2017 21:44:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @photorology_2_OpeningFcn, ...
                   'gui_OutputFcn',  @photorology_2_OutputFcn, ...
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


% --- Executes just before photorology_2 is made visible.
function photorology_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to photorology_2 (see VARARGIN)

% Choose default command line output for photorology_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes photorology_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = photorology_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function phantomNResolution(handles)
handles.resolution = str2num(handles.resolution);

handles.phantom = phantom(handles.typePhantom, handles.resolution);

axes(handles.axes1);
imshow(handles.phantom);

guidata(hObject, handles);

function getAllOptionsPopUp(PopUpMenu,handles) %maneira de obter a op��o escolhida no popupmenu
allItems = get(handles.popUpMenu,'string');
selectedIndex = get(handles.popUpMenu,'Value');
selectedItem = allItems{selectedIndex};

guidata(hObject, handles);


% --- Executes on selection change in phantomPopUp.
function phantomPopUp_Callback(hObject, eventdata, handles)

%repeti��o de c�digo. A fun��o j� est� definida em cima � necess�rio
%implementar dentro dos popups GetAllOptionsPopUp
allItems = get(handles.phantomPopUp,'string');
selectedIndex = get(handles.phantomPopUp,'Value');
handles.typePhantom = allItems{selectedIndex};

allItems = get(handles.ResolutionPopUp,'string');
selectedIndex = get(handles.ResolutionPopUp,'Value');
handles.resolution = allItems{selectedIndex};


if(~strcmp(handles.resolution, 'Resolution') & ~strcmp(handles.typePhantom, 'Phantoms'))
    phantomNResolution(handles);
end

guidata(hObject, handles);


function phantomPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ResolutionPopUp.
function ResolutionPopUp_Callback(hObject, eventdata, handles)
allItems = get(handles.phantomPopUp,'string');
selectedIndex = get(handles.phantomPopUp,'Value');
handles.typePhantom = allItems{selectedIndex};

allItems = get(handles.ResolutionPopUp,'string');
selectedIndex = get(handles.ResolutionPopUp,'Value');
handles.resolution = allItems{selectedIndex};

if(~strcmp(handles.resolution, 'Resolution') & ~strcmp(handles.typePhantom, 'Phantoms'))
    phantomNResolution(handles);
end

guidata(hObject, handles);
        
function ResolutionPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function importFolder_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uigetfile('*.bmp','Select Image');
if IMGpath==0
    msgbox('n�o sei o que ler :-(');
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
img = imread(IMGdirectory);

axes(handles.axes2);
imshow(img);

% --- Executes on button press in importTest.
function importTest_Callback(hObject, eventdata, handles)
r = radon(handles.phantom, handles.projectionValue);
%precisa da lista de todas as projec�oes, � preciso identificar as
%projec�oes
%no segundo argumento primeiro damos o intervalo e depois o passo
axes(handles.axes2);
imshow(r);

guidata(hObject, handles);

% --- Executes on button press in saveImg.
function saveImg_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
if IMGpath==0
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.img2save,IMGdirectory);
% hObject    handle to saveImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveSeno.
function saveSeno_Callback(hObject, eventdata, handles)
% hObject    handle to saveSeno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in interpolPopUp.
function interpolPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to interpolPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns interpolPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from interpolPopUp


% --- Executes during object creation, after setting all properties.
function interpolPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interpolPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filterPopUp.
function filterPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to filterPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filterPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterPopUp


% --- Executes during object creation, after setting all properties.
function filterPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reconsImg.
function reconsImg_Callback(hObject, eventdata, handles)
% hObject    handle to reconsImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveRecons.
function saveRecons_Callback(hObject, eventdata, handles)
% hObject    handle to saveRecons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise as text
%        str2double(get(hObject,'String')) returns contents of noise as a double


% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function projections_Callback(hObject, eventdata, handles)
handles.projectionValue = get(hObject, 'Value');

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function projections_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openImg.
function openImg_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uigetfile({'*.jpg'; '*.bmp'},'Select Image');
if IMGpath==0
    msgbox('n�o sei o que ler :-(');
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
img = imread(IMGdirectory);

axes(handles.axes1);
imshow(img)
axes(handles.axes3);
imshow(img)


% --- Executes on button press in applyPhantom.
function applyPhantom_Callback(hObject, eventdata, handles)
% hObject    handle to applyPhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)