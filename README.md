iTerm Color Scheme Converter
============================

Call me crazy, but I prefer Terminal.app to iTerm. I've tried iTerm a couple
of times, but the performance and simplicity of Terminal.app is what brings me
back every time.

However, this means that I miss out on the color schemes, of which iTerm has a
lot. 

So, after some poking into the format of the .plist used for iTerm and
Terminal.app, I managed to cobble together a little Swift command-line
application that converts between the two.

Unfortunately it can't (easily) be a Python or Ruby script, or anything that
does not have access to the Foundation framework, because for some reason, Apple
has decided to use serialized NSColor and NSFont objects as the values stored in
the .plist file.

I didn't feel like trying to spit out the NSKeyedArchiver format by hand, so
here we are.


Building
--------

`
$ xcodebuild
`

This should build the release binary, and put it in the build/ folder.
Tested on Xcode 7.0 beta 4. 

Running
-------

`
$ iTermColorSchemeConverter *.itermcolors
`

This will produce a .terminal file with the same base file name as the
.itermcolors file. 

This file can be imported into Terminal.app by clicking the gear drop-down on
the Profiles section of Preferences, and selecting Import.
