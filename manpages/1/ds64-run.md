[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

DS64-RUN 1 "FEBRUARY 2020"
==========================

NAME
----

ds64-run - execute program in 64-bit Debian sidekick OS

SYNOPSIS
--------

`ds64-run` *COMMAND* [ARGS]

DESCRIPTION
-----------

`ds64-run` attempts to execute the specified *COMMAND* in the current 64-bit
Debian 'sidekick' OS (which must be running). *COMMAND* must be a
fully-qualified path that resolves inside that OS' container, so in general,
it is easier to use ds64-runner(1) instead.

The command execution is asynchronous, so this may be used to execute
long-running desktop GUI programs.

The invoked command has the necessary environment variables set to enable it
to use the host's pulseaudio(1) server, access the host's Xorg(1) server
etc.

If the sidekick OS is not running, a zenity(1) error dialog will be
shown, with a 5 second auto-dismissal timeout, where available.

EXIT STATUS
-----------

The exit status is 1 if the sidekick OS is not running, 0 otherwise
(regardless of the return status of the invoked *COMMAND*).

If *COMMAND* returns a non-zero error status, the failed jobs count for its
OS container (as shown by `systemctl list-machines`) will however
increment by one (this is different behaviour to ds64-runner(1)).

FILES
-----

*/etc/ds64.conf*

Configuration file specifying various controlling environment
variables, including `$DS64_NAME` (defaults to *debian-buster-64*) and
`$DS64_DIR` (defaults to */var/lib/machines/debian-buster-64*).

BUGS
----

Bugs should be reported on the
[project's GitHub page](https://github.com/sakaki-/raspbian-nspawn-64/issues).

COPYRIGHT
---------

Copyright &copy; 2019-20 sakaki

License GPLv3+ [GNU GPL version 3 or later](http://gnu.org/licenses/gpl.html)

This is free software, you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


AUTHORS
-------

sakaki <sakaki@deciban.com>

SEE ALSO
--------

ds64-runner(1), pulseaudio(1), systemctl(1), Xorg(1), zenity(1)
