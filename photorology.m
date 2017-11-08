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

% Last Modified by GUIDE v2.5 02-Nov-2017 22:43:01

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
handles.colorOn = false;
guidata(hObject, handles);
open=imread('open', 'jpg');
set(handles.openIMG, 'cdata', open);



% UIWAIT makes photorology wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = photorology_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in openIMG.
function openIMG_Callback(hObject, eventdata, handles)
global i_undo;
[IMGname,IMGpath] = uigetfile({'*.jpg'; '*.bmp'},'Select Image');
if IMGpath==0
    msgbox('não sei o que ler :-(');
    return
end
setConditions(hObject, handles) %colocar a interface nas condiçoes iniciais
IMGdirectory = strcat(IMGpath,IMGname);
img = imread(IMGdirectory);
[M,N]=size(img); %saber o tamanho da imagem para saber as dimensoes da matriz
handles.storeImg = zeros(M,N,15); %criar o array onde guardaremos as imagens
i_undo = 1;%índice do storeArray onde guardaremos as imagens
handles.original = img;

axes(handles.axes5);
imshow(img)

guidata(hObject,handles);
my_adjust(hObject, handles);


% --- Executes on button press in SaveImg.
function SaveImg_Callback(hObject, eventdata, handles)
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
if IMGpath==0
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.img2save,IMGdirectory);

function Contrast_Callback(hObject, eventdata, handles)

my_adjust(hObject,handles);
cte = get(handles.Contrast, 'Value');

set(handles.showContr, 'String', int8(cte*100));  %converte o valor do slider em percentagem    
guidata(hObject,handles);

function Contrast_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function brightness_Callback(hObject, eventdata, handles)

my_adjust(hObject, handles);
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

my_adjust(hObject,handles); %vai buscar o resto dos valores dos sliders
cte = get(handles.Gamma, 'Value');
set(handles.showGamma, 'String', double(cte));

guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function Gamma_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function my_adjust(hObject, handles)
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

axes(handles.axes2);
h=imhist(img2);
axes(handles.axes2);
plot(h/max(h), 'm', 'LineWidth', 1.3);  %dividimos pelo máximo do histograma para normalizar
hold on
hc=cumsum(h);
plot(hc/max(hc), 'g', 'LineWidth', 2);
hold off
guidata(hObject,handles);
if handles.colorOn == true
    axes(handles.axes4);
    imshow(img2);
    colormap(handles.axes4, handles.fakecolor);
else
    axes(handles.axes4);
    imshow(img2);
end

function setConditions(hObject, handles)
%nesta função definimos todas as condições iniciais 
%é chamada cada vez que abrimos uma imagem nova

set(handles.Gamma, 'Enable', 'on', 'Value', 1, 'Min', 0.3, 'Max', 3);
set(handles.Contrast, 'Enable', 'on', 'Value',0);
set(handles.brightness, 'Enable', 'on', 'Value', 0);
set(handles.applyDefault, 'Enable', 'on');

arrowL=imresize(imread('arrowL', 'jpg'), [50 50]);
set(handles.undoB, 'Enable', 'on', 'cdata', arrowL);
save=imread('save', 'jpg');
set(handles.SaveImg, 'Enable', 'on', 'cdata', save);
set(handles.chooseFC, 'Enable', 'on', 'Value', 1);

set(handles.applyFilter, 'Enable', 'off');
set(handles.histEq, 'Enable', 'on');
set(handles.applyGray, 'Enable', 'on');
set(handles.applyBW, 'Enable', 'on');
set(handles.applyNeg, 'Enable', 'on');
set(handles.applyFC, 'Enable', 'off');

set(handles.f1, 'String', '');
set(handles.f2, 'String', '');
set(handles.f3, 'String', '');
set(handles.f4, 'String', '');
set(handles.f5, 'String', '');
set(handles.f6, 'String', '');
set(handles.f7, 'String', '');
set(handles.f8, 'String', '');
set(handles.f9, 'String', '');
set(handles.showGamma, 'String', 1);
set(handles.showContr, 'String', 0);
set(handles.showBright, 'String', 0);

%condições iniciais dos filtros
set(handles.popupFilter, 'Enable', 'on', 'Value', 1);
set(handles.editSize,'Enable', 'off', 'String', '');
set(handles.editP1,'Enable', 'off', 'String', '');
set(handles.editP2,'Enable', 'off', 'String', '');
set(handles.textSize, 'String', 'Size:');
set(handles.textP1, 'String', 'Param 1:');
set(handles.textP2, 'String', 'Param 2:');

function checkNumber(editString, hObject) %testa se os valores nas edit box do filtro são inteiros ou decimais
S = str2double(get(editString, 'String'));
if isnan(S)
     set(hObject,'String','1'); 
     uiwait(msgbox('The number must be integer or decimal.','Warning', 'warn', 'modal'));
end

function checkIntPositive(editString, hObject)
S = str2double(get(editString, 'String'));
if isnan(S) || S<=0
    set(hObject,'String','3'); 
    uiwait(msgbox('The number must be a positive integer.','Warning', 'warn', 'modal'));
end

function storeArray(hObject, handles)
global i_undo;
handles.storeImg(:,:,i_undo) = [handles.original];
i_undo = i_undo+1;
guidata(hObject, handles);

% --- Executes on button press in undoB.
function undoB_Callback(hObject, eventdata, handles)
global i_undo;
i_undo=i_undo-1;
handles.original = handles.storeImg(:,:,i_undo);
setConditions(hObject, handles);
guidata(hObject, handles);
my_adjust(hObject, handles);


% lastImg = handles.lastImg;  %vamos buscar a última imagem salva para fazer undo
% handles.original = lastImg;
% axes(handles.axes4);
% imshow(lastImg);
% setConditions(hObject, handles);
% guidata(hObject,handles);
% my_adjust(hObject, handles);

function popupFilter_Callback(hObject, eventdata, handles)
set(handles.applyFilter, 'Enable', 'on');
handles.filterValue = get(hObject, 'Value');
set(handles.editSize,'Enable', 'on', 'String', ''); 
set(handles.editP1, 'Enable', 'off', 'String', '');
set(handles.editP2, 'Enable', 'off', 'String', '');
set(handles.textSize, 'String', 'Size:');
set(handles.textP1, 'String', 'Param 1:');
set(handles.textP2, 'String', 'Param 2:');
set(handles.f1,'Enable', 'off', 'String', ''); 
set(handles.f2,'Enable', 'off', 'String', ''); 
set(handles.f3,'Enable', 'off', 'String', ''); 
set(handles.f4,'Enable', 'off', 'String', ''); 
set(handles.f5,'Enable', 'off', 'String', ''); 
set(handles.f6,'Enable', 'off', 'String', ''); 
set(handles.f7,'Enable', 'off', 'String', ''); 
set(handles.f8,'Enable', 'off', 'String', ''); 
set(handles.f9,'Enable', 'off', 'String', ''); 
%definimos inicialmente quais as caixas que queremos editáveis e como surge
%a sua string
switch(handles.filterValue)
    case 1
        set(handles.editSize, 'Enable', 'off');
        set(handles.applyFilter, 'Enable', 'off');
    case 2 %media
        set(handles.editSize, 'Value', 3, 'String', '3'); %permite ao utilizador preencher o campo que diz respeito ao tamanho do filtro
    case 3 %gaussiano
        set(handles.editSize, 'Value', 3, 'String', '3');          
        set(handles.editP1,'Enable', 'on', 'Value', 0.5, 'String', '0.5'); %sigma
        set(handles.textP1, 'String', 'Sigma:');
    case 4 %sobel vertical
        set(handles.editSize,'Enable', 'off'); 
    case 5 %sobel horizontal
        set(handles.editSize,'Enable', 'off'); 
    case 6 %sobel vertical e horizontal
        set(handles.editSize,'Enable', 'off'); 
    case 7 %laplaciano
        set(handles.editSize, 'Value', 3, 'String', '3');
        set(handles.editP1, 'Enable', 'on', 'Value', 0.2, 'String', '0.2');
        set(handles.textP1, 'String', 'Alpha:'); 
        %P1 (alfa) TEM QUE ESTAR ENTRE 0 E 1 NESTE FILTRO
    case 8 %mediana
        set(handles.editSize, 'Value', 3, 'String', '3'); 
    case 9 %logaritmico    
        set(handles.editSize, 'Value', 5, 'String', '5');
        set(handles.editP1, 'Enable', 'on', 'Value', 0.5, 'String', '0.5'); %sigma
        set(handles.textP1, 'String', 'Sigma:');
    case 10 %disco
        set(handles.editSize, 'Value', 5, 'String', '5');
        set(handles.textSize, 'String', 'Radius:');
    case 11  %motion  
        set(handles.editSize, 'Value', 9, 'String', '9');
        set(handles.editP1, 'Enable', 'on', 'Value', 0, 'String', '0'); %teta
        set(handles.textP1, 'String', 'Theta:');
    case 12 %unsharp
        set(handles.editSize,'Enable', 'off'); 
        set(handles.editP1, 'Enable', 'on', 'Value', 0.2, 'String', '0.2'); %alfa
        set(handles.textP1, 'String', 'Alpha:');
        %alfa tem que estar entre 0 e 1
    case 13 %prewitt   Horizontal+Vertical
        set(handles.editSize,'Enable', 'off'); 
    case 14 %Filtro manual: disponibilizamos as edit box e guardamos o seu valor no handles
        set(handles.editSize,'Enable', 'off'); 
        set(handles.f1,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f2,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f3,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f4,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f5,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f6,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f7,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f8,'Enable', 'on', 'Value', 1, 'String', '1'); 
        set(handles.f9,'Enable', 'on', 'Value', 1, 'String', '1');
        handles.ff1 = get(handles.f1, 'Value');
        handles.ff2 = get(handles.f2, 'Value');
        handles.ff3 = get(handles.f3, 'Value');
        handles.ff4 = get(handles.f4, 'Value');
        handles.ff5 = get(handles.f5, 'Value');
        handles.ff6 = get(handles.f6, 'Value');
        handles.ff7 = get(handles.f7, 'Value');
        handles.ff8 = get(handles.f8, 'Value');
        handles.ff9 = get(handles.f9, 'Value');
       
end
handles.size = get(handles.editSize, 'Value');
handles.P1 = get(handles.editP1, 'Value');
handles.P2 = get(handles.editP2, 'Value');

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupFilter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSize_Callback(hObject, eventdata, handles)
checkIntPositive(handles.editSize, hObject);
handles.size = floor(str2double(get(hObject, 'String')));
set(handles.editSize, 'String', handles.size);
guidata(hObject, handles); %vai buscar o valor do parametro e converte para double

% --- Executes during object creation, after setting all properties.
function editSize_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editP1_Callback(hObject, eventdata, handles)
handles.P1 = str2double(get(hObject, 'String'));
guidata(hObject, handles);  %vai buscar o valor do parametro e converte para double

% --- Executes during object creation, after setting all properties.
function editP1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editP2_Callback(hObject, eventdata, handles)
handles.P2 = str2double(get(hObject, 'String')); 
guidata(hObject, handles);    %vai buscar o valor do parametro e converte para double

function editP2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function applyFilter_Callback(hObject, eventdata, handles)
handles.lastImg = handles.original;
switch(handles.filterValue)
    case 1 
    case 2  %filtro de média
        average = fspecial('average', handles.size); %cria a matriz de Karnell de dimensão size definido no callback do popup
        handles.original = imfilter(handles.original, average); %aplica o filtro à imagem original    
        
    case 3  %filtro gaussiano 
        if isnan(handles.P1) || handles.P1 <= 0 %testa se estão escritos só números
            set(handles.editP1, 'Enable', 'on', 'Value', 0.5, 'String', '0.5');
            uiwait(msgbox('Sigma must be a positive number.','Warning', 'warn', 'modal'));
        else
            gaussian = fspecial('gaussian', handles.size, handles.P1);
            handles.original = imfilter(handles.original, gaussian); 
        end    
        
    case 4  %sobel vertical
        karnell = fspecial('sobel'); %cria a matriz de Karnell
        sobelV = transpose(karnell); %para aplicar o filtro sobel na vertical é necessário transpor a matriz
        handles.original = imfilter(handles.original, sobelV);
      
    case 5 %sobel horizontal
        sobelH = fspecial('sobel'); %cria a matriz de Karnell
        handles.original = imfilter(handles.original, sobelH);
        
    case 6 %sobel H+V   
        sobelH = fspecial('sobel'); %cria a matriz de Karnell
        sobelV = transpose(sobelH);
        handles.original = imfilter(handles.original, sobelV) + imfilter(handles.original, sobelH);
                
    case 7 %filtro laplaciano
        if isnan(handles.P1) || handles.P1 < 0 || handles.P1 > 1%testa se estão escritos só números
            set(handles.editP1, 'Enable', 'on', 'Value', 0.2, 'String', '0.2');
            uiwait(msgbox('Alpha must be a number higher than 0 and lower than 1.','Warning', 'warn', 'modal'));
        else
            laplacian = fspecial('laplacian', handles.P1); %cria a matriz de Karnell e pede valor alfa q varia entre 0 a 1 (double)
            handles.original = imfilter(handles.original, laplacian);  
        end     
        
    case 8 %mediana
        handles.original = medfilt2(handles.original);
        
    case 9 %log
        if isnan(handles.P1) || handles.P1 <= 0 %testa se estão escritos só números
            set(handles.editP1, 'Enable', 'on', 'Value', 0.5, 'String', '0.5');
            uiwait(msgbox('Sigma must be a positive number.','Warning', 'warn', 'modal'));
        else
            logaritmic = fspecial('log',handles.size, handles.P1); 
            handles.original = imfilter(handles.original, logaritmic);
        end         
        
    case 10 %disk
        disk = fspecial('disk', handles.size); 
        handles.original = imfilter(handles.original, disk);
        
    case 11 %motion
        if isnan(handles.P1) %verifica se P1 é um número
            set(handles.editP1, 'Value', 0, 'String', '0');
            uiwait(msgbox('Theta must be a number.','Warning', 'warn', 'modal'));
        else %caso nao seja, aplicamos o filtro
            motion = fspecial('motion', handles.size, handles.P1); 
            handles.original = imfilter(handles.original, motion);
        end
        
    case 12 %unsharp
         if isnan(handles.P1) || handles.P1 < 0 || handles.P1 > 1 %testa se estão escritos só números entre 0 e 1
            set(handles.editP1, 'Value', 0.2, 'String', '0.2');
            uiwait(msgbox('Alpha must be a number higher than 0 and lower than 1.','Warning', 'warn', 'modal'));
        else
            unsharp = fspecial('unsharp', handles.P1); 
            handles.original = imfilter(handles.original, unsharp); 
        end   
      
    case 13 %pewitt H+V
        prewittH = fspecial('prewitt'); %cria a matriz de Karnell
        prewittV = transpose(prewittH);
        handles.original = imfilter(handles.original, prewittV) + imfilter(handles.original, prewittH);
        %aplicamos o filtro horizontal e vertical
        
    case 14 %manual
        sum = handles.ff1 + handles.ff2 + handles.ff3 + handles.ff4 + handles.ff5 + handles.ff6 + handles.ff7 + handles.ff8 + handles.ff9;
        karnell = [handles.ff1 handles.ff2 handles.ff3; handles.ff4 handles.ff5 handles.ff6; handles.ff7 handles.ff8 handles.ff9]/sum;
        handles.original = imfilter(handles.original, karnell);
        %karnell é a matriz do filtro manual normalizada, que introduzimos
        %na função imfilter
end
guidata(hObject,handles);
storeArray(hObject, handles);
my_adjust(hObject, handles);

function f1_Callback(hObject, eventdata, handles) %valores do filtro manual
checkNumber(handles.f1, hObject); %confirmar que é um número
handles.ff1 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f4_Callback(hObject, eventdata, handles)
checkNumber(handles.f4, hObject);
handles.ff4 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f7_Callback(hObject, eventdata, handles)
checkNumber(handles.f7, hObject);
handles.ff7 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f2_Callback(hObject, eventdata, handles)
checkNumber(handles.f2, hObject);
handles.ff2 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f5_Callback(hObject, eventdata, handles)
checkNumber(handles.f5, hObject);
handles.ff5 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f8_Callback(hObject, eventdata, handles)
checkNumber(handles.f8, hObject);
handles.ff8 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f3_Callback(hObject, eventdata, handles)
checkNumber(handles.f3, hObject);
handles.ff3 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f6_Callback(hObject, eventdata, handles)
checkNumber(handles.f6, hObject);
handles.ff6 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function f9_Callback(hObject, eventdata, handles)
checkNumber(handles.f9, hObject);
handles.ff9 = str2double(get(hObject, 'String'));
guidata(hObject, handles);

function f9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function histEq_Callback(hObject, eventdata, handles) % Equalização do histograma 
handles.lastImg = handles.original;
handles.original = histeq(handles.original); %função paraequalizar o histograma
guidata(hObject, handles);
storeArray(hObject, handles);
my_adjust(hObject, handles); %my_adust coloca o resultado no axes4

function applyBW_Callback(hObject, eventdata, handles) %Passar pra preto e branco
handles.lastImg = handles.original;
LEVEL = graythresh(handles.original);  %calcular o threshold que define a partir do qual um pixel é preto ou branco
handles.original = uint8(255 * im2bw(handles.original,LEVEL)); %queremos que a img continue no intervalo [0,255]
%binariza a imagem com base no threshold
guidata(hObject, handles);
storeArray(hObject, handles);
my_adjust(hObject, handles);

function applyGray_Callback(hObject, eventdata, handles)
colormap(handles.axes4, 'gray'); %Voltar à escala de cinzento
handles.colorOn = false;
guidata(hObject, handles);

function chooseFC_Callback(hObject, eventdata, handles)
set(handles.applyFC, 'Enable', 'on');
handles.FCvalue = get(hObject, 'Value');
switch handles.FCvalue
case 1 
    set(handles.applyFC, 'Enable', 'off');
case 2
    handles.fakecolor = bone;
case 3 
    handles.fakecolor = jet;
case 4 
    handles.fakecolor = hot;
case 5
    handles.fakecolor = hsv;   
case 6
    handles.fakecolor = copper;
case 7
    handles.fakecolor = spring;
case 8
    handles.fakecolor = cool;
case 9
    handles.fakecolor = vga;   
case 10
    handles.fakecolor = prism;   
    
end
guidata(hObject, handles);
    
function chooseFC_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function applyFC_Callback(hObject, eventdata, handles)
handles.colorOn = true;
my_adjust(hObject, handles);

guidata(hObject, handles);

function applyNeg_Callback(hObject, eventdata, handles)
handles.lastImg = handles.original;
handles.original = 255 - handles.original;
guidata(hObject, handles);
storeArray(hObject, handles);
my_adjust(hObject, handles);

function applyDefault_Callback(hObject, eventdata, handles)
set(handles.brightness, 'Value', 0);
set(handles.Contrast, 'Value', 0);
set(handles.Gamma, 'Value', 1);
set(handles.showBright, 'String', '0');
set(handles.showContr, 'String', '0');
set(handles.showGamma, 'String', '1');
my_adjust(hObject, handles);
