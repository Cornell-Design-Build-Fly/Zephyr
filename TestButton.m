% Create GUI
h.fig = figure();
h.but1 = uicontrol(h.fig,'Style','PushButton','Units','Normalize','Position',[.1,.8,.2,.1],'String','Go');
h.but2 = uicontrol(h.fig,'Style','PushButton','Units','Normalize','Position',[.1,.6,.2,.1],'String','Stop');
h.but2Val = false;  % Default stop-button-off
guidata(h.fig, h)
h.but1.Callback = {@button1CallbackFcn,h};
h.but2.Callback = {@button2CallbackFcn,h};
function button1CallbackFcn(hObj,event,handles)
% Responds to "go" button; counts to 1000 in command window
c = 1;
commandwindow()
while c < 1000
    pause(0.1)
    handles = guidata(hObj.Parent);
    
    % Check if STOP buttons has been pressed
    if handles.but2Val
        c = 1000;                 % Short circuit the while-loop
        handles.but2Val = false;  % reset stop-button to off
        guidata(hObj.Parent,handles)
        continue                  % skip the rest of this loop
    end
    
    disp(c)
    c = c+1;
end
end
function button2CallbackFcn(hObj,event,handles)
% Responds to "stop" button.  Toggles the but2Val to TRUE
handles.but2Val = true; 
guidata(hObj.Parent, handles)
end