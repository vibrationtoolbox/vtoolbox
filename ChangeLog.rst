Updates to Engineering Vibration Toolbox
==========================================

Run vtbud (or install the latest .mltbx release) to compare your version
to the most current one.

More information is available at the `Engineering Vibration Toolbox <http://vibrationtoolbox.github.io>`_
website.


========= =============== ===============================================
  Date       code/s                change
--------- --------------- -----------------------------------------------
10/11/26    vtb8_1          Remove eval/findstr/dead Mac-specific code
                            from the save-configuration block (same
                            cleanup as vtb8_2/vtb8_3); remove stale
                            commented-out dead code.
10/11/26    vtb10_1         Remove unused leftover version-check
                            variables.
10/11/26    vtbud           Replace findstr with strfind; fix Mac/Linux
                            branch check (was comparing computer() to the
                            obsolete 'MACI' string, which never matches
                            on modern systems); fix msgdlg typo (not a
                            real MATLAB function) -> msgbox.
10/11/26    vtb1_3          Remove eval; also accepts function handles and
                            passes the stage time correctly to each Runge-
                            Kutta stage (was using one fixed time for all
                            four stages).
10/11/26    vtb3_5          Remove eval; coefficients evaluated via
                            str2func instead.
10/11/26    vtb4_4          Fix help text typo (VTB1_4 -> VTB4_4).
10/11/26    vtb10_1         Restore correct axis limits; guard the final
                            zero-derivative-point plot so it doesn't error
                            when no such point is found.
10/11/26    vtb8_1          Help text notes the GUI is dated; defining the
                            model directly (see vtb8_e1.m) and calling
                            vtb8_2 is easier.
10/11/26    vtb8_2, vtb8_3  Remove eval/findstr/dead Mac-specific code;
                            fix boundary-condition indexing bug (wrong
                            size for p, duplicate constraints miscounted);
                            add optional opts struct for non-interactive/
                            scripted use; merge the two save prompts.
10/11/26    vtb8_e1         Fix density (per unit length, was per volume)
                            and modulus of elasticity (aluminum); first
                            natural frequency now correctly 163.32 Hz.
                            Regenerated vtb8_e1.con to match.
09/16/26    vtbsetup        Fix path not persisting after install: write
                            startup.m to userpath instead of $HOME, which
                            MATLAB does not auto-run.
09/16/26    vtb8_1          Allow blank Enter (not just 0) to end node
                            entry; accept coordinates as x,y or x y
                            without square brackets.
09/16/26    package         Add MATLAB Toolbox (.mltbx) packaging and
                            GitHub Actions release workflow, alongside the
                            legacy vtbsetup.m install.
09/16/26    vtbud, vtbchk   Harden update mechanism: replace eval-based
                            shell commands and deprecated urlread/
                            urlwrite with webread/websave/fileread; make
                            update checks notify-only.
========= =============== ===============================================
