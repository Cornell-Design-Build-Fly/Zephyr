clear;
arduinoObj = arduino('COM6','Uno','Libraries','Ultrasonic')
ultrasonicObj = ultrasonic(arduinoObj,'D2','D3')

Tmax = inf; % Total time for data collection (s) (Use CTRL+C to Exit)
figure,
grid on,
xlabel ('Time (s)'), ylabel('Distance (m)'),
axis([0 10 0 2]),  %Edit this for the graph's initial axis ranges
%% Read and plot the data from Arduino
Ts = 0.02; % Sampling time (s)
i = 0;
data = 0;
t = 0;
tic % Start timer
while toc <= Tmax
    i = i + 1;
    %% Read buffer data
    data(i)=readDistance(ultrasonicObj);
    %% Read time stamp
    % If reading faster than sampling rate, force sampling time.
    % If reading slower than sampling rate, nothing can be done. Consider
    % decreasing the set sampling time Ts
    t(i) = toc;
    if i > 1
        T = toc - t(i-1);
        while T < Ts
            T = toc - t(i-1);
        end
    end
    t(i) = toc;
    %% Plot live data
    if i > 1
        line([t(i-1) t(i)],[data(i-1) data(i)], 'LineWidth', 2)
        drawnow
    if toc>10
        axis([toc-10 toc 0 2]) %This gives the tracking x-axis
    end
    end
end