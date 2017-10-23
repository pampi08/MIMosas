function varargout = photorology(varargin)
% PHOTOROLOGY MATLAB code for photorology.fig
%      PHOTOROLOGY, by itself, creates a new PHOTOROLOGY or raises the existing
%      singleton*.
%
%      H = PHOTOROLOGY returns the handle to a new PHOTOROLOGY or the handle to
%      the existing singleton*.
%
%      PHOTOROLOGY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTOROLOGY.M with the given input arguments.
%
%      PHOTOROLOGY('Property','Value',...) creates a new PHOTOROLOGY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before photorology_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to photorology_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help photorology

% Last Modified by GUIDE v2.5 22-Oct-2017 14:36:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @photorology_OpeningFcn, ...
                   'gui_OutputFcn',  @photorology_OutputFcn, ...
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


% --- Executes just before photorology is made visible.
function photorology_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set( handles.Gamma, 'Min', 0.3, 'Max', 3, 'Value', 1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes photorology wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = photorology_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in openIMG.
function openIMG_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uigetfile({'*.jpg'; '*.bmp'},'Select Image');
IMGdirectory = strcat(IMGpath,IMGname);
img = imread(IMGdirectory);

handles.lastImg = img;
handles.original = img;

axes(handles.axes5);
imshow(img)

handles.img = img;
setConditions(hObject, eventdata, handles)

guidata(hObject,handles);

my_adjust(hObject, eventdata, handles);


% --- Executes on button press in SaveImg.
function SaveImg_Callback(hObject, eventdata, handles)

[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.img2save,IMGdirectory);

%em vez do hObject (se nao tivermos) podemos usar gcbo


function Contrast_Callback(hObject, eventdata, handles)

my_adjust(hObject,eventdata,handles);
cte = get(handles.Contrast, 'Value');

set(handles.showContr, 'String', cte);      
guidata(hObject,handles);






% --- Executes during object creation, after setting all properties.
function Contrast_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function brightness_Callback(hObject, eventdata, handles)

my_adjust(hObject, eventdata,handles);
cte = get(handles.brightness, 'Value');
set(handles.showBright, 'String', cte);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function brightness_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Gamma_Callback(hObject, eventdata, handles)

my_adjust(hObject,eventdata,handles); %vai buscar o resto dos valores dos sliders
cte = get(handles.Gamma, 'Value');

set(handles.showGamma, 'String', cte);

guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function Gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function my_adjust(hObject, eventdata, handles)
img = handles.original;
sliderBright = get(handles.brightness, 'Value');
sliderContrast = get(handles.Contrast, 'Value')/2;
sliderGamma = get(handles.Gamma, 'Value');

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
axes(handles.axes4);
imshow(img2);
axes(handles.axes2);
h=imhist(img2);
axes(handles.axes2);
plot(h/max(h), 'm', 'LineWidth', 1.3);  %dividimos pelo máximo do histograma para normalizar
hold on
hc=cumsum(h);
plot(hc/max(hc), 'g', 'LineWidth', 2);
hold off

guidata(hObject,handles);

function setConditions(hObject, eventdata, handles)
set(handles.Gamma, 'Value', 1);
set(handles.Contrast, 'Value',0);
set(handles.brightness, 'Value', 0);

set(handles.showGamma, 'String', 1);
set(handles.showContr, 'String', 0);
set(handles.showBright, 'String', 0);


% --- Executes on button press in undoB.
function undoB_Callback(hObject, eventdata, handles)

lastImg = handles.lastImg;  %vamos buscar a última imagem salva para fazer undo
handles.img = lastImg;
axes(handles.axes4);
imshow(lastImg);

axes(handles.axes2);
imhist(lastImg);
%cumsum(imhist(lastImg)); %not working
setConditions(hObject, eventdata, handles);
guidata(hObject,handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over undoB.


% --- Executes on selection change in popupFilter.
function popupFilter_Callback(hObject, eventdata, handles)
%handles=guidata(hObject);

handles.filterValue = get(hObject, 'Value');
disp(handles.filterValue);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupFilter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSize_Callback(hObject, eventdata, handles)
handles.size = str2double(get(hObject, 'String'));
disp(handles.size);
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function editSize_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editP1_Callback(hObject, eventdata, handles)
handles.P1 = str2double(get(hObject, 'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function editP1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editP2_Callback(hObject, eventdata, handles)
handles.P2 = str2double(get(hObject, 'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function editP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonApply.
function pushbuttonApply_Callback(hObject, eventdata, handles)
switch(handles.filterValue)
    case 1  %nada

    case 2  %filtro de média não funciona
        average = fspecial('average'); %cria a matriz de Karnell
        filtered = imfilter(handles.original, average); %aplica o filtro à imagem original
        
        axes(handles.axes4); %manda para o axes da imagem processada
        imshow(filtered); %mostra a imagem
        
        guidata(hObject,handles);
       
    case 3  %filtro gaussiano não funciona
        gaussian = fspecial('gaussian'); %cria a matriz de Karnell
        filtered = imfilter(handles.original, gaussian);
        
        axes(handles.axes4);
        imshow(filtered);
        
        guidata(hObject,handles);   
        
    case 4  %sobel vertical
        karnell = fspecial('sobel'); %cria a matriz de Karnell
        sobelV = transpose(karnell); %para aplicar o filtro sobel na vertical é necessário transpor a matriz
        filtered = imfilter(handles.original, sobelV);
        
        axes(handles.axes4);
        imshow(filtered);
        
        guidata(hObject,handles);          
     
    case 5 %sobel horizontal
        sobelH = fspecial('sobel'); %cria a matriz de Karnell
        filtered = imfilter(handles.original, sobelH);
        
        axes(handles.axes4);
        imshow(filtered);
        
        guidata(hObject,handles);   
    
    case 6 %sobel vertical + horizontal <- isto não tem sentido
        
    case 7 %filtro laplaciano
        laplacian = fspecial('laplacian'); %cria a matriz de Karnell
        filtered = imfilter(handles.original, laplacian);
        
        axes(handles.axes4);
        imshow(filtered);
        
        guidata(hObject,handles);
end
