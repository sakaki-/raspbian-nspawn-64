[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

DS64-START 1 "OCTOBER 2019"
===========================

NAME
----

ds64-start - start the 64-bit Debian sidekick OS, if not running

SYNOPSIS
--------

`ds64-start`

DESCRIPTION
-----------

`ds64-start` attempts to boot up the current 64-bit Debian 'sidekick' guest
OS, if it is not already running.

Upon a error-free return from this command, you can rely upon the guest OS
being available, allowing you to e.g.,
invoke applications within it using ds64-runner(1).

To shut down the guest again, use ds64-stop(1).

A zenity(1) dialog status display is provided on exit, with a 5 second
auto-dismissal timeout.

EXIT STATUS
-----------

The exit status is 0 if the guest OS is running upon exit, and 1 otherwise.

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

ds64-runner(1), ds64-stop(1), zenity(1)
