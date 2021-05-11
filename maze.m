%maze
clc;






% generate the maze as a 12x11 array
%maze.m
% starts at 9, ends at 8
% walls are 1 and passage is 0
 
maz = [1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 9 1 1 1 1 1 ;1 0 0 0 1 0 1 1 1 1 1;...
    1 0 1 0 1 0 0 0 1 1 1; 1 0 1 0 1 1 1 0 1 1 1; 1 0 1 0 0 0 0 0 1 1 1;...
    1 0 1 1 1 1 1 1 1 1 1; 1 0 1 0 0 0 1 1 1 1 1;1 0 1 0 1 0 0 0 0 0 1; ...
    1 0 1 0 1 1 1 1 1 0 1; 1 0 0 0 1 8 0 0 0 0 1; 1 1 1 1 1 1 1 1 1 1 1 ];
 
% draw the maze with the start and end points
imagesc(maz);
axis equal
text(6,1,'Start')
text(6,12,'End')
 
% the cursor starts at the start position
curpos = [2,6];
curval = maz(curpos(1),curpos(2));
 
% define some values so that we can use a random number generator to
% traverse the maze (this is for demonstration only)
 
up = 1;
down = 2;
left = 3;
right = 4;
 
lol = [2 2 4 4 2 2 3 3 3 3 1 1 1 3 3 2 2 2 2 2 2 2 2 4 4 1 1 1 4 4 2 4 4 4 4 2 2 3 3 3 3]; 
% move through the maze
for k=1:300
%command = round(rand*4);      % generate an integer between 0 and 4
if k == 41
    break;
end
r = audiorecorder(22050,16,1);
disp('say command.');
recordblocking(r, 2); % read a 2s sound clip
voi_norm = getaudiodata(r, 'double'); % get data as double array

fs = 22050;
[b1 a1] = butter(3,140/(fs/2),'high');
voi_norm = filter(b1,a1,(voi_norm));
command = lol(k);
% command = getMyCommand(voi_norm);
words = getWords(command);
disp(words);
disp('-------------------------------------------------------');
 
% write a new value to the cursor position
if command == up
    curnew = curpos+[-1,0];
elseif command == down
    curnew = curpos+[1,0];
elseif command == left
    curnew = curpos+[0,-1];
elseif command == right
    curnew = curpos+[0,1];
else
end
 
% Check to see that the new position is in the passage
% not trying to go through a wall
curval = maz(curnew(1),curnew(2));
if(curval==0)               % If it is a valid move update the cursor posn
    curpos = curnew;
    maz(curpos(1),curpos(2)) = 5;   % write a 5 into the passage
else
    disp('Invalid move ')
end
 
% Display the maze with the new cursor position
imagesc(maz)
axis equal
text(6,1,'Start')
text(6,12,'End')
drawnow
end

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
    elseif length > 2500;
        command = 2; % down
    else command = 3; %left
    end
           
end
function words = getWords(command)
if command == 1
    words = 'up';
elseif command == 2
    words = 'down';
elseif command == 3
    words = 'left';
elseif command == 4
    words = 'right';
end
end