clear
close all;
% Copyright 2014 The MathWorks, Inc.
%% Create serial object for Arduino
s = serial('COM3','BaudRate',9600); % change the COM Port number as needed
%% Connect the serial port to Arduino
s.InputBufferSize = 16; % read only one byte every time
try
    fopen(s);
catch err
    fclose(instrfind);
    error('Make sure you select the correct COM Port where the Arduino is connected.');
end
%% Create a figure window to monitor the live data
Tmax = inf; % Total time for data collection (s) (Use CTRL+C to Exit)
figure,
grid on,
xlabel ('Time (s)'), ylabel('Distance (m)'),
%Edit this for the graph's initial axis ranges
%% Read and plot the data from Arduino
i = 0;
data = 0;
t = 0;
tic % Start timer
while toc <= Tmax
    i = i + 1;
    %% Read buffer data
    A=str2num(fscanf(s));
    disp(A)
    if(size(A)>0)
        t(i)=A(1);
        data(i)=A(2);
    end
    %% Plot live data
    if i > 1
       line([t(i-1) t(i)],[data(i-1) data(i)], 'LineWidth', 2)
       drawnow
    if size(t)>1000
       axis([t(i) t(i-100) 0 2]) %This gives the tracking x-axis
    end
    end
end
fclose(s);
