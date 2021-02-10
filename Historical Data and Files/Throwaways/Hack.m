clear
close all;
% Copyright 2014 The MathWorks, Inc.
%% Create serial object for Arduino
s = serial('COM6','BaudRate',9600); % change the COM Port number as needed
%% Connect the serial port to Arduino
s.InputBufferSize = 16; % read only one byte every time
try
    fopen(s);
catch err
    fclose(instrfind);
    error('Make sure you select the correct COM Port where the Arduino is connected.');
end
while 1<2
    A=fscanf(s);
    B=str2num(A)
end