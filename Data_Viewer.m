%% Data Extraction
%read data into vectors t and v, time and force, respectively.
fileID=fopen('30_Jun_20 1414HRS.txt','r');
A=fscanf(fileID,'%f %f',[2 Inf]);
t=A(1,:)*1e5;
v=A(2,:);
array=[t;v];
%Plot the initial data as blue circles "bo" and best polynomial fit curve.
figure(1) %This tells MATLAB that this is the first figure.
plot(t,v,'bo') %curves(index,:) where index is the row number (each polynomial fit is a row) and : yields the vector at that row.
xlabel('time (sec)')
ylabel('Weight (cN)')
title('Data')
grid