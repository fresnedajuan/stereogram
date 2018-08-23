function varargout = stereogram(varargin)
% STEREOGRAM MATLAB code for stereogram.fig
%      STEREOGRAM, by itself, creates a new STEREOGRAM or raises the existing
%      singleton*.
%
%      H = STEREOGRAM returns the handle to a new STEREOGRAM or the handle to
%      the existing singleton*.
%
%      STEREOGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEREOGRAM.M with the given input arguments.
%
%      STEREOGRAM('Property','Value',...) creates a new STEREOGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stereogram_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stereogram_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stereogram

% Last Modified by GUIDE v2.5 15-Aug-2018 23:03:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stereogram_OpeningFcn, ...
                   'gui_OutputFcn',  @stereogram_OutputFcn, ...
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
global m1 
m1 = 'select disparity map';
% End initialization code - DO NOT EDIT


%global grayImg;% = nan(600,800);


% --- Executes just before stereogram is made visible.
function stereogram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stereogram (see VARARGIN)

% Choose default command line output for stereogram
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stereogram wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stereogram_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load3DButton.
function load3DButton_Callback(hObject, eventdata, handles)
       [FileName, PathName] = uigetfile('*.*','All Files');
       img = imread([PathName,FileName]);
       %axes('handles.axes1')
       imshow(img,'Parent',handles.axes1)
       global grayImg
       grayImg = imresize(rgb2gray(imread([PathName,FileName])),[600,800]); 
       imshow(grayImg,'Parent',handles.axes1)
% hObject    handle to load3DButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function offsetIn_Callback(hObject, eventdata, handles)
% hObject    handle to offsetIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offsetIn as text
%        str2double(get(hObject,'String')) returns contents of offsetIn as a double


% --- Executes during object creation, after setting all properties.
function offsetIn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setOffsetButton.
function setOffsetButton_Callback(hObject, eventdata, handles)
% hObject    handle to setOffsetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stereogramButton.
function stereogramButton_Callback(hObject, eventdata, handles)
    global grayImg  
    
    patR = 600;
    patC = 160;
    figureX = 800;
    figureY = 600;
    patternO = randi([0, 1], [patR,patC]); %original patterm
    
    mImage = nan(figureY,figureX);
    patternM = repmat(patternO,1);%modified pattern
    
    dispMapS = nan(patR,patC);%disparity map section
    dispMap = repmat(grayImg,1);
    
    M = max(grayImg);
    M = max(M);
    res = 4;%depth resolution
    
    %re-maps the gray image in to the disparity mat with the depth
    %resolution
    for i = 1:1:600
        for j = 1:1:800
            dispMap(i,j) = (grayImg(i,j)/(M/res));
        end
    end
    
    
    %creates an image using 5 times the random pattern 'patternM'
    c = 0;
    while c < 5
        for i = 1:1:patR
            for j = 1:1:patC
                pos = (patC*c)+j;
                mImage(i,pos) = patternM(i,j);
            end
        end
        c = c+1;
    end
    
    
    for d = 1:1:res 
        c = 0;
        %modifies each part of the 'mImage' acording to the disparity map
        while c < 5
            for i = 1:1:patR
                for j = 1:1:patC
                    pos = (patC*c)+j;
                    patternM(i,j) = mImage(i,pos);
                end
            end
            for e = 0:1:c
                for i = 1:1:patR
                    for j = 1:1:patC
                        pos = (patC*e)+j;
                        dispMapS(i,j) = dispMap(i,pos);
                    end
                end
                
                %function to make the shifting of the pixels
                [patternM, prevOut,rOutFlag ]= pxl2stereogram(patternM,dispMapS,d);
                
                if rOutFlag == 1 && e == c && c > 0
                    c = c-1;
                    for i = 1:1:patR
                        for j = 1:1:patC
                            if isnan(prevOut(i,j)) == 0
                                pos = (patC*c)+j;
                                mImage(i,pos) = prevOut(i,j);
                            else
                                mImage(i,pos) = mImage(i,pos);
                            end
                        end
                    end
                    c = c+1;
                end
            end
            
            for i = 1:1:patR
                for j = 1:1:patC
                    pos = (patC*c)+j;
                    mImage(i,pos) = patternM(i,j);
                end
            end
            c = c+1;    
        end
    end
    [filename, ext, user_canceled] = imputfile
    imwrite(mImage,filename,'jpg')
    winopen(filename)
    
%     imwrite(mImage,'stereogramFinal2.jpg','quality',100)

% hObject    handle to stereogramButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function [mOut, prevOut,rOutFlag] =pxl2stereogram(mIn, dsMap,offset)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [m,n] = size(mIn);
    mInM = repmat(mIn,1);
    prevOut = nan(m,n);
    rOutFlag = 0;
    for i = 1:1:m
        for j = 1:1:n
            if dsMap(i,j) >= offset
                if (j-offset) < 1
                    prevOut(i,n+j-offset) = mIn(i,j);
                    mInM(i,n+j-offset) = mIn(i,j);
                    rOutFlag = 1;
                elseif rOutFlag == 0
                    mInM(i,j-offset) = mIn(i,j);
                end
            end
        end
    end
    if(rOutFlag == 1)
        %mInM = prevOut;
        
        for i = 1:1:m
            for j = 1:1:n
                if dsMap(i,j) >= offset
                    if (j-offset) >= 1
                        mInM(i,j-offset) = mIn(i,j);
                    end
                end
            end
        end
    end
    mOut = mInM;
    
    


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function slider1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit2_Callback(hObject, eventdata, handles)
    global m1;
    set(handles.edit2,'String',m1);
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
