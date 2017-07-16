function vtbchk
%VTBCHK Checks for updates on a semi-regular basis.
% Mostly precludes need to run vtbud manually

% variable chkskip tells how often to run check.

%Joseph C. Slater, April 2008

head = 'https://github.com/vibrationtoolbox/vtoolbox/blob/master/';
sourcehead = 'https://raw.githubusercontent.com/vibrationtoolbox/vtoolbox/master/';
ziploc = 'https://github.com/vibrationtoolbox/vtoolbox/archive/master.zip';
webpageloc= 'http://vibrationtoolbox.github.io';



chkskip=7;% number of days to go without checking again.
curpath=pwd;
vtbdir=which('vtb1_1.m');vtbdir=vtbdir(1:(length(vtbdir)-8));
cd(vtbdir)

%chckdatestamp is the last time the code checked to see if there
%were updates. 

%vtbdatestamp is the time stamp of the toolboxes last edit. 

if exist('chkdatestamp.txt')==0
	chkdatestamp=0;
else
	[chkdatestamp,status]=urlread(['file:///' fullfile(vtbdir,'chkdatestamp.txt')]);
end


if (str2double(chkdatestamp)<(now-chkskip))
    %installed date
    [insdatestamp,status]=urlread(['file:///' fullfile(vtbdir,'vtbdatestamp.txt')]);
    %online stamp
    [curdatestamp,status]=urlread([sourcehead 'vtbdatestamp.txt']);
    if (str2double(insdatestamp)<str2double(curdatestamp))
	vtbud
	disp('Run vtbud at any time you are online to check for updates to the Engineering Vibration Toolbox.')
    end
    if status==0
    disp('Engineering Vibration Toolbox update checking not working.')
    disp(['Either you are not on the internet, or a fault has ' ...
          'occured.'])
    disp(['If you are online, please notify me by filing an error ' ...
          'report at http://vibrationtoolbox.github.io'])
    disp('Run ''vtbud'' while on online to check for updates.')
    disp(['Automatic check again in ' num2str(chkskip) ' days.'])
    end
end

	

fid = fopen('chkdatestamp.txt','wt');
fprintf(fid,'%s',num2str(now));
fclose(fid);
cd(curpath)

