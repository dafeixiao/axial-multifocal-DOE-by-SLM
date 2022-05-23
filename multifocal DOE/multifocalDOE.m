function varargout = multifocalDOE(varargin)
% MULTIFOCALDOE MATLAB code for multifocalDOE.fig
%      MULTIFOCALDOE, by itself, creates a new MULTIFOCALDOE or raises the existing
%      singleton*.
%
%      H = MULTIFOCALDOE returns the handle to a new MULTIFOCALDOE or the handle to
%      the existing singleton*.
%
%      MULTIFOCALDOE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIFOCALDOE.M with the given input arguments.
%
%      MULTIFOCALDOE('Property','Value',...) creates a new MULTIFOCALDOE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multifocalDOE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multifocalDOE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multifocalDOE

% Last Modified by GUIDE v2.5 04-Jun-2021 17:20:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multifocalDOE_OpeningFcn, ...
                   'gui_OutputFcn',  @multifocalDOE_OutputFcn, ...
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


% --- Executes just before multifocalDOE is made visible.
function multifocalDOE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multifocalDOE (see VARARGIN)

% Choose default command line output for multifocalDOE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multifocalDOE wait for user response (see UIRESUME)
% uiwait(handles.figure1);





% --- Outputs from this function are returned to the command line.
function varargout = multifocalDOE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f ratio M N delta lambda savePhase method focalLength d1 d2 RI compensateOn

k = 2*pi/lambda; % wave number

radius = M/2*delta; % the radius of illumination beam

x = linspace(-N/2*delta, N/2*delta, N); 
y = linspace(-M/2*delta, M/2*delta, M); 
[x,y] = meshgrid(x,y); % coordinates
phase = zeros(M,N); 

switch (method) % choose the scheme of area division
    case ('annular') % annular distribution
        select = zeros(M,N); 
        for j = 1:length(f)
            select = 1-select;
            if j~=length(f)
                select(x.^2+y.^2>(radius*ratio(j)).^2)=0;
                phase = phase-k*(x.^2+y.^2)/(2*f(j)).*select;
            else
                phase = phase-k*(x.^2+y.^2)/(2*f(j)).*select;
            end 
            
        end
        
    case ('sector') % sector distribution
        select = zeros(M,N);
        theta = pi/length(f);
        for j = 1:length(f)
            select = 1-select;
            select(atan(y./x)>-pi/2+theta*j)=0;
            phase = phase-k*(x.^2+y.^2)/(2*f(j)).*select;
        end
        
    case ('random') % random distribution
        select0 = unifrnd(0,1,M,N);
        interval = 1/length(f);
        s0 = 0; s1 = interval;
        for j = 1:length(f)
            select = zeros(M,N);
            select(select0>s0 & select0<=s1)=1;
            phase = phase-k*(x.^2+y.^2)/(2*f(j)).*select;
            s0 = s1; s1 = s1+interval;  
        end
        
    otherwise
        disp('Something wrong!');
end

phase = mod(phase, 2*pi); % 2pi range transformation

savePhase = mat2gray(phase); 

axes(handles.axes4); imshow(phase,[]); % show the phase design

NN = min(M,N); % determine the latter simulation dimension
xx=linspace(-1,1,NN);
[xx, yy] = meshgrid(xx, xx);
amplitude = mat2gray(exp(-(xx.^2+yy.^2)/0.5)); % gaussian amplitude distribution
pha = phase(M/2-NN/2+1:M/2+NN/2, N/2-NN/2+1:N/2+NN/2);
obj = amplitude.*exp(1i*pha); % complex amplitude

z = linspace(d2,800,100); % axial distance range of the simulation 
centralIntensity = zeros(1,length(z)); % central intensity of the diffraction field

if compensateOn==0 % the value of compensation flag
    % withou compensation
    for j = 1:length(z) 
        U2 = abs(AngularSpectrumPropagation(obj, delta, z(j), lambda));
        centralIntensity(j) = sum(sum(U2(end/2-2:end/2+2,end/2-2:end/2+2)));
        figure(1); imshow(U2,[]);

    end

else
    % with compensation of focusing lens and part to be processed
    obj = AngularSpectrumPropagation(obj, delta, d1, lambda); % diffraction from DOE to focusing lens 
    phaseLens = -k*(x.^2+y.^2)/(2*focalLength); % phase of focusing lens
    phaseLens = phaseLens(M/2-NN/2+1:M/2+NN/2, N/2-NN/2+1:N/2+NN/2);
    obj = obj.*exp(1i*phaseLens); % phase modulation of focusing lens
    obj = AngularSpectrumPropagation(obj, delta, d2-d1, lambda); % diffraction from focusing lens to part 
    lambdaNew = lambda/RI; % new wavelength inside the part
    for j = 1:length(z)
        U2 = abs(AngularSpectrumPropagation(obj, delta, z(j)-d2, lambdaNew));
        centralIntensity(j) = sum(sum(U2(end/2-2:end/2+2,end/2-2:end/2+2)));
        figure(1); imshow(U2,[]);
    end
    
end

axes(handles.axes8); 
plot(z,centralIntensity); % plot central intensities
set(gca,'FontSize',8);
grid on;
axis on;





function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
global lambda
lambda = str2double(get(hObject,'String')); 

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global lambda
lambda = str2double(get(hObject,'String'));




function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
global delta 
delta = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global delta 
delta = str2double(get(hObject,'String'));




function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
global N
N = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global N
N = str2double(get(hObject,'String'));



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
global M
M = str2double(get(hObject,'String'));
% disp(M)


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global M
M = str2double(get(hObject,'String'));



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
global f ratio
fociString = get(hObject,'String');

if fociString(end) ~= ' '
    fociString = [fociString,' '];
end

location = strfind(fociString,' ');
f = zeros(1,length(location));
n1=1;
for n = 1:length(location)
    f(n) = str2double(fociString(n1:location(n)-1));
    n1=location(n)+1;
end
% disp(f)
% if length(f) ~= length(ratio) 
%     disp("Error!!! Foci and ratio don't match!");
% end




% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global f ratio
fociString = get(hObject,'String');

if fociString(end) ~= ' '
    fociString = [fociString,' '];
end

location = strfind(fociString,' ');
f = zeros(1,length(location));
n1=1;
for n = 1:length(location)
    f(n) = str2double(fociString(n1:location(n)-1));
    n1=location(n)+1;
end
% disp(f)
% if length(f) ~= length(ratio) 
%     disp("Error!!! Foci and ratio don't match!");
% end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
global ratio

ratioString = get(hObject,'String');

if ratioString(end) ~= ' '
    ratioString = [ratioString,' '];
end

location = strfind(ratioString,' ');
ratio = zeros(1,length(location));
n1=1;
for n = 1:length(location)
    ratio(n) = str2double(ratioString(n1:location(n)-1));
    n1=location(n)+1;
end

% disp(ratio)

% if length(f) ~= length(ratio) 
%     disp("Error!!! Foci and ratio don't match!");
% end



% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global ratio

ratioString = get(hObject,'String');

if ratioString(end) ~= ' '
    ratioString = [ratioString,' '];
end

location = strfind(ratioString,' ');
ratio = zeros(1,length(location));
n1=1;
for n = 1:length(location)
    ratio(n) = str2double(ratioString(n1:location(n)-1));
    n1=location(n)+1;
end

% disp(ratio)

% if length(f) ~= length(ratio) 
%     disp("Error!!! Foci and ratio don't match!");
% end


% --- Executes during object deletion, before destroying properties.
function edit5_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global savePhase f method
str = num2str(f);
str(strfind(str,' '))='-';
imwrite(savePhase, [str,'-',method,'.bmp']);
disp('Phase pattern has been generated!');


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4
axis off


% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8
axis off


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global method
contents = cellstr(get(hObject,'String'));
method = contents{get(hObject,'Value')};
% disp(method);


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

global method
contents = cellstr(get(hObject,'String'));
method = contents{get(hObject,'Value')};
% disp(method);



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double

global focalLength
focalLength = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global focalLength
focalLength = str2double(get(hObject,'String'));




function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double
global d1
d1 = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global d1
d1 = str2double(get(hObject,'String'));


function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double
global d2
d2 = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global d2
d2 = str2double(get(hObject,'String'));



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

global RI
RI = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global RI
RI = str2double(get(hObject,'String'));

% --- Executes during object deletion, before destroying properties.
function axes13_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes13_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes13
imshow(imread('illustration.jpg'),[]);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5

global compensateOn
compensateOn = get(hObject,'Value');


% --- Executes during object creation, after setting all properties.
function togglebutton5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global compensateOn
compensateOn = get(hObject,'Value');
