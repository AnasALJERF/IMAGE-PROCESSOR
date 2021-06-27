function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 26-Jun-2021 12:03:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ResimYukle.
function ResimYukle_Callback(hObject, eventdata, handles)
% hObject    handle to ResimYukle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im im2
 [filename , pathname] = uigetfile('*.*','Orginal');
 if filename ==0
   msgbox('bir resim seç','dikkat massaji','Error');
   return

 end
 
 im=imread([pathname , filename]);

 im = im2double(im);
 im2=im;
 axes(handles.axes1);
 imshow(im); title ('Orginal');

 info = imfinfo([pathname , filename]);
file_bytes = info.FileSize;

kb = file_bytes / 1024;

 set (handles.edit1,'string',pathname);
 set (handles.edit2,'string',kb);
 
  
% --- Executes on button press in Compression.
function Compression_Callback(hObject, eventdata, handles)
% hObject    handle to Compression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im
   res =im;
   for i=1:3
  % msgbox([num2str(i) ' .asama - Resim renk matrisi aliniyor...']);
   
   I = res(:,:,i);
   I= im2double(I);
   
   h = waitbar(0,'sikistirma islemi yapiliyor...');  
   waitbar (i/3,h);
   %DCT birim d?nü?üm matrisi
   T = dctmtx(8);
   
 % disp([num2str(i) ' .asama - DCT d?nü?ümü yapiliyor...']);
  %DCT d?nü?ümü
  B= blkproc(I,[8 8], 'P1*x*P2',T,T');
  
  %quantalama (nicemleme) maskesi
  mask =[1 1 1 1 0 0 0 0
		 1 1 1 0 0 0 0 0
		 1 1 0 0 0 0 0 0
		 1 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0];
		 
  %disp([num2str(i) ' .asama - Quantalama yapiliyor...']);
  %quantalama i?lemi
  B2 = blkproc(B, [8 8], 'P1.*x',mask);
  
 % disp([num2str(i) ' .asama - Ters DCT donusumu yapiliyor...']);
  %Ters DCT
  I2 = blkproc(B2,[8 8],'P1*x*P2' ,T',T);
  
  %RGB g?rüntü olu?turuluyor
  I3(:,:,i)= I2;
  
  diff(:,:,i)= I - I2;
  %disp([num2str(i) ' .asama - Tamamlandi']);
   
  if exist('h', 'var')
  delete(h);
  clear('h');
end
  
   end
  m = msgbox('sikistirma islemi Tamamlandi..');
%dosyaya yaz
imwrite(I3,'C:\Users\p.c\Desktop\imageCompress.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageCompress.jpg');
size = fileinfo.bytes;
kb = size / 1024;


   I3int= im2uint8(I3);
axes(handles.axes2);
 imshow(I3int); title ('compressed');
 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);
% --- Executes on button press in Enhencement.

if exist('m', 'var')
  delete(m);
  clear('m');
end



function Enhencement_Callback(hObject, eventdata, handles)
% hObject    handle to Enhencement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 %RGB = imread('C:\Users\p.c\Desktop\elaine.png');
%imshow(RGB)
 global im
e = imadjust(im,[.2 .3 0; .6 .7 1],[]);

   axes(handles.axes2);
 
imwrite(e,'C:\Users\p.c\Desktop\imageEnhancement.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageEnhancement.jpg');
size = fileinfo.bytes;
kb = size / 1024;
   axes(handles.axes2);
  imshow(e); title ('Enhancement');

 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);

% --- Executes on button press in ToGray.
function ToGray_Callback(hObject, eventdata, handles)
% hObject    handle to ToGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global im
   g = rgb2gray(im);
  
   imwrite(g,'C:\Users\p.c\Desktop\imageGray.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageGray.jpg');
size = fileinfo.bytes;
kb = size / 1024;
   axes(handles.axes2);
   imshow(g);title ('gray');

 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);
   %set (handles.edit4,'string',size);

% --- Executes on button press in Rotate90.
function Rotate90_Callback(hObject, eventdata, handles)
% hObject    handle to Rotate90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 global im
   r = imrotate(im , 90);
    axes(handles.axes2);
   imshow(r);
   imwrite(r,'C:\Users\p.c\Desktop\imageRotate.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageRotate.jpg');
size = fileinfo.bytes;
kb = size / 1024;
   axes(handles.axes2);
   imshow(r);title ('Rotate 90');

 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);
% --- Executes on button press in Reast.
function Reast_Callback(hObject, eventdata, handles)
% hObject    handle to Reast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset'); 
cla(handles.axes2,'reset');
 set (handles.edit1,'string','-');
 set (handles.edit2,'string','-');
 set (handles.edit3,'string','-');
 set (handles.edit4,'string','-');
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ToGray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ToGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
   BW = im2bw(im);
  imshow(BW);title ('balck & white');
  
   imwrite(BW,'C:\Users\p.c\Desktop\imageBW.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageBW.jpg');
size = fileinfo.bytes;
kb = size / 1024;
   axes(handles.axes2);
   imshow(BW);title ('balck & white');

 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
   red = (im);
  red(:,:,2:3)=0;
   imwrite(red,'C:\Users\p.c\Desktop\imageRed.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageRed.jpg');
size = fileinfo.bytes;
kb = size / 1024;
   axes(handles.axes2);
   imshow(red);title ('Red');

 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
   green = (im);
  green(:,:,1)=0;
    green(:,:,3)=0;
   imwrite(green,'C:\Users\p.c\Desktop\imageGreen.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageGreen.jpg');
size = fileinfo.bytes;
kb = size / 1024;
   axes(handles.axes2);
   imshow(green);title ('green');

 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
  % blue =rgb2ycbcr (im);
    blue = (im);
  blue(:,:,1)=0;
    blue(:,:,2)=0;
   imwrite(blue,'C:\Users\p.c\Desktop\imageBlue.jpg','jpg');
fileinfo = dir('C:\Users\p.c\Desktop\imageBlue.jpg');
size = fileinfo.bytes;
kb = size / 1024;
   axes(handles.axes2);
   imshow(blue);title ('Blue');

 path = 'C:\Users\p.c\Desktop';
 set (handles.edit3,'string',path);
 set (handles.edit4,'string',kb);
