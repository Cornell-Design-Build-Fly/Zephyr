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
try
Tmax = inf; % Total time for data collection (s) (Use CTRL+C to Exit)
f=figure();
% f.but2 = uicontrol(h.fig,'Style','PushButton','Units','Normalize','Position',[.1,.6,.2,.1],'String','Save');
% f.but2Val = false;  % Default stop-button-off
athena = animatedline('Color','r','LineWidth',3);
minerva = animatedline('Color','g','LineWidth',3);
ares = animatedline('Color','b','LineWidth',3);
mars = animatedline('Color','c','LineWidth',3);
jupiter = animatedline('Color','m','LineWidth',3);
neptune = animatedline('Color','y','LineWidth',3);
pluto = animatedline('Color','k','LineWidth',3);
ax1 = gca;
ax1.YGrid = 'on';
ax1.YLim = [-750 750];
xlabel ('Time (s)'), ylabel('Force (10^-2 N)'),
stop = false;
datetick('x','MM:SS','keeplimits')
flush(s) % Serial Buffer may overload during startup, this clears data.
disp("Data Flush")
line_array=[minerva ares mars jupiter neptune pluto];
data=[];
startTime = datetime('now');
while ~stop
    while s.NumBytesAvailable==0%|isa(A,'char')|size(A)~=2
    end
    A=str2num(readline(s)); % Read Distance Value from Serial
    t =  datetime('now') - startTime; % Get current time
    tmp=seconds(t);
    data=[data; [seconds(t) A]];
    addpoints(athena,datenum(t),A(1)) % Add points to animation
    addpoints(minerva,datenum(t),A(2))
    addpoints(ares,datenum(t),A(3)) % Add points to animation
    addpoints(mars,datenum(t),A(4))
    addpoints(jupiter,datenum(t),A(5)) % Add points to animation
    addpoints(neptune,datenum(t),A(6))
    addpoints(pluto,datenum(t),A(7)) % Add points to animation
    ax1.XLim = datenum([t-seconds(15) t]); % Update axes
    datetick('x','MM:SS','keeplimits')
    drawnow
end
catch err
    %fileID = fopen(""+datestr(now,'dd_mmm_yy HHMM')+"HRS.txt",'w');
    csvwrite(""+datestr(now,'dd_mmm_yy HHMM')+"HRS.csv",data)
%     fprintf(fileID, 'Test1\n\n');
%     fprintf(fileID,'%f %f %f %f %f %f %f %f %f\n',data);
    %fclose(fileID);
    disp("Data Successfully Captured")
    disp("Program Ended")
end

% % Create GUI
% h.fig = figure();
% h.but1 = uicontrol(h.fig,'Style','PushButton','Units','Normalize','Position',[.1,.8,.2,.1],'String','Sa');
% 
% h.but2Val = false;  % Default stop-button-off
% guidata(h.fig, h)
% h.but1.Callback = {@button1CallbackFcn,h};
% h.but2.Callback = {@button2CallbackFcn,h};
% function button1CallbackFcn(hObj,event,handles)
% % Responds to "go" button; counts to 1000 in command window
% c = 1;
% commandwindow()
% while c < 1000
%     pause(0.1)
%     handles = guidata(hObj.Parent);
%     
%     % Check if STOP buttons has been pressed
%     if handles.but2Val
%         c = 1000;                 % Short circuit the while-loop
%         handles.but2Val = false;  % reset stop-button to off
%         guidata(hObj.Parent,handles)
%         continue                  % skip the rest of this loop
%     end
%     
%     disp(c)
%     c = c+1;
% end
% end
% function button2CallbackFcn(hObj,event,handles)
% % Responds to "stop" button.  Toggles the but2Val to TRUE
% handles.but2Val = true; 
% guidata(hObj.Parent, handles)
% end

% function my_closereq(src,event)
% % Close request function 
% % to display a question dialog box 
%    selection = questdlg('Close This Figure?',...
%       'Close Request Function',...
%       'Yes','No','Yes'); 
%    switch selection 
%       case 'Yes'
%           try
%           data=guidata(src);
% %           for i=line_array
% %          [xdata,ydata]=getpoints(i);
% %          data=[data xdata ydata];
% %           end
%         fileID = fopen(""+datestr(now,'dd_mmm_yy HHMM')+"HRS.txt",'w');
%         fprintf(fileID, 'Test1\n\n');
%         fprintf(fileID,'%f %f\n',data);
%         fclose(fileID);
%         disp("Data Successfully Captured")
%          delete(gcf)
%           catch err
%               delete(gcf)
%           end
%       case 'No'
%       delete(gcf)
%    end
% end