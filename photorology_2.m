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

% Last Modified by GUIDE v2.5 20-Nov-2017 15:32:54

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
function photorology_2_OpeningFcn(hObject, eventdata, handles, varargin) %OPENING FUNCTION
handles.output = hObject;
%definir algumas variáveis e imagem de um botão
handles.typeInterpol = ' --- Interpolation Type ---'; 
handles.typeFilter = ' --- Filter ---';
importF=imresize(imread('importFolder', 'png'), [50 50]); 
set(handles.importFolder, 'cdata', importF) %mete a imagem no botão importar da pasta
guidata(hObject, handles); %actualizar guidata


function varargout = photorology_2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function phantomNResolution(hObject, handles) %FUNÇÃO QUE CRIA O FANTOMA COM BASE NOS PARÂMETROS DO UTILIZADOR
handles.resolution = str2num(handles.resolution); %converter o valor da resolução para número
handles.phantomTest = phantom(handles.typePhantom, handles.resolution); %criar o fantoma e guardar numa variável da estrutura handles
importT=imresize(imread('importTest', 'png'), [50 50]); %vamos buscar as imagens para os botões
save=imresize(imread('savesave', 'png'), [38 38]); %imagem para botão grvar
%activar os botões relacionados com o fantoma
set(handles.saveImg, 'Enable', 'on', 'cdata', save); 
set(handles.projections, 'Enable', 'on', 'String', '180');
set(handles.importTest, 'Enable', 'on', 'cdata', importT);
handles.projectionValue = 180; %valor default das projeções
set(handles.addNoise, 'Enable', 'on', 'Min', 0, 'Max', 100, 'Value', 0); %programar o slider
guidata(hObject, handles); %actualizar handles
axes(handles.axes1); 
imshow(handles.phantomTest, [], 'initialMagnification', 'fit') %imshow da imagem que faz fit no axes e tem escala de cor ajustada

% --- Executes on selection change in phantomPopUp.
function phantomPopUp_Callback(hObject, eventdata, handles) %POP UP MENU DO TIPO DE FANTOMA
allItems = get(handles.phantomPopUp,'string'); %string com todas as opções do popupmenu
selectedIndex = get(handles.phantomPopUp,'Value'); %índice seleccionado
handles.typePhantom = allItems{selectedIndex}; %gurdar a string correspondente ao índice

allItems = get(handles.ResolutionPopUp,'string'); %string com todas as opções do popupmenu
selectedIndex = get(handles.ResolutionPopUp,'Value'); %índice seleccionado
handles.resolution = allItems{selectedIndex}; %gurdar a string correspondente ao índice

if(~strcmp(handles.resolution, ' --- Resolution ---') && ~strcmp(handles.typePhantom, ' --- Phantoms ---'))
    %se as opções dos popupmenus forem diferentes da prmeira opção
    %aplicar a função de calcular o fantoma
    phantomNResolution(hObject, handles);
    handles=guidata(hObject); %definir a estrutura handles 
end
guidata(hObject, handles); %actualizar estrutura handles


function phantomPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ResolutionPopUp.
function ResolutionPopUp_Callback(hObject, eventdata, handles) %POP UP MENU DA RESOLUÇÃO
allItems = get(handles.phantomPopUp,'string'); %string com todas as opções do popupmenu
selectedIndex = get(handles.phantomPopUp,'Value'); %índice seleccionado
handles.typePhantom = allItems{selectedIndex}; %gurdar a string correspondente ao índice

allItems = get(handles.ResolutionPopUp,'string'); %string com todas as opções do popupmenu
selectedIndex = get(handles.ResolutionPopUp,'Value'); %índice seleccionado
handles.resolution = allItems{selectedIndex}; %gurdar a string correspondente ao índice

if(~strcmp(handles.resolution, ' --- Resolution ---') && ~strcmp(handles.typePhantom, ' --- Phantoms ---'))
    %se as opções dos popupmenus forem diferentes da prmeira opção
    %aplicar a função de calcular o fantoma
    phantomNResolution(hObject, handles);
    handles=guidata(hObject); %definir a estrutura handles 
end
guidata(hObject, handles); %actualizar estrutura handles
        
function ResolutionPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setSenoConditions(hObject, handles) %FUNÇAO PARA DEFINIR CONDIÇÕES QUANDO OBTIDO O SENOGRAMA
%função chamada quando introduzimos um senograma para definir condições e
%variáveis
save=imresize(imread('savesave', 'png'), [38 38]); %imagem do botão save
set(handles.saveSeno, 'Enable', 'on', 'cdata', save);
set(handles.interpolPopUp, 'Enable', 'on');
set(handles.filterPopUp, 'Enable', 'on');
set(handles.addNoise, 'Enable', 'on', 'Min', 0, 'Max', 100, 'Value', 0); %ativar e def range slider
handles.noiseValue = 0; %inicializar a variável associada ao ruído
set(handles.currentNoise, 'String', '0%'); 
guidata(hObject, handles); %actualizar guidata

function importFolder_Callback(hObject, eventdata, handles) %BOTÃO PARA IMPORTAR SENOGRAMA DA PASTA
[IMGname,IMGpath] = uigetfile({'*.seno';'*.bmp'},'Select Image');
if IMGpath==0 %caso não seja seleccionado um endereço para ir buscar a imagem dá uma mensagem de erro
    uiwait(msgbox('Dont know what to read :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname); %concatenar o nome e o endereço para usar no imread
handles.seno = imread(IMGdirectory); %guardamos a imagem numa variável da estrutur handles
setSenoConditions(hObject, handles); %função para definir condições e variáveis
handles = guidata(hObject); %actualizar o handles, visto que foi chamada uma user function
handles.degreePasse=1; %referente à imagem disponibilizada pelo professor
guidata(hObject, handles); %actualizar guidata
noiseSeno(hObject, handles); %função para imprimir a imagem e adicionar ruído


% --- Executes on button press in importTest.
function importTest_Callback(hObject, eventdata, handles) %BOTÃO IMPORTAR SENOGRAMA DE TESTE
handles.degreePasse = 180/handles.projectionValue; %calcular a distância em graus entre projeçoes
handles.seno = radon(handles.phantomTest, 0:handles.degreePasse:179); 
%fazer a transformada de radon do fantoma com o número de projecções
%definidas pelo utilizador
%no segundo argumento é dado o intervalo e o passo
setSenoConditions(hObject, handles); %função para definir condições e variáveis
handles = guidata(hObject); %actualizar o handles, visto que foi chamada uma user function
guidata(hObject, handles); %actualizar guidata
noiseSeno(hObject, handles); %função para imprimir a imagem e adicionar ruído


function saveImg_Callback(hObject, eventdata, handles) %GRAVAR O FANTOMA
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
if IMGpath==0 %caso não seja seleccionado um endereço para ir buscar a imagem dá uma mensagem de erro
    uiwait(msgbox('Dont know what to save :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.phantomTest,IMGdirectory); %gravar a imagem na diretoria seleccionada

% --- Executes on button press in saveSeno.
function saveSeno_Callback(hObject, eventdata, handles) %GRAVAR O SENOGRAMA
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
if IMGpath==0  %caso não seja seleccionado um endereço para ir buscar a imagem dá uma mensagem de erro
    uiwait(msgbox('Dont know what to save :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.senoNoise,IMGdirectory); %gravar a imagem na diretoria seleccionada

% --- Executes on button press in saveRecons.
function saveRecons_Callback(hObject, eventdata, handles) %GRAVAR IMAGEM RECONSTRUÍDA
[IMGname,IMGpath] = uiputfile({'*.jpg';'*.bmp'},'Save Image');
%caso não seja seleccionado um endereço para ir buscar a imagem dá uma mensagem de erro
if IMGpath==0
    uiwait(msgbox('Dont know what to save :(', 'Warning', 'warn', 'modal'));
    return
end
IMGdirectory = strcat(IMGpath,IMGname);
imwrite(handles.reconstructed,IMGdirectory); %guardamos a imagem reconstruída

% --- Executes on selection change in interpolPopUp.
function interpolPopUp_Callback(hObject, eventdata, handles) %POP UP MENU DA INTERPOLAÇÃO
%obter a string associada à interpolação escolhida e passar para a
%estrutura handles
allItems = get(hObject,'String');
selectedIndex = get(hObject,'Value');
handles.typeInterpol = allItems{selectedIndex};
%caso a string seleccionada seja válida, reconstruir a imagem
if(~strcmp(handles.typeFilter, ' --- Filter ---') && ~strcmp(handles.typeInterpol, ' --- Interpolation Type ---'))
    reconstruct=imresize(imread('magic', 'png'), [43 43]); %imagem do botão reconstruir
    set(handles.reconstructImg, 'Enable', 'on', 'cdata', reconstruct); %ativar o botão reconstruir
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function interpolPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in filterPopUp.
function filterPopUp_Callback(hObject, eventdata, handles) %POP UP MENU DOS FILTROS
%obter a string associada ao filtro escolhido e passar para a
%estrutura handles
allItems = get(hObject,'string');
selectedIndex = get(hObject,'Value');
handles.typeFilter = allItems{selectedIndex};
%caso a string seleccionada seja válida, reconstruir a imagem
if(~strcmp(handles.typeFilter, ' --- Filter ---') && ~strcmp(handles.typeInterpol, ' --- Interpolation Type ---'))
    reconstruct=imresize(imread('magic', 'png'), [43 43]); %imagem do botão reconstruir
    set(handles.reconstructImg, 'Enable', 'on', 'cdata', reconstruct); %activar reconstruir
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filterPopUp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in reconstructImg.
function reconstructImg_Callback(hObject, eventdata, handles) %BOTÃO PARA RECONSTRUÍR A IMAGEM
%para reconstuír a imagem é aplicara a transformada inversa de radon ao
%senograma seleccionado pelo utilizador, com o tipo de interpolação e
%filtro escolhidos
handles.reconstructed = iradon(handles.senoNoise, handles.degreePasse, handles.typeInterpol, handles.typeFilter); 
save=imresize(imread('savesave', 'png'), [38 38]); %imagem do botão para gravar
set(handles.saveRecons, 'Enable', 'on', 'cdata', save); %activar possibilidade de guardar a reconstrução
axes(handles.axes5) %seleccionar o axes 5
imshow(handles.reconstructed, [], 'InitialMagnification','fit'); %imprimir a imagem com escala ajustada
guidata(hObject, handles); %actualizar guidata


function projections_Callback(hObject, eventdata, handles) %EDIT BOX QUE RECEBE O NR DE PROJECÇÕES
handles.projectionValue = str2double(get(hObject, 'String')); %converter para número
if isnan(handles.projectionValue) || handles.projectionValue <=0 %garantir que é um número inteiro positivo
    set(hObject,'String','180'); %se não for, o valor default é 180
    uiwait(msgbox('The number must be a positive integer.','Warning', 'warn', 'modal'));
end
guidata(hObject, handles); %atualizar handles

% --- Executes during object creation, after setting all properties.
function projections_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function addNoise_Callback(hObject, eventdata, handles) %SLIDER PARA ADICIONAR RUÍDO
handles.noiseValue = round(get(hObject, 'Value')); %ir buscar o valor do slider
noise=num2str(handles.noiseValue); %converter em string para mostrar na text box
str = strcat(noise, '%'); %concatenar strings
set(handles.currentNoise, 'String', str); %definir string da textbox
noiseSeno(hObject, handles) %imprimir  imagem
handles = guidata(hObject); %actualizar estrutura handles
guidata(hObject, handles); %actualizar guidata


% --- Executes during object creation, after setting all properties.
function addNoise_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function noiseSeno(hObject, handles) %FUNÇÃO QUE ADICIONA RUÍDO E IMPRIME QUALQUER SENOGRAMA
%para o ruído, soma-se à imagem original uma matriz com o seu tamanho com a
%percentagem de ruído pedida em relação ao ponto de maior intensidade do
%senograma
handles.senoNoise = im2double(handles.seno) + handles.noiseValue*rand(size(handles.seno))*max(im2double(handles.seno(:)))/100;
axes(handles.axes2) %seleccionamos o axes 2
imshow(imresize(handles.senoNoise', [400 400], 'nearest'), []) %mostrar a imagem com tamanho [400 400] ou tamanho do axes, com interpolação
%nearest neighbour e escala de cizento ajustada
guidata(hObject, handles); %actualizar guidata

function importFolder_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to importFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
