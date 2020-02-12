[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

DS64-RUNNER 1 "FEBRUARY 2020"
=============================

NAME
----

ds64-runner - find and execute program in 64-bit Debian sidekick OS

SYNOPSIS
--------

`ds64-runner` *COMMAND* [ARGS]

DESCRIPTION
-----------

`ds64-runner` attempts to execute the specified *COMMAND* in the current 64-bit
Debian 'sidekick' OS (which must be running). The standard `$PATH` will
be used to resolve *COMMAND* inside that OS' container, so in general,
this command is easier to use than ds64-run(1) (which requires fully
qualified paths).

The command execution is asynchronous, so this may be used to execute
long-running desktop GUI programs.

The invoked command has the necessary environment variables set to enable it
to use the host's pulseaudio(1) server, access the host's Xorg(1) server
etc.

You can use sudo(8) with `ds64-runner`; for example (assuming you have
mousepad(1) installed in the guest OS):

`ds64-runner sudo mousepad /etc/foo.conf`

If the sidekick OS is not running, or if *COMMAND* could not be found,
or if *COMMAND* exits with an error, a `zenity` dialog will be shown,
with a 5 second auto-dismissal timeout, where possible.

EXIT STATUS
-----------

The exit status is 1 if the sidekick OS is not running, and 0 otherwise
(regardless of the return status of the invoked *COMMAND*, or whether
*COMMAND* could be found).

If *COMMAND* could not be found or exits with an error status, the failed
jobs count for the container is **not** incremented (only a zenity(1) dialog
is shown, where possible). This is different behaviour to ds64-run(1).

FILES
-----

*/etc/ds64.conf*

Configuration file specifying various controlling environment
variables, including `$DS64_NAME` (defaults to *debian-buster-64*) and
`$DS64_DIR` (defaults to */var/lib/machines/debian-buster-64*).

BUGS
----

`ds64-runner` cannot currently be used to start a bash(1) shell (although
of course it can be used to do this indirectly, by starting e.g. a
terminal application). Use ds64-shell(1) for that instead.

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

bash(1), ds64-run(1), ds64-shell(1), mousepad(1), pulseaudio(1),
sudo(8), systemctl(1), Xorg(1), zenity(1)
