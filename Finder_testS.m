function varargout = Finder_testS(varargin)
% FINDER_TESTS MATLAB code for Finder_testS.fig
%      FINDER_TESTS, by itself, creates a new FINDER_TESTS or raises the existing
%      singleton*.
%
%      H = FINDER_TESTS returns the handle to a new FINDER_TESTS or the handle to
%      the existing singleton*.
%
%      FINDER_TESTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDER_TESTS.M with the given input arguments.
%
%      FINDER_TESTS('Property','Value',...) creates a new FINDER_TESTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Finder_testS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Finder_testS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Finder_testS

% Last Modified by GUIDE v2.5 21-Nov-2017 10:17:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Finder_testS_OpeningFcn, ...
                   'gui_OutputFcn',  @Finder_testS_OutputFcn, ...
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


% --- Executes just before Finder_testS is made visible.
function Finder_testS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Finder_testS (see VARARGIN)

% Choose default command line output for Finder_testS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Finder_testS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Finder_testS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global MainPath;
MainPath=(get(handles.Mainpath,'String'));
nPos=str2double(get(handles.Npositions,'String'));
MinP=str2double(get(handles.MinPor,'String'));
Num_pot=str2double(get(handles.NumWorkers,'String'));
if isnan(MinP) || isnan(Num_pot) || isnan(nPos)
    errordlg('В поля количество итераций и количество потоков необходимо вводить только натуральные числа!','Error');
end
%  global MainPath;
% nPos = 100;  % количество выходных файлов
% srd=0;   % порог среднего
% Num_pot=8;  %количество паралельных потоков

delete(gcp('nocreate'))
parpool(Num_pot);
% MainPath = 'D:\newc\';

tic
disp('Расчет характеристик и гауссиан для шаблонных файлов (через мкк)...');
ResMFCC1 = CalcData(1);
toc

tic
disp('Расчет характеристик для тестовых файлов и сравнение (через мкк)...');
ResMFCC2=CmprGMM(nPos,MinP);
disp(ResMFCC2);
toc


function Mainpath_Callback(hObject, eventdata, handles)
% hObject    handle to Mainpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mainpath as text
%        str2double(get(hObject,'String')) returns contents of Mainpath as a double


% --- Executes during object creation, after setting all properties.
function Mainpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mainpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Npositions_Callback(hObject, eventdata, handles)
% hObject    handle to Npositions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Npositions as text
%        str2double(get(hObject,'String')) returns contents of Npositions as a double


% --- Executes during object creation, after setting all properties.
function Npositions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Npositions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinPor_Callback(hObject, eventdata, handles)
% hObject    handle to MinPor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinPor as text
%        str2double(get(hObject,'String')) returns contents of MinPor as a double


% --- Executes during object creation, after setting all properties.
function MinPor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinPor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumWorkers_Callback(hObject, eventdata, handles)
% hObject    handle to NumWorkers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumWorkers as text
%        str2double(get(hObject,'String')) returns contents of NumWorkers as a double


% --- Executes during object creation, after setting all properties.
function NumWorkers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumWorkers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
