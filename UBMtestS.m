function varargout = UBMtestS(varargin)
% UBMTESTS MATLAB code for UBMtestS.fig
%      UBMTESTS, by itself, creates a new UBMTESTS or raises the existing
%      singleton*.
%
%      H = UBMTESTS returns the handle to a new UBMTESTS or the handle to
%      the existing singleton*.
%
%      UBMTESTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UBMTESTS.M with the given input arguments.
%
%      UBMTESTS('Property','Value',...) creates a new UBMTESTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UBMtestS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UBMtestS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UBMtestS

% Last Modified by GUIDE v2.5 19-Nov-2017 20:18:20

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UBMtestS_OpeningFcn, ...
                   'gui_OutputFcn',  @UBMtestS_OutputFcn, ...
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


% --- Executes just before UBMtestS is made visible.
function UBMtestS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UBMtestS (see VARARGIN)

% Choose default command line output for UBMtestS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UBMtestS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UBMtestS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CalculateUBM.
function CalculateUBM_Callback(hObject, eventdata, handles)
% hObject    handle to CalculateUBM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','off');
set(hObject,'Interruptible','on');
set(handles.stop,'Enable','on');
drawnow;
uiresume;
MainP=(get(handles.MainPath,'String'));
IterCnt=str2double(get(handles.numiter,'String'));
nworkers=str2double(get(handles.Numworkers,'String'));

if(get(handles.radio1024,'Value')==1)
    GMMCount=1024;
end
if(get(handles.radio2048,'Value')==1)
    GMMCount=2048;
end
if isnan(IterCnt) || isnan(nworkers)
    errordlg('В поля количество итераций и количество потоков необходимо вводить только натуральные числа!','Error');
end
CreateUBM(MainP,IterCnt,nworkers,GMMCount)


function MainPath_Callback(hObject, eventdata, handles)
% hObject    handle to MainPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MainPath as text
%        str2double(get(hObject,'String')) returns contents of MainPath as a double


% --- Executes during object creation, after setting all properties.
function MainPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numiter_Callback(hObject, eventdata, handles)
% hObject    handle to numiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numiter as text
%        str2double(get(hObject,'String')) returns contents of numiter as a double


% --- Executes during object creation, after setting all properties.
function numiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Numworkers_Callback(hObject, eventdata, handles)
% hObject    handle to Numworkers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Numworkers as text
%        str2double(get(hObject,'String')) returns contents of Numworkers as a double


% --- Executes during object creation, after setting all properties.
function Numworkers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Numworkers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause;
set(hObject,'Enable','off');
set(handles.CalculateUBM,'Enable','on');
drawnow;

% --- Executes on button press in radio1024.
function radio1024_Callback(hObject, eventdata, handles)
% hObject    handle to radio1024 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio1024


% --- Executes on button press in radio2048.
function radio2048_Callback(hObject, eventdata, handles)
% hObject    handle to radio2048 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio2048
