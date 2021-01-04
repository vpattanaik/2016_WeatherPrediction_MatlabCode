function varargout = WeatherData(varargin)
% WEATHERDATA MATLAB code for WeatherData.fig
%      WEATHERDATA, by itself, creates a new WEATHERDATA or raises the existing
%      singleton*.
%
%      H = WEATHERDATA returns the handle to a new WEATHERDATA or the handle to
%      the existing singleton*.
%
%      WEATHERDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WEATHERDATA.M with the given input arguments.
%
%      WEATHERDATA('Property','Value',...) creates a new WEATHERDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WeatherData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WeatherData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WeatherData

% Last Modified by GUIDE v2.5 21-Apr-2016 13:45:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WeatherData_OpeningFcn, ...
                   'gui_OutputFcn',  @WeatherData_OutputFcn, ...
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


% --- Executes just before WeatherData is made visible.
function WeatherData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WeatherData (see VARARGIN)

NNDATA = double([]);

% Choose default command line output for WeatherData
handles.NNDATA = NNDATA;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WeatherData wait for user response (see UIRESUME)
% uiwait(handles.figure_weather);


% --- Outputs from this function are returned to the command line.
function varargout = WeatherData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_import.
function button_import_Callback(hObject, eventdata, handles)
% hObject    handle to button_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile('.txt');
delimiter = ' ';

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
TEMPDATA = [dataArray{1:end-1}];

%% Display TEMPDATA values in Table
set(handles.uitable1, 'data', TEMPDATA);

set(handles.text1, 'string', ['INITIAL DATA SET - ' filename]);

handles.filename = filename;
handles.TEMPDATA = TEMPDATA;
guidata(hObject, handles);

msgbox(['Data imported from ' filename '. Please Fix Data to replace Missing Values with NaN.'], 'Help', 'help');


% --- Executes on button press in button_fix.
function button_fix_Callback(hObject, eventdata, handles)
% hObject    handle to button_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1: length(handles.TEMPDATA)
    if handles.TEMPDATA(i, 4) == -99
        handles.TEMPDATA(i, 4) = NaN;
    end
    if (handles.TEMPDATA(i, 1) == 2 && handles.TEMPDATA(i, 2) == 28) && (handles.TEMPDATA(i+1, 2) == 1)
        for j = length(handles.TEMPDATA)-1:-1:i+1
            handles.TEMPDATA(j+1, :) = handles.TEMPDATA(j, :);
        end
        handles.TEMPDATA(i+1, 1) = 2;
        handles.TEMPDATA(i+1, 2) = 29;
        handles.TEMPDATA(i+1, 3) = handles.TEMPDATA(i, 3);
        handles.TEMPDATA(i+1, 4) = NaN;
    end
end

%% Display TEMPDATA values in Table
set(handles.uitable1, 'data', handles.TEMPDATA);

guidata(hObject, handles);

msgbox('Missing Values replaced with NaN. Please Reduce Data to retrieve 20 Years Data.', 'Help', 'help');


% --- Executes on button press in button_reduce.
function button_reduce_Callback(hObject, eventdata, handles)
% hObject    handle to button_reduce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VARTEMP(7320, 4) = 0;
for i = 1: 7320
    VARTEMP(i, :) = handles.TEMPDATA(i, :);
end
%% Display TEMPDATA values in Table
set(handles.uitable1, 'data', VARTEMP);

handles.VARTEMP = VARTEMP;
guidata(hObject, handles);

msgbox('Data reduced to 20 Years. Please Finalize Data to fix NaN Values.', 'Help', 'help');


% --- Executes on button press in button_finalize.
function button_finalize_Callback(hObject, eventdata, handles)
% hObject    handle to button_finalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TIME = 1: 7320;
VTEMP = (handles.VARTEMP(:, 4)-32)*5/9;
VTEMP = round(VTEMP*10)/10;
Xi = TIME;
Yi = interp1(TIME, VTEMP, Xi, 'spline');
warning('off','MATLAB:interp1:NaNstrip');
handles.VARTEMP(:, 4) = Yi;

%% Display TEMPDATA values in Table
set(handles.uitable2, 'data', handles.VARTEMP);
set(handles.text2, 'string', ['FINAL DATA SET - ' handles.filename]);

guidata(hObject, handles);

msgbox('All NaN Values removed. Please Add NN Data to generate Neural Network Data Set.', 'Help', 'help');

% --- Executes on button press in button_add.
function button_add_Callback(hObject, eventdata, handles)
% hObject    handle to button_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odatasize = length(handles.NNDATA);
ndatasize = odatasize + 5856;
handles.NNDATA = resizem (handles.NNDATA, [5 ndatasize]);
handles.NNDATA (1, odatasize+1:ndatasize) = handles.VARTEMP (1: 5856, 4);
handles.NNDATA (2, odatasize+1:ndatasize) = handles.VARTEMP (367: 6222, 4);
handles.NNDATA (3, odatasize+1:ndatasize) = handles.VARTEMP (733: 6588, 4);
handles.NNDATA (4, odatasize+1:ndatasize) = handles.VARTEMP (1099: 6954, 4);
handles.NNDATA (5, odatasize+1:ndatasize) = handles.VARTEMP (1465: 7320, 4);

nninput = handles.NNDATA(1:4, :);
nnoutput = handles.NNDATA(5, :);

%% Display NNDATA values in Table
set(handles.uitable3, 'data', handles.NNDATA);

handles.nninput = nninput;
handles.nnoutput = nnoutput;
guidata(hObject, handles);

msgbox('Neural Network Data Set generated. Please Train NN (run Neural Network)or Import Data (to add more Training Data).', 'Help', 'help'); 


% --- Executes on button press in button_train.
function button_train_Callback(hObject, eventdata, handles)
% hObject    handle to button_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Solve an Input-Output Fitting problem with a Neural Network
% This script assumes these variables are defined:
%
%   ip - input data.
%   op - target data.

inputs = handles.nninput;
targets = handles.nnoutput;

% Create a Fitting Network
hiddenLayerSize = 4;
WeatherANN = fitnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
WeatherANN.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
WeatherANN.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
WeatherANN.divideFcn = 'dividerand';  % Divide data randomly
WeatherANN.divideMode = 'sample';  % Divide up every sample
WeatherANN.divideParam.trainRatio = 80/100;
WeatherANN.divideParam.valRatio = 10/100;
WeatherANN.divideParam.testRatio = 10/100;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
WeatherANN.trainFcn = 'trainlm';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
WeatherANN.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
WeatherANN.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};

% Train the Network
[WeatherANN,tr] = train(WeatherANN,inputs,targets);

% Test the Network
outputs = WeatherANN(inputs);
errors = gsubtract(targets,outputs);

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};

% Print Performance
performance = perform(WeatherANN,targets,outputs)
trainPerformance = perform(WeatherANN,trainTargets,outputs)
valPerformance = perform(WeatherANN,valTargets,outputs)
testPerformance = perform(WeatherANN,testTargets,outputs)

% Save the Network
save WeatherANN;
msgbox('Neural Network Training Complete. Saved Successfully!!!', 'Help', 'help');


% --- Executes on button press in button_test.
function button_test_Callback(hObject, eventdata, handles)
% hObject    handle to button_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TestANN;
