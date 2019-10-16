[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

UNIFY-XAUTH 1 "OCTOBER 2019"
============================

NAME
----

unify-xauth - modify .Xauthority file to work on any host

SYNOPSIS
--------

`unify-xauth`

DESCRIPTION
-----------

`unify-xauth` modifies the Xorg credentials file pointed to by the
`$XAUTHORITY` environment variable, so that it may be used on any host
(this allows it to be passed e.g. into a 64-bit systemd-nspawn(1) guest OS,
where the hostname will not be the same as that of the main, host OS).

The modified credentials file will be saved to `$XAUTHORITY`-allhosts;
the original is retained unmodified.

EXIT STATUS
-----------

The exit status is 0 if the the updated Xorg credentials file was
created successfully, and a non-zero error code otherwise.

ENVIRONMENT
-----------

The program expects the `$XAUTHORITY` environment variable to be set,
and to point to the current credentials file (this will most commonly
be *~/.Xauthority*).

FILES
-----

Reads `$XAUTHORITY` (most commonly, this will be *~/.Xauthority*) and
writes to `$XAUTHORITY`-allhosts (most commonly,
*~/.Xauthority-allhosts*).

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

systemd-nspawn(1), Xorg(1)
