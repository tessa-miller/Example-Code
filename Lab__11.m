close all; clear; clc;
%Start with variables and meshgrid
a = 7.45; %Length of room in x
b = 6; %Length of room in y
A = 1; %Amplitude
x = linspace(0,a,100); %x dimension pooints
y = linspace(0,b,100); %y dimension points
fps = 30;
duration = 30;
t = linspace(0,duration,duration*fps);
[X,Y] = meshgrid(x,y); %Do the actual meshgrid

%And now we set up the video
vid = VideoWriter('sum_of_six_modes','MPEG-4'); %This sets up the video to write to a file
open(vid) %I believe this is what actually starts the recording

modes = [1,1;
         2,1;
         2,2;
         1,3;
         2,3;
         3,3;]; %These are the fundamental modes of the function
%Now we set up a loop to sum our modes
for  ti=1:length(t)
    %Set up something to hold our total solution
    Z_tot = zeros(size(X));
    %Now we set up a for loop to sum all of the modes
    for n=1:1:6
        w = 2*pi*sqrt((modes(n,1)/a)^2 + (modes(n,2)/b)^2); %Set up omega
        %Set up our z function
        Z = A*cos(modes(n,1)*pi*X/a).*cos(modes(n,2)*pi*Y/b)*sin(w*t(ti));
        Z_tot = Z_tot + Z; %Add that to our total
    end
    %Plotting 2 Electric Boogaloo
    surf(X,Y,Z_tot,"EdgeColor","none")
    title('Summed Modes')
    xlabel('x')
    ylabel('y')
    zlabel('Amplitude')
    zlim([-5,5])
    view(3);
    %And write that plot to the video
    writeVideo(vid,getframe(gcf))
end
close(vid)