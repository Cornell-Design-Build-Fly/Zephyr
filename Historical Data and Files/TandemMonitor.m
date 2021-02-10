%% Functioning Serial Monitor for Arduino
% The following program receives serial data from an Arduino microprocessor
% and displays the incoming numerical data as a live plot of value over
% time.
%
% In this specific case, the program is designed to interpret distance from
% a HC-SR04 Ultrasonic Sensor. The Arduino must be programmed to output
% only the numerical value of distance, at intervals of at least 50
% milliseconds.
%% Clear the workspace and close all figures
clear
close all;
%% Create serial object for Arduino
s = serial('COM3','BaudRate',9600); % change the COM Port number as needed
%% Connect the serial port to Arduino
s.InputBufferSize = 16;
try
    fopen(s);
catch err
    fclose(instrfind);
    error('Make sure you select the correct COM Port where the Arduino is connected.');
end

%% Create a figure window to monitor the live data
% As a time of flight sensor, the time interval between the initial pulse
% and the reception of the return pulse of ultrasound is used to calculate
% the distance using the formula:
% 
% $x=\frac{vt}{2}$ where $v\approx300m/s$
% 
Tmax = inf; % Total time for data collection (s) (Use CTRL+C to Exit)
figure
h = animatedline;
g = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
while ~stop
    A=[];
    while length(A)==0|isa(A,'char')|size(A)~=2
        A=fscanf(s,'%f') % Read Distance Value from Serial
    end
    t =  datetime('now') - startTime; % Get current time
    addpoints(h,datenum(t),A(1)) % Add points to animation
    addpoints(g,datenum(t),A(2))
    [xdata1,ydata1]=getpoints(h);
    [xdata2,ydata2]=getpoints(g);
    ax.XLim = datenum([t-seconds(15) t]); % Update axes
    datetick('x','keeplimits')
    drawnow
end
% data=[xdata2;ydata2,xdata2,ydata2];
% fileID = fopen('Short.txt','w');
% fprintf(fileID, 'Test1\n\n');
% fprintf(fileID,'%f %f\n',data);
% fclose(fileID);