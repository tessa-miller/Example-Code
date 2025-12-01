clc; clear; close all;

% Initial Conditions
m=1;q=1;dt=0.01;
x0 =[1,0,0];
v0 = [0.1,0.1,0.1];
n = 5000;

X = zeros([n,3]); %Matrix storing position data
X(1,:) = x0; %Set initial position
V = zeros([n,3]); %Matrix of velocity data
V(1,:) = v0; %Set initial velocity

alpha = q * dt / (2*m); 
%Alpha is something they use in the textbook, I think it's acceleration?



%Insight into how my code works for anyone reading (Rhett)... My code will
%use a loop, take the B-Field from the previous position we calculated in
%the loop, then use that to update the position.

for i=2:1:n
    B = B0(X(i-1,1),X(i-1,2),X(i-1,3)); %Calculate the field at current position
    d = V(i-1,:) + alpha * cross(V(i-1,:),B); %Calculate d in textbbok
    X(i,:) = X(i-1,:) + dt * d; %Get our new position
    C = B0(X(i,1),X(i,2),X(i,3)); %This is C in the textbook
    V(i,:) = (d + alpha * cross(d, C)+alpha^2*dot(C,d)*C)/(1+alpha^2*dot(C,C));
    %Above line gets our new velocity
end

plot3(X(:,1),X(:,2),X(:,3))
%Set a function to calculate the B-Field
function B_Field = B0(x ,y ,z)
    scale = 50 / (x^2 + y^2 + z^2)^(5/2); %This is stuff we multiply entire vector by
    B_Field = [scale * x *z, scale*y*z, scale*1/3*(2*z^2-x^2-y^2)]; %B field itself
end

