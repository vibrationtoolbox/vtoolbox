function update_datestamp(vtbdir)
%UPDATE_DATESTAMP Regenerate vtbdatestamp.txt from the toolbox's files.
%
%   UPDATE_DATESTAMP() scans every .m file in the toolbox root (the parent
%   of this packaging/ folder) and writes the most recent modification
%   time to vtbdatestamp.txt, as a MATLAB serial date number.
%
%   UPDATE_DATESTAMP(VTBDIR) scans VTBDIR instead of the default location.
%
%   This is the exact value that VTBCHK.M and VTBUD.M compare against the
%   online copy of vtbdatestamp.txt (fetched from GitHub) to tell users
%   whether a newer release is available. The file is produced with:
%
%       fprintf(fid,'%s',num2str(datenum(d.date)));
%
%   where d is one entry of a DIR() listing. Previously this was a manual,
%   one-off step run by hand before committing a release, which is the
%   most likely source of the stale/incorrect stamp mentioned at the top
%   of Readme.rst ("A critical error was discovered in the update
%   mechanism"). Run this script (or let the release GitHub Actions
%   workflow run it) every time before tagging a release so the stamp is
%   always correct.

if nargin < 1
    vtbdir = fileparts(fileparts(mfilename('fullpath')));
end

files = dir(fullfile(vtbdir,'*.m'));
if isempty(files)
    error('update_datestamp:notFound','No .m files found in %s.',vtbdir);
end

stamps = zeros(numel(files),1);
for k = 1:numel(files)
    d = files(k);
    stamps(k) = datenum(d.date); %#ok<DATNM>
end
newstamp = max(stamps);

stampfile = fullfile(vtbdir,'vtbdatestamp.txt');
fid = fopen(stampfile,'w');
if fid == -1
    error('update_datestamp:writeFailed','Could not open %s for writing.',stampfile);
end
fprintf(fid,'%s',num2str(newstamp));
fclose(fid);

fprintf('Updated %s to %s\n', stampfile, num2str(newstamp));
