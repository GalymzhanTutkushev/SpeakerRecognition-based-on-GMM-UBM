function varargout = UBM_testC(varargin)
% UBM_TESTC MATLAB code for UBM_testC.fig
%      UBM_TESTC, by itself, creates a new UBM_TESTC or raises the existing
%      singleton*.
%
%      H = UBM_TESTC returns the handle to a new UBM_TESTC or the handle to
%      the existing singleton*.
%
%      UBM_TESTC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UBM_TESTC.M with the given input arguments.
%
%      UBM_TESTC('Property','Value',...) creates a new UBM_TESTC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UBM_testC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UBM_testC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UBM_testC

% Last Modified by GUIDE v2.5 19-Nov-2017 18:28:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UBM_testC_OpeningFcn, ...
                   'gui_OutputFcn',  @UBM_testC_OutputFcn, ...
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


% --- Executes just before UBM_testC is made visible.
function UBM_testC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UBM_testC (see VARARGIN)

% Choose default command line output for UBM_testC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UBM_testC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UBM_testC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Path_Callback(hObject, eventdata, handles)
% hObject    handle to Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Path as text
%        str2double(get(hObject,'String')) returns contents of Path as a double


% --- Executes during object creation, after setting all properties.
function Path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Path (see GCBO)
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


% --- Executes on button press in calculateUBM.
function calculateUBM_Callback(hObject, eventdata, handles)
% hObject    handle to calculateUBM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nworkers=str2num(get(hObject,'String'));
CreateUBM(nworkers)
