The Engineering Vibration Toolbox
###################################

**Note: A critical error was discovered in the update mechanism. Please run** *vtbud* **to update your code if you get an error including mention of** *vtbchk*. **Thank you.**


About The Engineering Vibration Toolbox
========================================

The Engineering Vibration Toolbox is a set of educational programs
written in MATLAB by Joseph C. Slater. Also included are a number of help files,
demonstration examples, and data files containing raw experimental data. The
codes include single degree of freedom response, response spectrum, finite
elements, numerical integration, and phase plane analysis. It is included
free with the text **Engineering Vibration** by Dr. Daniel J. Inman
(Prentice Hall, 1994, 1998, 2001,...) and is provided as a download for later editions.

The most current version, for use with the professional and student
versions of MATLAB 4 or later, can be obtained via the `Engineering Vibration Toolbox web page`_ for
more information. Please `email me`_ directly at if you
have difficulty with this link.

If you have not already installed MATLAB or the Student Edition of MATLAB,
do so now. You should be somewhat familiar with MATLAB before running this
software.


Note To Instructors
====================

Regular updates are made to the toolbox.  Please send me any
problems you've developed for the toolbox, I'd like to begin a collection
of problems that better take advantage of its capabilities.

Note to contributors
====================

To contribute to the toolbox, please fork this repository, clone to your desktop, and add the vtoolbox directory to your Matlab path.

To submit a change, please see the document `Contributing.rst`.

Setting Up The Toolbox
=======================

Please go to `Engineering Vibration Toolbox web page`_ for installation instructions.


Using The Engineering Vibration Toolbox
=========================================

The Engineering Vibration Toolbox will check for updates every 7 days by default.
To change this default, redefine the variable :code:`chkskip` in the file :code:`vtbchk.m`.
Unfortunately this will be written over at the next update.

The files on this disk will load/run on all platforms if transferred
properly. Files with the extension :code:`.mat`, :code:`.exa`, :code:`.con`, :code:`.eqn`, and :code:`.out` are
binary files compatible on all platforms. To load them type :code:`"load filename -mat"`. Files with no extension or the extension .m are text files and must
be transferred properly to assure that the end-of-line characters are
correct for your platform.

Typing :code:`help vtoolbox` will provide a table of contents of the toolbox.
Likewise, typing :code:`help vtb?` will provide a table of contents for the
files related to chapter *?*. Typing 'help codename' will provide help on
the particular code.  Note that the 'filename' is 'codename.m'.

Engineering Vibration Toolbox commands can be run by typing them with the
necessary arguments just as any other MATLAB commands/functions. For
instance, :code:`vtb1_1` can be run by typing :code:`"vtb1_1(1,.1,1,1,0,10)"`. Many
functions have multiple forms of input. The help for each function shows
this flexibility.


Contacting The Author
=======================

If you have any difficulty, please `email me`_.

Please visit the `Engineering Vibration Toolbox web page`_.


Acknowledgements
===================

Support for the Engineering Vibration Toolbox has come from a number of
sources. First and foremost, Daniel J. Inman, who initially tasked myself
and Donald J. Leo to write version 3 of the software for his text
"Engineering Vibration" by Dr. Daniel J. Inman (Prentice Hall, 1994). I
also thank the Department of Mechanical and Materials Engineering and the
College of Engineering and Computer Science at Wright State University for
providing the computer resources for developing the MATLAB 4 version of
the software. Perhaps the people who have given the most are my students
who painfully experienced every piece of beta code, often at the least
opportune times. Thanks is also given to Dr. Maurice Petyt and Robert C.
Chiroux for their patience in testing numerous 4.0 beta versions of this
software.


License
============

The Engineering Vibration Toolbox is licensed free of charge for educational use.
For professional use, users should contact the Engineering Vibration Toolbox
author directly.


------------------------------------------------------------------------------------------

MATLAB is a registered trademark of the MathWorks, Inc.
Mac(intosh) is a registered trademark of Apple Computer, Inc.
PostScript is a registered trademark of Adobe Systems, Inc.
Windows is a registered trademark of Microsoft Corp.
Unix is a registered trademark of AT&T.

Joseph C. Slater is the copyright holder of the Engineering Vibration
Toolbox. Neither the author, Prentice Hall, nor Wright State University
make any warranty with regard to merchantability or fitness for any given
purpose with regard to the software. All rights are retained. No
permission is given to anyone other than myself, the MathWorks and
Prentice Hall to distribute this software in any manner whatsoever.


.. _`Engineering Vibration Toolbox web page`: https://vibrationtoolbox.github.io
.. _`email me`: mailto:joseph.c.slater@gmail.com
