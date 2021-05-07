%% Functioning Serial Monitor for Arduino
% The following program receives serial data from an Arduino microprocessor
% and displays the incoming numerical data as a live plot of value over
% time.
%% Clear the workspace and close all figures
clear all
close all;
%% Create serial object for Arduino
s = serialport("COM6",115200); % change the COM Port number as needed
configureTerminator(s,"CR")

%% Create a figure window to monitor the live data
% As a time of flight sensor, the time interval between the initial pulse
% and the reception of the return pulse of ultrasound is used to calculate
% the distance using the formula:
% 
% $x=\frac{vt}{2}$ where $v\approx300m/s$
% 
% try
Tmax = inf; % Total time for data collection (s) (Use CTRL+C to Exit)
figure(1)
athena = animatedline('Color','r','LineWidth',3);
ax1 = gca;
ax1.YGrid = 'on';
ax1.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
datetick('x','MM:SS','keeplimits')
figure(2)
minerva = animatedline('Color','g','LineWidth',3);
ax2 = gca;
ax2.YGrid = 'on';
ax2.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
datetick('x','MM:SS','keeplimits')
figure(3)
ares = animatedline('Color','b','LineWidth',3);
ax3 = gca;
ax3.YGrid = 'on';
ax3.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
datetick('x','MM:SS','keeplimits')
figure(4)
mars = animatedline('Color','c','LineWidth',3);
ax4 = gca;
ax4.YGrid = 'on';
ax4.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
datetick('x','MM:SS','keeplimits')
figure(5)
jupiter = animatedline('Color','m','LineWidth',3);
ax5 = gca;
ax5.YGrid = 'on';
ax5.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
datetick('x','MM:SS','keeplimits')
figure(6)
neptune = animatedline('Color','y','LineWidth',3);
ax6 = gca;
ax6.YGrid = 'on';
ax6.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
datetick('x','MM:SS','keeplimits')
figure(7)
pluto = animatedline('Color','k','LineWidth',3);
ax7 = gca;
ax7.YGrid = 'on';
ax7.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
startTime = datetime('now');
datetick('x','MM:SS','keeplimits')
flush(s) % Serial Buffer may overload during startup, this clears data.
disp("Data Flush")
linkaxes([ax1 ax2 ax3 ax4 ax5 ax6 ax7],'x')

while ~stop
    numBytes=0;
    while numBytes==0%|isa(A,'char')|size(A)~=2
        numBytes = s.NumBytesAvailable;
    end
    A=str2num(readline(s)); % Read Distance Value from Serial
    t =  datetime('now') - startTime; % Get current time
    addpoints(athena,datenum(t),A(1)) % Add points to animation
    addpoints(minerva,datenum(t),A(2))
    addpoints(ares,datenum(t),A(3)) % Add points to animation
    addpoints(mars,datenum(t),A(4))
    addpoints(jupiter,datenum(t),A(5)) % Add points to animation
    addpoints(neptune,datenum(t),A(6))
    addpoints(pluto,datenum(t),A(7)) % Add points to animation
    ax1.XLim = datenum([t-seconds(15) t]); % Update axes
    for i=1:7
        figure(i)
        datetick('x','MM:SS','keeplimits')
    end
    drawnow
end
% catch
    [xdata1,ydata1]=getpoints(athena);
    [xdata2,ydata2]=getpoints(minerva);
    [xdata3,ydata3]=getpoints(ares);
    [xdata4,ydata4]=getpoints(mars);
    [xdata5,ydata5]=getpoints(jupiter);
    [xdata6,ydata6]=getpoints(neptune);
    [xdata7,ydata7]=getpoints(pluto);
% data=[xdata2;ydata2,xdata2,ydata2];
% fileID = fopen('Short.txt','w');
% fprintf(fileID, 'Test1\n\n');
% fprintf(fileID,'%f %f\n',data);
% fclose(fileID);
% disp("Data Successfully Captured")
% end