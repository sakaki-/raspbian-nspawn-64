[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

DS64-SHELL 1 "OCTOBER 2019"
===========================

NAME
----

ds64-shell - open a shell inside the 64-bit Debian sidekick OS

SYNOPSIS
--------

`ds64-shell` [ARGS]

DESCRIPTION
-----------

`ds64-shell` attempts to open an bash(1) shell inside the
current 64-bit Debian 'sidekick' guest OS (which must be running). The
shell is invoked under your current UID and GID (which will have been
automatically reflected into the guest by reflect-passwd(8)).

The shell has the necessary environment variables set to e.g.,
enable it to use the host's pulseaudio(1) server, access the host's
Xorg(1) server etc. By default, an *interactive* shell is opened;
when you have finished using it, it may be closed using ctrl-d.

You may use passwordless sudo(8) inside the shell to gain root privileges (in
order, to, for example, use apt-get(1) to install new packages).

Any guest-OS programs started from the shell will exit whenever
the shell itself is closed, nohup(1) notwithstanding, so, if you want
to run a detached GUI program, use ds64-runner(1) or ds64-run(1) instead.

To *invoke* a shell script in the guest OS directly, use `ds64-shell` with
the `-c` option, e.g.:

`ds64-shell -c top`

If the sidekick OS is not running when `ds64-shell` is invoked,
a `zenity` error dialog will be shown, with a 5 second auto-dismissal timeout.

EXIT STATUS
-----------

The exit status is 1 if the sidekick OS is not running, and 0
otherwise (regardless of the return status of any command invoked
inside the shell itself).

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

Copyright &copy; 2019 sakaki

License GPLv3+ [GNU GPL version 3 or later](http://gnu.org/licenses/gpl.html)

This is free software, you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


AUTHORS
-------

sakaki <sakaki@deciban.com>

SEE ALSO
--------

apt-get(1), bash(1), ds64-run(1), ds64-runner(1), nohup(1),
pulseaudio(1), sudo(8), Xorg(1), zenity(1)
