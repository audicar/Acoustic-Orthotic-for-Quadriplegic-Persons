% biotron lab week 11
clear;
clf;
% acoustic orthotic lab
% acoustic_orthotic.m
% traverse a maze with voice commands only
% up, down, left, right
% first learn the sounds of the four commands
% these will be used as templates from which to identify the commands
% read a sound into matlab

% r = audiorecorder(22050,16,1);
% disp('say Up.');
% recordblocking(r, 2); % read a 2s sound clip
% disp('End of recording. Playing back ...');
% play(r); % one way to play the sound
% up = getaudiodata(r, 'double'); % get data as double array
% % read the second sound into matlab
% disp('say Down.');
% recordblocking(r, 2); % read a 2s sound clip
% disp('End of recording. Playing back ...');
% play(r);
% down = getaudiodata(r, 'double'); % get data as double array
% % read the third sound into matlab
% disp('say Left.');
% recordblocking(r, 2); % read a 2s sound clip
% disp('End of recording. Playing back ...');
% %play(r);
% left = getaudiodata(r, 'double'); % get data as double array
% % read the fourth sound into matlab
% disp('say Right.');
% recordblocking(r, 2); % read a 2s sound clip
% disp('End of recording. Playing back ...');
% %play(r);
% right = getaudiodata(r, 'double'); % get data as double array

up = load('up.mat').up;
down = load('down.mat').down;
left = load('left.mat').left;
right = load('right.mat').right;

t = linspace(0,2,44100);
figure(1);
subplot(4,1,1);
plot(t,up); grid on;
title("Up");
subplot(4,1,2);
plot(t,down); grid on;
title("Down")
subplot(4,1,3);
plot(t,left); grid on;
title("Left")
subplot(4,1,4);
plot(t,right); grid on;
title("Right")
sgtitle("Raw sound data");


up_norm = up./max(abs(up));
down_norm = down./max(abs(down));
left_norm = left./max(abs(left));
right_norm = right/max(abs(right));
% 
fs = length(t)/2;
[b1 a1] = butter(3,140/(fs/2),'high');
up_norm = filter(b1,a1,(up_norm));
down_norm = filter(b1,a1,(down_norm));
left_norm = filter(b1,a1,(left_norm));
right_norm = filter(b1,a1,(right_norm));

figure(2);
subplot(4,1,1);
plot(t,up_norm); grid on; xlabel("Time (s)"); ylabel("Normalised Amplitude");
title("Up")
subplot(4,1,2);
plot(t,down_norm); grid on; xlabel("Time (s)"); ylabel("Normalised Amplitude");
title("Down")
subplot(4,1,3);
plot(t,left_norm); grid on; xlabel("Time (s)"); ylabel("Normalised Amplitude");
title("Left")
subplot(4,1,4);
plot(t,right_norm); grid on; xlabel("Time (s)"); ylabel("Normalised Amplitude");
title("Right")
sgtitle("Normalised sound data");
grid on;

% envelope
fs = length(t)/2;
[b a] = butter(6,50/(fs/2));
up_e = filter(b,a,abs(up_norm));
down_e = filter(b,a,abs(down_norm));
left_e = filter(b,a,abs(left_norm));
right_e = filter(b,a,abs(right_norm));


figure(3);
subplot(4,1,1);
plot(t,up_e); grid on;
title("Up")
subplot(4,1,2);
plot(t,down_e); grid on;
title("Down")
subplot(4,1,3);
plot(t,left_e); grid on;
title("Left")
subplot(4,1,4);
plot(t,right_e); grid on;
title("Right")
sgtitle("Envelope of sound data");
grid on;

% spectrum
up_spect = abs(fft(up_norm));
down_spect = abs(fft(down_norm));
left_spect = abs(fft(left_norm));
right_spect = abs(fft(right_norm));
freq = (0:44099)./(44100/fs);
figure(4);
subplot(4,1,1); plot(freq,up_spect); grid on; title("Up"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
subplot(4,1,2); plot(freq,down_spect); grid on; title("Down"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
subplot(4,1,3); plot(freq,left_spect); grid on; title("Left"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
subplot(4,1,4); plot(freq,right_spect); grid on; title("Right"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
sgtitle("FFT of sound data");

% low pass filter to fft
[b a] = butter(6,50/(fs/2));
up_spect = filter(b,a,abs(up_spect));
down_spect = filter(b,a,abs(down_spect));
left_spect = filter(b,a,abs(left_spect));
right_spect = filter(b,a,abs(right_spect));

figure(5);
subplot(4,1,1); plot(freq,up_spect); grid on; title("Up"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
subplot(4,1,2); plot(freq,down_spect); grid on; title("Down"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
subplot(4,1,3); plot(freq,left_spect); grid on; title("Left"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
subplot(4,1,4); plot(freq,right_spect); grid on; title("Right"); xlim([0 10000]);
xlabel("Frequency (Hz)"); ylabel("Amplitude");
sgtitle("FFT of sound data with low pass filter");

%spectrogram
figure(6);
subplot(2,2,1); spectrogram(up_norm,kaiser(128,18),120,128); title("Up");
subplot(2,2,2); spectrogram(down_norm,kaiser(128,18),120,128); title("Down");
subplot(2,2,3); spectrogram(left_norm,kaiser(128,18),120,128); title("Left");
subplot(2,2,4); spectrogram(right_norm,kaiser(128,18),120,128); title("Right");

%disting
r = audiorecorder(22050,16,1);
disp('say command.');
recordblocking(r, 2); % read a 2s sound clip
voi_norm = getaudiodata(r, 'double'); % get data as double array

fs = length(t)/2;
[b1 a1] = butter(3,140/(fs/2),'high');
voi_norm = filter(b1,a1,(voi_norm));

command = getMyCommand(voi_norm);

figure(7);
plot(t,voi_norm); grid on;
sgtitle("Raw sound data");

figure(8);
voi_norm1 = voi_norm/max(abs(voi_norm));
plot(t,voi_norm1); grid on;
sgtitle("Norm sound data");

disp(command);
function command = getMyCommand(voi_norm)
    fs = 22050;
    length = 0;
    vol = 0.2;
    threshold = 0.12;
    
    for i = 1:44100
        if abs(voi_norm(i)) >= vol
            command = 4; % right
            return;
        end
    end
    command = 5;
    
    voi_norm1 = voi_norm/max(abs(voi_norm));
    for i = 1:44100
        if voi_norm1(i) >= threshold
            length =length+1;           
        end
    end
    disp(length);
    if length <= 700
        command = 1; % up
    elseif length > 2000;
        command = 2; % down
    else command = 3; %left
    end
           
end

%%
% generate the maze as a 12x11 array
%maze.m
% starts at 9, ends at 8
% walls are 1 and passage is 0
 
% maz = [1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 9 1 1 1 1 1 ;1 0 0 0 1 0 1 1 1 1 1;...
%     1 0 1 0 1 0 0 0 1 1 1; 1 0 1 0 1 1 1 0 1 1 1; 1 0 1 0 0 0 0 0 1 1 1;...
%     1 0 1 1 1 1 1 1 1 1 1; 1 0 1 0 0 0 1 1 1 1 1;1 0 1 0 1 0 0 0 0 0 1; ...
%     1 0 1 0 1 1 1 1 1 0 1; 1 0 0 0 1 8 0 0 0 0 1; 1 1 1 1 1 1 1 1 1 1 1 ];
%  
% % draw the maze with the start and end points
% imagesc(maz);
% axis equal
% text(6,1,'Start')
% text(6,12,'End')
% pause
%  
% % the cursor starts at the start position
% curpos = [2,6];
% curval = maz(curpos(1),curpos(2));
%  
% % define some values so that we can use a random number generator to
% % traverse the maze (this is for demonstration only)
%  
% up = 1;
% down = 2;
% left = 3;
% right = 4;
%  
% % move through the maze
% for k=1:300
% %command = round(rand*4);      % generate an integer between 0 and 4
% 
% r = audiorecorder(22050,16,1);
% disp('choose command.');
% recordblocking(r, 2); % read a 2s sound clip
% command_sound = getaudiodata(r, 'double'); % get data as double array
% get_dur(command_sound); 
% % write a new value to the cursor position
% if command == up
%     curnew = curpos+[-1,0];
% elseif command == down
%     curnew = curpos+[1,0];
% elseif command == left
%     curnew = curpos+[0,-1];
% elseif command == right
%     curnew = curpos+[0,1];
% else
% end
%  
% % Check to see that the new position is in the passage
% % not trying to go through a wall
% curval = maz(curnew(1),curnew(2));
% if(curval==0)               % If it is a valid move update the cursor posn
%     curpos = curnew;
%     maz(curpos(1),curpos(2)) = 5;   % write a 5 into the passage
% else
%     disp('Invalid move ')
% end
%  
% % Display the maze with the new cursor position
% imagesc(maz)
% axis equal
% text(6,1,'Start')
% text(6,12,'End')
% drawnow
% end
