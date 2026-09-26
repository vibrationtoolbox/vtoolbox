function build_toolbox(outputFile)
%BUILD_TOOLBOX Package the Engineering Vibration Toolbox into a .mltbx file.
%
%   BUILD_TOOLBOX() packages the toolbox described by the repo-root
%   vtoolbox.prj into vtoolbox.mltbx in the repository root.
%
%   BUILD_TOOLBOX(OUTPUTFILE) writes the package to OUTPUTFILE instead.
%
%   vtoolbox.prj (and its accompanying resources/ folder) is created ONCE
%   via MATLAB's "New > Toolbox" wizard -- see packaging/README.md for the
%   one-time setup steps. Once those exist and are committed, this script
%   (and the release.yml GitHub Actions workflow) rebuild the .mltbx
%   automatically for every release without needing the wizard again.

repoRoot = fileparts(fileparts(mfilename('fullpath')));

if nargin < 1
    outputFile = fullfile(repoRoot,'vtoolbox.mltbx');
end

prjFile = fullfile(repoRoot,'vtoolbox.prj');
if exist(prjFile,'file') ~= 2
    error('build_toolbox:noPrj', ...
        ['vtoolbox.prj not found at the repository root. Create it once ' ...
         'via the MATLAB "New > Toolbox" wizard (see packaging/README.md), ' ...
         'commit it (and resources/, excluding resources/.buildtool/), ' ...
         'then re-run this script.']);
end

matlab.addons.toolbox.packageToolbox(prjFile, outputFile);
fprintf('Built %s\n', outputFile);
