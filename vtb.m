function b=vtb(a)
% Student Edition of the Vibration Toolbox.
% Last update: Type "vtbud"
%
%  Type "help vtoolbox" for help on the Engineering Vibration Toolbox.
%  Type "help vtbud" for a list of updates since 1/1/98 and update the
%       toolbox.
%  Type "vtb('home')" to go to the Engineering Vibration 
%       Toolbox home page
%  Type "help vtb#" fo help onchapter # tools
%  Type "help vtbn_m" for help with the mth code of chapter n. 
%  
%
%  Please connect to the Engineering Vibration Toolbox home
%  page at
%  https://vibrationtoolbox.github.io/matlab.html
%  for the latest information.
% 
if nargin==0
    disp(' ')
    disp('You should type:')
    disp('help vtb')
    disp('for help on a file named vtb.m')
    
    pause(2)
    help vtb
    return
else
    web https://vibrationtoolbox.github.io/matlab.html;
    return
end
