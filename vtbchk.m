function vtbchk
%VTBCHK Checks for updates on a semi-regular basis and prints a notice.
% Intended to be called explicitly (e.g. once from vtbsetup) rather than
% automatically from every toolbox function. It never downloads or runs
% anything itself; it only prints a notice telling the user to run VTBUD.

% variable chkskip tells how often to run check.

%Joseph C. Slater, April 2008
%Updated to be notify-only (no auto-launch of vtbud) and to use webread
%instead of the deprecated urlread.

sourcehead = 'https://raw.githubusercontent.com/vibrationtoolbox/vtoolbox/master/';

chkskip=7;% number of days to go without checking again.
curpath=pwd;
vtbdir=which('vtb1_1.m');vtbdir=vtbdir(1:(length(vtbdir)-8));
cd(vtbdir)

%chckdatestamp is the last time the code checked to see if there
%were updates.

%vtbdatestamp is the time stamp of the toolboxes last edit.

if exist('chkdatestamp.txt','file')==0
    chkdatestamp=0;
else
    chkdatestamp=fileread('chkdatestamp.txt');
end

if (str2double(chkdatestamp)<(now-chkskip))
    try
        %installed date (read locally, no network needed)
        insdatestamp=fileread('vtbdatestamp.txt');
        %online stamp
        curdatestamp=webread([sourcehead 'vtbdatestamp.txt']);
        if (str2double(insdatestamp)<str2double(curdatestamp))
            disp('A newer version of the Engineering Vibration Toolbox is available.')
            disp('Run ''vtbud'' to review and install updates.')
        end
    catch
        disp('Engineering Vibration Toolbox update checking not working.')
        disp(['Either you are not on the internet, or a fault has ' ...
              'occured.'])
        disp(['If you are online, please notify me by filing an error ' ...
              'report at http://vibrationtoolbox.github.io'])
        disp('Run ''vtbud'' while online to check for updates.')
        disp(['Automatic check again in ' num2str(chkskip) ' days.'])
    end
end

fid = fopen('chkdatestamp.txt','wt');
fprintf(fid,'%s',num2str(now));
fclose(fid);
cd(curpath)

