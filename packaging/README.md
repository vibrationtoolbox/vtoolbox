Packaging the Engineering Vibration Toolbox
============================================

This folder contains everything needed to build a proper MATLAB Toolbox
package (``.mltbx``) for the Engineering Vibration Toolbox, plus the script
that keeps the toolbox's "check for updates" mechanism accurate.

Why ``.mltbx`` instead of ``vtbsetup.m``?
------------------------------------------

``vtbsetup.m`` (still kept for people who clone the repo directly) adds the
toolbox folder to the path by calling ``addpath`` + ``savepath``, and falls
back to hand-editing ``startup.m`` if ``savepath`` fails -- which it usually
does, because MATLAB's ``pathdef.m`` normally lives inside the MATLAB
install folder and isn't writable without admin rights.

A ``.mltbx`` file avoids all of that:

* Double-click it (or use ``matlab.addons.install``) and MATLAB's Add-On
  Manager installs it, adds the right folders to the path, and remembers
  how to cleanly uninstall it -- no ``savepath``/``startup.m`` involved.
* It installs into the user's own Add-Ons folder, so no admin rights are
  needed on any platform.
* It carries its own name/version/required-MATLAB-release metadata, so
  users (and ``ver``) can see what's installed.

``vtbsetup.m``/``vtbud.m`` are unaffected and remain available for people
who prefer to work from a git clone.

One-time setup: creating the toolbox project
----------------------------------------------

A MATLAB toolbox project has to be created once through MATLAB's GUI,
because it records the toolbox metadata (name, GUID, version, file list,
MATLAB release compatibility) in a format that's impractical to hand-write
reliably. Do this once, commit the result, and every future build/release
reuses it automatically. In MATLAB R2026a this produced two things at the
**repository root**:

* ``vtoolbox.prj`` -- a small pointer file
* ``resources/project/`` -- the actual project metadata (file list,
  exclusions, name/version, etc.)

Steps taken (for reference, if this ever needs to be redone):

1. Open MATLAB with this repository as the current folder.
2. Click the **"Package Toolbox"** button (Home tab, or under Add-Ons),
   which opens a **"Packaging Toolbox"** window.
3. In the **Toolbox Folder** step, browse to and select the repository
   root (``/Users/jslater/Documents/vtoolbox``) itself. This recursively
   picks up every file, shown in **File Preview**.
4. Click **Edit exclusions** and add these lines to the exclusions file
   (same one-path-per-line style as ``.gitignore``), so build tooling
   doesn't get bundled inside the ``.mltbx``:

   .. code-block::

       packaging/
       .github/
       chkdatestamp.txt

5. Continue the wizard and set:

   * **Name:** ``Engineering Vibration Toolbox``
   * **Version:** e.g. ``25.9.0`` (see *Versioning* below)
   * **Author / summary / description:** from ``Readme.rst``

6. Finish creating the project. This writes ``vtoolbox.prj`` and
   ``resources/`` to the repository root.
7. Click **Package Toolbox** to do a first test build -- it writes
   ``vtoolbox.mltbx`` (plus a ``deploymentLog.html``) under
   ``vtoolbox/release/`` in the repo. That location is just a scratch
   build-output folder (already excluded via ``.gitignore``); the file
   that matters for future rebuilds is the committed project itself.
8. Commit ``vtoolbox.prj`` and ``resources/`` (everything under it
   **except** ``resources/.buildtool/``, which is a local build cache --
   already excluded via ``.gitignore``).

Building a release
-------------------

Once the project exists, every future release is just:

.. code-block:: matlab

    cd packaging
    update_datestamp        % refreshes vtbdatestamp.txt (see below)
    build_toolbox            % writes ../vtoolbox.mltbx

Then bump the version inside ``vtoolbox.prj`` (open the project once more
via **Package Toolbox** and update the version field), commit, tag
(e.g. ``git tag v25.9.0 && git push --tags``), and push. The
``.github/workflows/release.yml`` workflow re-runs both scripts and
attaches the resulting ``vtoolbox.mltbx`` to the GitHub Release for that
tag automatically, so users can download it without needing MATLAB
themselves to build it.

The update-check mechanism and ``vtbdatestamp.txt``
-----------------------------------------------------

``vtbchk.m`` (run once automatically at the end of ``vtbsetup.m``) and
``vtbud.m`` both decide whether a newer version of the toolbox is available
by comparing two files:

* ``vtbdatestamp.txt`` -- committed in the repo root. It holds a single
  number: a MATLAB serial date number (``datenum``) representing when the
  toolbox was last changed. This is the file fetched from GitHub
  (``raw.githubusercontent.com/.../vtbdatestamp.txt``) and compared against
  the user's locally installed copy of the same file.
* ``chkdatestamp.txt`` -- **not** part of the toolbox source; it is written
  locally by ``vtbchk.m`` every time it runs, and simply records *when the
  local install last checked* (so it only checks once every ``chkskip``
  days). It should never be committed -- see the ``.gitignore`` entry
  added alongside this change.

``vtbdatestamp.txt`` is produced with:

.. code-block:: matlab

    fprintf(fid,'%s',num2str(datenum(d.date)));

where ``d`` is one entry from a ``dir()`` listing (``d.date`` is the file's
last-modified timestamp as a string; ``datenum`` converts it to the numeric
form used for comparison). Previously this was run by hand, occasionally
against the wrong file or forgotten entirely -- the most likely cause of
the "critical error ... discovered in the update mechanism" noted at the
top of ``Readme.rst``. ``packaging/update_datestamp.m`` formalizes this: it
scans every ``.m`` file in the toolbox and stamps ``vtbdatestamp.txt`` with
the *most recent* modification time found, so it always reflects the true
last edit rather than one hand-picked file. Run it (or let CI run it)
before every release.

Versioning
-----------

Use `semantic versioning <https://semver.org>`_ (``MAJOR.MINOR.PATCH``) or
a date-based scheme (``YY.M.PATCH``) for the ``vtoolbox.prj`` version field
-- either is fine, just be consistent. The version shown to users in the
Add-On Manager comes only from ``vtoolbox.prj``; ``vtbdatestamp.txt`` is
used solely for the legacy git-clone update check.

Files in this folder
----------------------

* ``build_toolbox.m`` -- packages the repo-root ``vtoolbox.prj`` into
  ``vtoolbox.mltbx``.
* ``update_datestamp.m`` -- regenerates ``vtbdatestamp.txt``.
* ``README.md`` -- this file.

The toolbox project itself (``vtoolbox.prj`` and ``resources/``, created
via the one-time setup above) lives at the **repository root**, alongside
the toolbox's ``.m`` files, not in this folder -- that's just where MATLAB
put it when the project's "Toolbox Folder" was set to the repo root.
