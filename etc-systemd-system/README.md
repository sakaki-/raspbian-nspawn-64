## Unit Files

This directory contains a few `systemd` [`path` units](https://blog.andrewkeech.com/posts/170809_path.html) (and matching service files) installed in
`/etc/systemd/system` on the image (in the 32-bit Raspbian OS).

For a production-quality release, these should probably be packaged. They are
included here for ease of reference.

The files are:
* <a id="reflect-apps-path"></a>`refect-apps.path`: watches for changes to `/var/lib/machines/debian-stretch-64/usr/share/applications`, triggering `reflect-apps.service` when seen.
* <a id="reflect-apps-service"></a>`refect-apps.service`: in turn, calls the [`/usr/local/bin/reflect-apps`](https://github.com/sakaki-/raspbian-nspawn-64/tree/master/usr-local-bin#reflect-apps) script (which makes installed 64-bit apps auto-magically appear in the 32-bit main menu).
* <a id="reflect-passwd-path"></a>`reflect-passwd.path`: watches for changes to `/etc/{passwd,shadow,group,gshadow}`, triggering `reflect-passwd.service` when seen.
* <a id="reflect-passwd-service"></a>`reflect-passwd.service`: in turn, calls the [`/usr/local/bin/reflect-passwd`](https://github.com/sakaki-/raspbian-nspawn-64/tree/master/usr-local-bin#reflect-passwd) script (which makes changes to 'regular' users in the host (password, existence, primary group etc.) auto-magically propagate though to the guest).
