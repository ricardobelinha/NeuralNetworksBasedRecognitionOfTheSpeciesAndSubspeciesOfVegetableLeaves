function varargout = customizedImage(varargin)
% customizedImage MATLAB code for customizedImage.fig
%      customizedImage, by itself, creates a new customizedImage or raises the existing
%      singleton*.
%
%      H = customizedImage returns the handle to a new customizedImage or the handle to
%      the existing singleton*.
%
%      customizedImage('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in customizedImage.M with the given input arguments.
%
%      customizedImage('Property','Value',...) creates a new customizedImage or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before customizedImage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to customizedImage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help customizedImage

% Last Modified by GUIDE v2.5 21-Jun-2018 23:56:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @customizedImage_OpeningFcn, ...
    'gui_OutputFcn',  @customizedImage_OutputFcn, ...
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


% --- Executes just before customizedImage is made visible.
function customizedImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to customizedImage (see VARARGIN)

% Choose default command line output for customizedImage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes customizedImage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = customizedImage_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbTrata.
function pbTrata_Callback(hObject, eventdata, handles)
% hObject    handle to pbTrata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Abre janela para escolher imagem
set(handles.etImagem,'String','');
set(handles.etImagem,'ForegroundColor','White');
set(handles.tEspecie,'String','');
set(handles.tSubEspecie,'String','');
drawnow
[filename pathname] = uigetfile({'*.jpg';'*.bmp'},'Select the image to classify'); inputimage=strcat(pathname, filename);
setGlobalNomeImagem(inputimage);
% vai buscar ficheiro. Read image into the workspace.
currentimage = imread(inputimage);
%currentimage = graythresh(currentimage);
if size(currentimage,3)==3
    set(handles.etImagem,'String','This is a colored image.');
    currentimage = rgb2gray(currentimage);
else
    set(handles.etImagem,'String','The image is in black and white.');
end
% binariza imagem
currentimage_a = imbinarize(currentimage);
% get largest connected region in the image
BW = currentimage_a;
currentimage_a = zeros (size(BW));
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
currentimage_a(CC.PixelIdxList{idx}) = 1;
currentimage_b = currentimage_a;
load('maxMatrice.mat')
max_alt = matriz_maior(1);
max_larg = matriz_maior(2);
preta = zeros(max_alt,max_larg);
[altura, largura] = size(currentimage_a);
alt = round((max_alt - altura)/2);
larg = round((max_larg - largura)/2);
preta(alt+1:alt+altura, larg+1:larg+largura) = currentimage_a;
thisImage =  imresize(preta,[32 32]);
thisVector = thisImage(:);
currentimage_a = thisVector;
% Busca propriedades
s = regionprops(currentimage_b,'ConvexArea','Eccentricity','EquivDiameter','Extent','FilledArea','MajorAxisLength','MinorAxisLength','Orientation','Perimeter','Solidity');
dummyVector = [s.ConvexArea s.Eccentricity s.EquivDiameter s.Extent s.FilledArea s.MajorAxisLength s.MinorAxisLength s.Orientation s.Perimeter s.Solidity];
setGlobalImagem(currentimage_a);
setGlobalImagemProps(dummyVector);
msgbox('The image has been checked!','Customized image')

% --- Executes on button press in pbVerifica.
function pbVerifica_Callback(hObject, eventdata, handles)
% hObject    handle to pbVerifica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = getGlobalImagem;
imageProps = getGlobalImagemProps;
isToTrainWithProps = get(handles.popupmenu1, 'Value');
% DESCOBRE ID ESPÉCIE E SUB ESPÉCIE
[idEspecie, idSubEspecie] = customizedImageGetSpecieAndSubSpecie(isToTrainWithProps, image, imageProps);
disp('The neural network was able to identify the possible specie and subspecie!');
disp('The neural network was able to identify the possible subspecie!');
% ABRE EXCEL ESPECIES
[idsSpecies, nomesSpecies] = xlsread('leaves_classification','programa_especies');
[idsSubSpecies, nomesSubSpecies] = xlsread('leaves_classification','programa_subespecies');
nomesSpecies(:,1) = [];
nomesSpecies(1) = [];
nomesSubSpecies(:,1) = [];
nomesSubSpecies(1) = [];
% ENCONTRA ESPÉCIE E SUB ESPÉCIE NO EXCEL
posSpecie = find(idEspecie==idsSpecies(:));
posSubSpecie = find(idSubEspecie==idsSubSpecies(:));
if ~isempty(posSpecie)
    nomeEspecie = nomesSpecies(posSpecie);
end
if ~isempty(posSubSpecie)
    nomeSubEspecie = nomesSubSpecies(posSubSpecie);
end
nomeEspecie = nomeEspecie{1};
nomeSubEspecie = nomeSubEspecie{1};
set(handles.tEspecie,'String',nomeEspecie);
set(handles.tSubEspecie,'String',nomeSubEspecie);
drawnow
nomeFicheiro = getGlobalNomeImagem;
if isToTrainWithProps
    inputs = 'Characteristics of the image';
else
    inputs = 'Image in binary';
end
% MATRIZ COM OS DADOS TODOS PRONTA PARA ESCREVER NO EXCEL
texto = {nomeFicheiro, inputs, nomeEspecie, nomeSubEspecie};
% PRIMEIRA PÁGINA DO EXCEL
sheet = 2;
% ESCREVE NO EXCEL
[num,txt] = xlsread('results.xlsx',sheet);
%finaltxt = vertcat(txt, texto);
% Acha ultima linha
[rows, columns] = size(txt);
if rows == 1
    rows = 2;
end
rows = rows +1;
% Escrever a começar numa determinada célula
nomeCelula = strcat('A',num2str(rows));
xlswrite('results.xlsx',texto,sheet,nomeCelula)

function eNomeImagem_Callback(hObject, eventdata, handles)
% hObject    handle to eNomeImagem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eNomeImagem as text
%        str2double(get(hObject,'String')) returns contents of eNomeImagem as a double


% --- Executes during object creation, after setting all properties.
function eNomeImagem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eNomeImagem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setGlobalImagem(val)
global pImagem
pImagem = val;

function r = getGlobalImagem
global pImagem
r  = pImagem;

function setGlobalImagemProps(val)
global oImagemProps
oImagemProps = val;

function r = getGlobalImagemProps
global oImagemProps
r  = oImagemProps;

function setGlobalNomeImagem(val)
global oNomeImagem
oNomeImagem = val;

function r = getGlobalNomeImagem
global oNomeImagem
r  = oNomeImagem;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
