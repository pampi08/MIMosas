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

% Last Modified by GUIDE v2.5 19-Nov-2017 17:57:02

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
handles.output = hObject;
guidata(hObject, handles);


function varargout = photorology_2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function phantomNResolution(hObject, handles)
handles.resolution = str2num(handles.resolution); %convertemos o valor da resolução para número
phantomT = phantom(handles.typePhantom, handles.resolution); %criamos o fantoma
handles=guidata(hObject);
handles.phantomTest=phantomT; %guardamos numa variável da estrutura handles
%foi necessário criar  avariável handles e a local visto que sem a local
%não estava a funcionar
%NAO FUNCIONA NA MESMA!! handles.phantomTest NAO PASSA DAQUI NAO SEI PQ
save=imread('savesave', 'jpg');
set(handles.saveImg, 'Enable', 'on', 'cdata', save);
set(handles.projections, 'Enable', 'on', 'String', '180');
set(handles.importTest, 'Enable', 'on');
handles.projectionValue = 180;
%HANDLES.PROJECTIONVALUE NAO PASSA DAQUI
set(handles.addNoise, 'Enable', 'on', 'Min', 0, 'Max', 100, 'Value', 0);
guidata(hObject, handles);
axes(handles.axes1);
imshow(phantomT, 'InitialMagnification','fit');


% --- Executes on selection change in phantomPopUp.
function phantomPopUp_Callback(hObject, eventdata, handles)
allItems = get(handles.phantomPopUp,'string');
selectedIndex = get(handles.phantomPopUp,'Value');
handles.typePhantom = allItems{selectedIndex};

allItems = get(handles.ResolutionPopUp,'string');
selectedIndex = get(handles.ResolutionPopUp,'Value');
handles.resolution = allItems{selectedIndex};


if(~strcmp(handles.resolution, ' --- Resolution ---') && ~strcmp(handles.typePhantom, ' --- Phantoms ---'))
    phantomNResolution(hObject, handles);
    handles=guidata(hObject);
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

if(~strcmp(handles.resolution, ' --- Resolution ---') && ~strcmp(handles.typePhantom, ' --- Phantoms ---'))
    phantomNResolution(hObject, handles);
    handles=guidata(hObject);
end
guidata(hObject, handles);
        
function ResolutionPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setSenoConditions(hObject, handles)
save=imread('savesave', 'jpg');
set(handles.saveSeno, 'Enable', 'on', 'cdata', save);
set(handles.interpolPopUp, 'Enable', 'on');
set(handles.filterPopUp, 'Enable', 'on');
set(handles.addNoise, 'Enable', 'on', 'Min', 0, 'Max', 100, 'Value', 0);
handles.noiseValue = 0;
set(handles.currentNoise, 'String', '0%'); 
handles.typeInterpol = ' --- Interpolation Type ---';
handles.typeFilter = ' --- Filter ---';
guidata(hObject, handles);

function importFolder_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uigetfile({'*.seno';'*.bmp'},'Select Image');
if IMGpath==0
    uiwait(msgbox('Dont know what to read :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
img = imread(IMGdirectory);
handles.seno=img;
setSenoConditions(hObject, handles);
handles = guidata(hObject);
% save=imread('savesave', 'jpg');
% set(handles.saveSeno, 'Enable', 'on', 'cdata', save);
% set(handles.interpolPopUp, 'Enable', 'on');
% set(handles.filterPopUp, 'Enable', 'on');
% set(handles.addNoise, 'Enable', 'on', 'Min', 0, 'Max', 100, 'Value', 0);
% handles.noiseValue = 0;
% handles.typeInterpol = ' --- Interpolation Type ---';
% handles.typeFilter = ' --- Filter ---';
handles.degreePasse=1;
guidata(hObject, handles);
noiseSeno(hObject, handles);

% --- Executes on button press in importTest.
function importTest_Callback(hObject, eventdata, handles)
handles.degreePasse = 180/handles.projectionValue; %calcular a distância em graus entre projeçoes
[degree, tr] = radon(handles.phantomTest, 0:handles.degreePasse:179);
handles.seno=[degree, tr];
%precisa da lista de todas as projecçoes, é preciso identificar as
%projecçoes
%no segundo argumento primeiro damos o intervalo e depois o passo
setSenoConditions(hObject, handles);
handles = guidata(hObject);
% save=imread('savesave', 'jpg');
% set(handles.saveSeno, 'Enable', 'on', 'cdata', save);
% set(handles.interpolPopUp, 'Enable', 'on');
% set(handles.filterPopUp, 'Enable', 'on');
% set(handles.addNoise, 'Enable', 'on', 'Min', 0, 'Max', 100, 'Value', 0);
% handles.noiseValue = 0;
% handles.typeInterpol = ' --- Interpolation Type ---';
% handles.typeFilter = ' --- Filter ---';
guidata(hObject, handles);
noiseSeno(hObject, handles)


% --- Executes on button press in saveImg.
function saveImg_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
if IMGpath==0
    uiwait(msgbox('Dont know what to save :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.phantomTest,IMGdirectory); %guardamos o fantoma A VARIÁVEL NAO FUNCIONA

% --- Executes on button press in saveSeno.
function saveSeno_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
if IMGpath==0
    uiwait(msgbox('Dont know what to save :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.seno,IMGdirectory);

% --- Executes on selection change in interpolPopUp.
function interpolPopUp_Callback(hObject, eventdata, handles)
allItems = get(hObject,'String');
selectedIndex = get(hObject,'Value');
handles.typeInterpol = allItems{selectedIndex};
if(~strcmp(handles.typeFilter, ' --- Filter ---') && ~strcmp(handles.typeInterpol, ' --- Interpolation Type ---'))
    set(handles.reconstructImg, 'Enable', 'on'); %condição para poder reconstruir a imagem
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function interpolPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in filterPopUp.
function filterPopUp_Callback(hObject, eventdata, handles)
allItems = get(hObject,'string');
selectedIndex = get(hObject,'Value');
handles.typeFilter = allItems{selectedIndex};
if(~strcmp(handles.typeFilter, ' --- Filter ---') && ~strcmp(handles.typeInterpol, ' --- Interpolation Type ---'))
    set(handles.reconstructImg, 'Enable', 'on'); %condição para poder reconstruir a imagem
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filterPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveRecons.
function saveRecons_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
if IMGpath==0
    uiwait(msgbox('Dont know what to save :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.reconstructed,IMGdirectory); %guardamos a imagem reconstruída


% --- Executes on button press in reconstructImg.
function reconstructImg_Callback(hObject, eventdata, handles)
handles.reconstructed = iradon(handles.seno, handles.degreePasse, handles.typeInterpol, handles.typeFilter); 
%iradon(R,THETA,INTERPOLATION,FILTER,FREQUENCY_SCALING,OUTPUT_SIZE)
%NONE NAO FUNCIONA
save=imread('savesave', 'jpg');
set(handles.saveRecons, 'Enable', 'on', 'cdata', save); %passamos a poder guardar a reconstrução
axes(handles.axes5)
imshow(handles.reconstructed, 'InitialMagnification','fit');
guidata(hObject, handles);


function projections_Callback(hObject, eventdata, handles)
handles.projectionValue = str2double(get(hObject, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function projections_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function addNoise_Callback(hObject, eventdata, handles)
handles.noiseValue = round(get(hObject, 'Value')); %vamos buscar o valor do slider
noise=num2str(handles.noiseValue); %convertemos em string para mostrar na text box
str = strcat(noise, '%'); %concatenar strings
set(handles.currentNoise, 'String', str); %definir string da textbox
noiseSeno(hObject, handles) %imprimir  imagem
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function addNoise_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function noiseSeno(hObject, handles)
img = im2double(handles.seno) + handles.noiseValue*rand(size(handles.seno))/100;
axes(handles.axes2)
imshow(img, 'InitialMagnification','fit')
