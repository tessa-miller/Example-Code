close all; clear; clc;

%Create several functions to make keeping track of things easier
function [Hxy] = Lab_15_trans(Gxy,Gxx) %Transfer Function
   Hxy = Gxy./Gxx;
end

function [hxy] = Lab_15_impulse(Hxy) %Impulse Response
   hxy = abs(fftshift(ifft(Hxy)));
end

function [C] = Lab_15_coherence(Gxy,Gxx,Gyy) %Coherence
   C = sqrt(abs(Gxy).^2./(Gxx.*Gyy));
end

%And now we move to the main body of work. Starting with defining variables
%we'll use throughout the entire section
fs = 204800; %Sampling rate
ns = 2^(15); %Number of samples used in averaging the data
%Note on reading the assignment. When it says [Gyx,fyx] = (mic_1,mic_2,...)
%What it means is that mic_1 is the y
%% No Cover Section %%
%First load the sounds into arrays
l_mic_1 = binfileload('C:\Users\lilli\Documents\MATLAB\Lab_15_files','ID',18,00);
r_mic_1 = binfileload('C:\Users\lilli\Documents\MATLAB\Lab_15_files','ID',18,01);
%Get the number of elements in these arrays
N1 = numel(r_mic_1);
%Get all the cross and auto correlations that we need
[Glr_1,flr_1] = crossspec(l_mic_1,r_mic_1,fs,ns,N1,1);
[Gll_1,fll_1] = autospec(l_mic_1,fs,ns,N1,1);
[Grr_1,frr_1] = autospec(r_mic_1,fs,ns,N1,1);

%% Windscreen Cover Section %%
%First load the sounds into arrays
l_mic_2 = binfileload('C:\Users\lilli\Documents\MATLAB\Lab_15_files','ID',28,00);
r_mic_2 = binfileload('C:\Users\lilli\Documents\MATLAB\Lab_15_files','ID',28,01);
%Get the number of elements in these arrays
N2 = numel(r_mic_2);
%And now get all our auto and cross correlations
[Glr_2,flr_2] = crossspec(l_mic_2,r_mic_2,fs,ns,N2,1);
[Gll_2,fll_2] = autospec(l_mic_2,fs,ns,N2,1);
[Grr_2,frr_2] = autospec(r_mic_2,fs,ns,N2,1);

%% Foam Ball Cover Section %%
%First load the soinds into arrays
l_mic_3 = binfileload('C:\Users\lilli\Documents\MATLAB\Lab_15_files','ID',58,00);
r_mic_3 = binfileload('C:\Users\lilli\Documents\MATLAB\Lab_15_files','ID',58,01);
%Get the number of elements in these arrays
N3 = numel(r_mic_3);
%And now get all our auto and cross correlations
[Glr_3,flr_3] = crossspec(l_mic_3,r_mic_3,fs,ns,N3,1);
[Gll_3,fll_3] = autospec(l_mic_3,fs,ns,N3,1);
[Grr_3,frr_3] = autospec(r_mic_3,fs,ns,N3,1);
%% Transfer Function Section %%

Hxy1 = Lab_15_trans(Glr_1,Gll_1); %Transfer Function for unscreened
Hxy2 = Lab_15_trans(Glr_2,Gll_2); %Transfer Function for windscreen
Hxy3 = Lab_15_trans(Glr_3,Gll_3); %Transfer Function for Ball
%I don't know why I'm still obsessed with Morbius. But it's PLOtting time!
semilogx(flr_1,20*log10(abs(Hxy1)),...
    flr_2,20*log10(abs(Hxy2./Hxy1)),...
    flr_3,20*log10(abs(Hxy3./Hxy1)))
xlabel('Frequency (Hz)')
ylabel('dB')
title('Fig 1:Transfer Functions')
legend('No Cover','Professional Windscreen', 'Foam Ball')

%% Impulse Response %%
hxy1 = Lab_15_impulse(Hxy1);
hxy2 = Lab_15_impulse(Hxy2);
hxy3 = Lab_15_impulse(Hxy3)/100;
t1 = ((-length(hxy1)/2:length(hxy1)/2 - 1) / fs)*1000;  % time vector centered around 0
t2 = ((-length(hxy2)/2:length(hxy2)/2 - 1) / fs)*1000;
t3 = ((-length(hxy3)/2:length(hxy3)/2 - 1) / fs)*1000;
figure
plot(t1,hxy1,t2,hxy2,t3,hxy3)
xlabel('Time (ms)')
ylabel('Impulse Response Magnitude')
legend('No Cover', 'Professional Windscreen', 'Foam Ball')
title('Fig 2: Impulse Response')

%% Coherence %%
C1 = Lab_15_coherence(Glr_1,Gll_1,Grr_1);
C2 = Lab_15_coherence(Glr_2,Gll_2,Grr_2);
%C3 = Lab_15_coherence(Glr_3,Gll_3,Grr_3);

figure
semilogx(flr_1,C1,fll_2,C2)
xlabel('Frequency (Hz)')
ylabel('Coherence')
legend('No Screen', 'Professional', 'Foam Ball')
title('Fig 3: Coherence')

%% Convolutions With Rocket Noise %%
%First load up the rocket sound
rocket = binfileload('C:\Users\lilli\Documents\MATLAB\Lab_15_files','ID',20,12);
y1 = conv(rocket, hxy1, 'same');  % no cover
y2 = conv(rocket, hxy2, 'same');  % professional cover
y3 = conv(rocket, hxy3, 'same');  % foam ball
t = (0:length(rocket)-1)/fs;
figure
plot(t,y1,t,y2,t,y3)
xlabel('Time (s)')
ylabel('Amplitude')
legend('No cover', 'Professional Windscreen', 'Foam Ball')
title('Fig 4: Convolved Rocket Noise')