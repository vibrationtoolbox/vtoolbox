%Simple script to add the vtoolbox directory to the matlab path


vtbupdir = uigetdir(pwd,'Choose the Engineering Vibration Toolbox (vtoolbox) directory.'); 
cd(vtbupdir)
addpath(pwd,'-end')
aa=savepath;
if aa==1
    astartmod=questdlg(['Path not saved. You will need to add the line ''addpath(''' pwd ''')'' to your startup.m file. Do you want me to attempt to do this?']) ;
    if strcmp(astartmod,'Yes')
        % MATLAB automatically runs startup.m located in userpath at every
        % session start, regardless of the current folder. Previously this
        % script wrote to getenv('HOME') (or, on Windows/old Mac, just
        % opened pathtool with no persistent fallback at all). MATLAB only
        % executes startup.m from userpath (e.g. ~/Documents/MATLAB), not
        % from the bare home directory, so the added path was lost on the
        % next MATLAB restart unless the user happened to launch MATLAB
        % with that exact folder as its current directory. Using userpath
        % works the same way, and consistently, on Windows, Mac, and Linux.
        userdir = userpath;
        if isempty(userdir)
            userdir = getenv('HOME');
        end
        if exist(userdir,'dir')==0
            mkdir(userdir)
        end
        startupfile = fullfile(userdir,'startup.m');
        fid = fopen(startupfile,'a');
        fprintf(fid,'addpath(''%s'',''-end'')\n',pwd);
        fclose(fid);
        msgbox(['The last line of the file startup.m in ' userdir ' should now be set to add vtoolbox to your path each time you run Matlab.'])
    else
        warndlg('Path not saved. You will have to manually set your startup path to include the vtoolbox directory.')
        pathtool
    end
end

%Check once for updates now that the toolbox is set up. This is the only
%place an update check runs automatically; it only prints a notice and
%never downloads or executes anything (run 'vtbud' yourself to update).
vtbchk
