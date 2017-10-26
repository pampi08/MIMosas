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

% Last Modified by GUIDE v2.5 26-Oct-2017 18:04:09

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
if IMGpath==0
    msgbox('n�o sei o que ler :-(');
    return
end
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

set(handles.showContr, 'String', int8(cte*100));  %converte o valor do slider em percentagem    
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Contrast_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function brightness_Callback(hObject, eventdata, handles)

my_adjust(hObject, eventdata,handles);
cte = (get(handles.brightness, 'Value'));
set(handles.showBright, 'String', int8(cte*100));

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
set(handles.showGamma, 'String', double(cte));

guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function Gamma_CreateFcn(hObject, eventdata, handles)

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

handles.img2save = img2; %Ap�s o ajuste, criamos uma nova imagem para que possa ser guardada
axes(handles.axes4);
imshow(img2);
axes(handles.axes2);
h=imhist(img2);
axes(handles.axes2);
plot(h/max(h), 'm', 'LineWidth', 1.3);  %dividimos pelo m�ximo do histograma para normalizar
hold on
hc=cumsum(h);
plot(hc/max(hc), 'g', 'LineWidth', 2);
hold off

guidata(hObject,handles);

function setConditions(hObject, eventdata, handles)
set(handles.Gamma, 'Enable', 'on', 'Value', 1);
set(handles.Contrast, 'Enable', 'on', 'Value',0);
set(handles.brightness, 'Enable', 'on', 'Value', 0);
set(handles.undoB, 'Enable', 'on');
set(handles.popupFilter, 'Enable', 'on');
set(handles.pushbuttonApply, 'Enable', 'on');
set(handles.SaveImg, 'Enable', 'on');

set(handles.showGamma, 'String', 1);
set(handles.showContr, 'String', 0);
set(handles.showBright, 'String', 0);

%condi��es iniciais dos filtros
set(handles.editSize,'Enable', 'off');
set(handles.editP1,'Enable', 'off');
set(handles.editP2,'Enable', 'off');


function errorSizeMatrix(hObject, eventdata, handles)
if(handles.size < 1)
    uiwait(msgbox('The size of the filter must be bigger than 0','Aviso','warn','modal'));
    set(handles.editSize, 'Value', 3);
end



% --- Executes on button press in undoB.
function undoB_Callback(hObject, eventdata, handles)

lastImg = handles.lastImg;  %vamos buscar a �ltima imagem salva para fazer undo
handles.img = lastImg;
axes(handles.axes4);
imshow(lastImg);
setConditions(hObject, eventdata, handles);
my_adjust(hObject, eventdata, handles);
guidata(hObject,handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over undoB.


% --- Executes on selection change in popupFilter.
function popupFilter_Callback(hObject, eventdata, handles)
handles.filterValue = get(hObject, 'Value');
set(handles.editSize,'Enable', 'on'); 
set(handles.editP1, 'Enable', 'off');
set(handles.editP2, 'Enable', 'off');
%defenimos inicialmente quais as caixas que queremos edit�veis
switch(handles.filterValue)
    case 2 %media
        set(handles.editSize, 'Value', 3, 'String', '3'); %permite ao utilizador preencher o campo que diz respeito ao tamanho do filtro
        handles.size = get(handles.editSize, 'Value');
        errorSizeMatrix(hObject, eventdata, handles);
        
    case 3 %gaussiano
        set(handles.editSize, 'Value', 3, 'String', '3');          
        handles.size = get(handles.editSize, 'Value');
        
        set(handles.editP1,'Enable', 'on', 'Value', 0.5, 'String', '0.5'); %sigma
        handles.P1 = get(handles.editP1, 'Value');
        
    case 4 %sobel vertical
        set(handles.editSize,'Enable', 'off'); 
                
    case 5 %sobel horizontal
        set(handles.editSize,'Enable', 'off'); 
        
    case 6 %sobel vertical e horizontal
        set(handles.editSize,'Enable', 'off'); 
        
    case 7 %laplaciano
        set(handles.editSize, 'Value', 3, 'String', '3');
        set(handles.editP1, 'Enable', 'on', 'Value', 0.2, 'String', '0.2');
        handles.P1 = get(handles.editP1, 'Value'); %P1 (alfa) TEM QUE ESTAR ENTRE 0 E 1 NESTE FILTRO
        handles.size = get(handles.editSize, 'Value'); 
    case 8 %mediana
        set(handles.editSize, 'Value', 3, 'String', '3');
        handles.size = get(handles.editSize, 'Value'); 
    case 9 %logaritmico    
        set(handles.editSize, 'Value', 5, 'String', '5');
        set(handles.editP1, 'Enable', 'on', 'Value', 0.5, 'String', '0.5'); %sigma
        handles.P1 = get(handles.editP1, 'Value');
        handles.size = get(handles.editSize, 'Value'); 
    case 10 %disco
        set(handles.editSize, 'Value', 5, 'String', '5');
        handles.size = get(handles.editSize, 'Value'); 
    case 11  %motion  
        set(handles.editSize, 'Value', 9, 'String', '9');
        set(handles.editP1, 'Enable', 'on', 'Value', 0, 'String', '0'); %teta
        handles.P1 = get(handles.editP1, 'Value');
        handles.size = get(handles.editSize, 'Value'); 
    case 12 %unsharp
        set(handles.editSize,'Enable', 'off'); 
        set(handles.editP1, 'Enable', 'on', 'Value', 0.2, 'String', '0.2'); %teta
        handles.P1 = get(handles.editP1, 'Value'); %alfa tem que estar entre 0 e 1
    case 13 %prewitt   Horizontal+Vertical
        set(handles.editSize,'Enable', 'off'); 
end
%FAZER: mudar o nome das text box para o parametro de cada filtro conforme
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupFilter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSize_Callback(hObject, eventdata, handles)
handles.size = str2double(get(hObject, 'String'));

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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonApply.
function pushbuttonApply_Callback(hObject, eventdata, handles)
switch(handles.filterValue)

    case 2  %filtro de m�dia
        average = fspecial('average', handles.size); %cria a matriz de Karnell de dimens�o size definido no callback do popup
        handles.original = imfilter(handles.original, average); %aplica o filtro � imagem original
               
    case 3  %filtro gaussiano 
        gaussian = fspecial('gaussian', handles.size, handles.P1);
        handles.original = imfilter(handles.original, gaussian);
    
    case 4  %sobel vertical
        karnell = fspecial('sobel'); %cria a matriz de Karnell
        sobelV = transpose(karnell); %para aplicar o filtro sobel na vertical � necess�rio transpor a matriz
        handles.original = imfilter(handles.original, sobelV);
      
    case 5 %sobel horizontal
        sobelH = fspecial('sobel'); %cria a matriz de Karnell
        handles.original = imfilter(handles.original, sobelH);
        
    case 6 %sobel H+V   
        sobelH = fspecial('sobel'); %cria a matriz de Karnell
        sobelV = transpose(sobelH);
        handles.original = imfilter(handles.original, sobelV) + imfilter(handles.original, sobelH);
                
    case 7 %filtro laplaciano
        laplacian = fspecial('laplacian', handles.P1); %cria a matriz de Karnell e pede valor alfa q varia entre 0 a 1 (double)
        handles.original = imfilter(handles.original, laplacian);
        
    case 8 %mediana
        handles.original = medfilt2(handles.original);
        
    case 9 %log
        logaritmic = fspecial('log',handles.size, handles.P1); %cria a matriz de Karnell e pede valor alfa q varia entre 0 a 1 (double)
        handles.original = imfilter(handles.original, logaritmic);
        
    case 10 %disk
        disk = fspecial('disk', handles.size); %cria a matriz de Karnell e pede valor alfa q varia entre 0 a 1 (double)
        handles.original = imfilter(handles.original, disk);
        
    case 11 %motion
        motion = fspecial('motion', handles.size, handles.P1); %cria a matriz de Karnell e pede valor alfa q varia entre 0 a 1 (double)
        handles.original = imfilter(handles.original, motion);
        
    case 12 %unsharp
        unsharp = fspecial('unsharp', handles.P1); %cria a matriz de Karnell e pede valor alfa q varia entre 0 a 1 (double)
        handles.original = imfilter(handles.original, unsharp);
        
    case 13 %pewitt H+V
        prewittH = fspecial('prewitt'); %cria a matriz de Karnell
        prewittV = transpose(prewittH);
        handles.original = imfilter(handles.original, prewittV) + imfilter(handles.original, prewittH);
 end

guidata(hObject,handles);
my_adjust(hObject, eventdata,handles);
