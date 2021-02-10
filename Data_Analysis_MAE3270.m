 %% MATLAB Automatic Wind Tunnel Data Analysis
% A script designed to read values from a .txt file whose first column is
% time and second column is force in Newtons x 10^-2. The inputs required
% are the time intervals to perform time averaging of the forces in each
% interval matrix (each pair of numbers is t0, tf). These can be found
% using Data Viewer and selecting the first and last data points of the
% data at a certain speed in the wind tunnel.
% 
% Currently, the speeds are correlated to the data through the frequency of
% the wind tunnel fan's inverter. The speed matrix has the frequency of the
% inverter in one column and wind speeds in m/s in the other.

%% Clear Workspace and Instantiate Inputs
clear
close all;
TestForceFileID="30_Jun_20 1414HRS.txt"; %File name of test object force data
% Test Object Time Intervals (Ascending, 10 Hz to 60 Hz in 5 Hz intervals)
time_int=[20 30; 35 44; 60 70; 75 85; 95 105; 115 125; 130 140; 145 155; 165 175; 205 215; 252 262; 273 283; 289 299];
% Deformation Data (Ascending, 10 Hz to 60 Hz in 5 Hz intervals)
deform=[3 6 8 13 18 23 28 33 38 43 48 53 58];
%% Test Object Data Analysis
% This section takes the force data of the test object.
%
% *Data Extraction*
fileID=fopen(TestForceFileID,'r');
A=fscanf(fileID,'%f %f',[2 Inf]);
t=A(1,:);
f=A(2,:);
test_arr=[t;f];
%%
% *Raw Data Plotting*
figure(3)
plot(t,f,'bo') %curves(index,:) where index is the row number (each polynomial fit is a row) and : yields the vector at that row.
xlabel('Time (sec)')
ylabel('Force (10^{-2} N)')
temp_title=['Raw Data, ',extractBefore(TestForceFileID,".txt")];
title(convertStringsToChars("Raw Data, "+extractBefore(TestForceFileID,".txt"))) % Automatic Graph Names
grid
axis([0 Inf 0 Inf])
%%
% *Time Averaging and Uncertainty Calculation for Force versus Velocity*
data=[];
for i=1:length(time_int) % For each frequency/wind speed tested
    t0=time_int(i,1); % Starting time coordinate
    tf=time_int(i,2); % Ending time coordinate
    [~, idx1]=min(abs(test_arr(1,:)-t0)); % Find index of closest time coordinate to t0
    [~, idx2]=min(abs(test_arr(1,:)-tf)); % Find index of closest time coordinate to tf
    subarray=test_arr(:,idx1:idx2); % Subarray contains all the values between, to be time averaged
    avg=mean(subarray(2,:)); % Calculate the mean force value
    unc=std(subarray(2,:)); % Calculate the uncertainty in force value as the standard deviation
    data=[data,[avg;unc]];
end
%%
% *Data Plotting, Force versus Time*
figure(4)
data=[deform;data];
errorbar(data(1,:),data(2,:),data(3,:),'--b','LineWidth',1);
xlabel('Deformation')
ylabel('Force (10^{-2} N)')
title(convertStringsToChars("Force vs Displacement")) % Automatic Graph Names
grid
axis([0 Inf 0 Inf])

p1 = polyfit(deform, data,1);
xval=(min(strain_A(1:5)):0.001:max(strain_A(1:5)));
yval=polyval(p1,xval);
plot(xval,yval,'g','LineWidth',2)
grid