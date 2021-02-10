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
NullForceFileID="Threaded Sting Null Force.txt"; %File name of sting only force data
TestForceFileID="Large Garbage Banner.txt"; %File name of test object force data
% Sting Only Time Intervals (Ascending, 10 Hz to 60 Hz in 5 Hz intervals)
null_int=[586.8 601.5;610.5 628.1;634.3 653.8;660 680.1; 686.7 708.9;715.3 738.1;744.6 768.6;774.7 805.5; 811.6 841.5;442.1 474.3;481.4 518.8];
% Test Object Time Intervals (Ascending, 10 Hz to 60 Hz in 5 Hz intervals)
test_int=[38 46.1; 63.3 79.6; 80.9 117; 126.5 157.2; 164 189.9; 206.1 234.4; 241 269.6; 275.2 319.6; 327.1 356.1; 363.5 404.5; 411.2 442.3];
% Anemometer Data (Ascending, 10 Hz to 60 Hz in 5 Hz intervals)
speeds=[10 15 20 25 30 35 40 45 50 55 60;5.68 7.62 10.43 13.10 16.48 19.47 22.59 25.84 28.25 31.05 34.40];
%% Null Force Data Analysis
% This section takes the force data of just the sting, so that it may be
% subtracted from the force data of test objects.
%
% *Data Extraction*
fileID=fopen(NullForceFileID,'r');
A=fscanf(fileID,'%f %f',[2 Inf]);
x=A(1,:)*1e5;
y=A(2,:);
null_arr=[x;y];
%%
% *Raw Data Plotting*
figure(1) %This tells MATLAB that this is the first figure.
plot(x,y,'ro') %curves(index,:) where index is the row number (each polynomial fit is a row) and : yields the vector at that row.
xlabel('Time (sec)')
ylabel('Force (10^{-2} N)')
title("Raw Data, Sting Only")
grid
axis([0 Inf 0 Inf])
%%
% *Time Averaging and Uncertainty Calculation for Force versus Velocity*
null=[];
for i=1:length(null_int) % For each frequency/wind speed tested
    t0=null_int(i,1); % Starting time coordinate
    tf=null_int(i,2); % Ending time coordinate
    [~, idx1]=min(abs(null_arr(1,:)-t0)); % Find index of closest time coordinate to t0
    [~, idx2]=min(abs(null_arr(1,:)-tf)); % Find index of closest time coordinate to tf
    subarray=null_arr(:,idx1:idx2); % Subarray contains all the values between, to be time averaged
    avg=mean(subarray(2,:)); % Calculate the mean force value
    unc=std(subarray(2,:)); %Calculate the uncertainty in force value as the standard deviation
    null=[null,[avg;unc]];
end
%%
% *Data Plotting, Force versus Time*
figure(2)
null=[speeds;null];
errorbar(null(2,:),null(3,:),null(4,:),'--r','LineWidth',1);
xlabel('Velocity (m/s)')
ylabel('Force (10^{-2} N)')
title("Force vs Velocity, Sting Only")
grid
axis([0 Inf 0 Inf])

%% Test Object Data Analysis
% This section takes the force data of the test object.
%
% *Data Extraction*
fileID=fopen(TestForceFileID,'r');
A=fscanf(fileID,'%f %f',[2 Inf]);
t=A(1,:)*1e5;
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
for i=1:length(test_int) % For each frequency/wind speed tested
    t0=test_int(i,1); % Starting time coordinate
    tf=test_int(i,2); % Ending time coordinate
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
data=[speeds;data];
data(3,:)=data(3,:)-null(3,:);
errorbar(data(2,:),data(3,:),data(4,:),'--b','LineWidth',1);
xlabel('Velocity (m/s)')
ylabel('Force (10^{-2} N)')
title(convertStringsToChars("Force vs Velocity, "+extractBefore(TestForceFileID,".txt"))) % Automatic Graph Names
grid
axis([0 Inf 0 Inf])