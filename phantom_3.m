function varargout = phantom_3(varargin)
% PHANTOM_3 MATLAB code for phantom_3.fig
%      PHANTOM_3, by itself, creates a new PHANTOM_3 or raises the existing
%      singleton*.
%
%      H = PHANTOM_3 returns the handle to a new PHANTOM_3 or the handle to
%      the existing singleton*.
%
%      PHANTOM_3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHANTOM_3.M with the given input arguments.
%
%      PHANTOM_3('Property','Value',...) creates a new PHANTOM_3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before phantom_3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to phantom_3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help phantom_3

% Last Modified by GUIDE v2.5 30-Nov-2017 12:27:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phantom_3_OpeningFcn, ...
                   'gui_OutputFcn',  @phantom_3_OutputFcn, ...
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


% --- Executes just before phantom_3 is made visible.
function phantom_3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to phantom_3 (see VARARGIN)

% Choose default command line output for phantom_3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes phantom_3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = phantom_3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in anatomyPopUp.
function anatomyPopUp_Callback(hObject, eventdata, handles)
handles.anatomicPart = get(hObject, 'Value');
initialConditions(hObject, handles);

switch(handles.anatomicPart) %com o ficheiro do joelho e MRI do matlab, visualizar em 3D se possível acrescentar mais
    case 1 %vazio
        
    case 2 %Joelho 2D
        [IMGname,IMGpath] = uigetfile({'*.tif'; '*.jpg'},'Select Image');
        IMGdirectory = strcat(IMGpath,IMGname);
        img = imread(IMGdirectory);
        
        axes(handles.axes1);
        imshow(img);
        
    case 3 %Cabeça 3D
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Lê os dados correspondentes a 27 slides de imagens de MRI com uma resolução
        %de 128*128. Esses dados ficam disponíveis na matriz D.
        load mri
        D=squeeze(D);
        %matriz convertida para o formato double
        colormap(map)
        %aplica um filtro passa baixo a todo o volume
        Ds = smooth3(D);
        %cria a superficie externa do volume
        hiso = patch(isosurface(Ds,5),...
           'FaceColor',[1,.75,.65],...
           'EdgeColor','none');
           isonormals(Ds,hiso)
        %define a imagem superior e inferior do volume
        hcap = patch(isocaps(D,5),...
           'FaceColor','interp',...
           'EdgeColor','none');
        %define o ângulo de visualização do volume
        view(35,30) 
        axis tight 
        %define o fator de escala de cada um dos eixos para uma visualização mais
        %realista



        daspect([1,1,.4]);
        %define as condições de iluminação de forma a se ter uma perspetiva 3D do
        %volume
        lightangle(45,30);
        lighting gouraud
        hcap.AmbientStrength = 0.6;
        hiso.SpecularColorReflectance = 0;
        hiso.SpecularExponent = 50;
end

%%%%%%%%%%%%%%%%%%%%%%
%dúvida
axes(handles.axes1); %por que não precisa de imshow?

% --- Executes during object creation, after setting all properties.
function anatomyPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anatomyPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialConditions(hObject, handles)
set(handles.gamma,'Value', 1, 'Min', 0.3, 'Max', 3);
set(handles.contrast, 'Value', 0);
set(handles.brightness, 'Value', 0);

% --- Executes on slider movement.
function XSlider_Callback(hObject, eventdata, handles)
handles.XsliderValue = get(hObject, 'Value');
% hObject    handle to XSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function XSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function YSlider_Callback(hObject, eventdata, handles)
% hObject    handle to YSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function YSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ZSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ZSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ZSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function my_adjust(hObject, handles)
sliderBright = get(handles.brightness, 'Value');
sliderContrast = get(handles.contrast, 'Value')/2;
sliderGamma = get(handles.gamma, 'Value');

%AJUSTE BRILHO
if sliderBright>=0
   img2 = imadjust(img,[0;1-sliderBright],[sliderBright;1]); %para aummentar brilho
else
   img2 = imadjust(img,[-sliderBright;1],[0;1+sliderBright]);
end

%AJUSTE CONTRASTE
if sliderContrast>=0
   img2 = imadjust(img2,[sliderContrast;1-sliderContrast],[0;1]); %para aummentar contraste
else
   img2 = imadjust(img2,[0;1],[-sliderContrast;1+sliderContrast]);
end
%AJUSTE GAMMA
img2 = imadjust(img2,[],[],sliderGamma); 

handles.img2save = img2; %Após o ajuste, criamos uma nova imagem para que possa ser guardada

axes(handles.axes1);
imshow(img2);

guidata(hObject, handles);



% --- Executes on slider movement.
function brightness_Callback(hObject, eventdata, handles)
my_adjust(hObject, handles);


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function brightness_CreateFcn(hObject, eventdata, handles)

% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function contrast_Callback(hObject, eventdata, handles)
my_adjust(hObject, handles);


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function noise_Callback(hObject, eventdata, handles)
my_adjust(hObject, handles);


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
