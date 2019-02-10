## Helper Scripts

This directory contains a number of helper scripts installed in
`/usr/local/bin` on the image (in the 32-bit Raspbian OS).

For a production-quality release, these should probably be packaged. They are
included here for ease of reference.

The scripts are:
* <a id="bthelper"></a>`bthelper`: a variant of `/usr/bin/bthelper` that tries multiple times to attach to `hci0` (as this sometimes fails first time when booted under a 64-bit kernel); pulled in by the override `/etc/systemd/system/bthelper@hci0.service.d/override.conf` installed on the image, thus:

   ```ini
   [Service]
   # hciattach sometimes fails, so swap in a more reliable helper
   ExecStart=
   ExecStart=/usr/local/bin/bthelper %I
   ```
   
* <a id="ds64-run"></a>`ds64-run` `path` `<args>`: invokes the (fully-qualified) `path` executable within the 64-bit Debian Stretch (`ds64`) guest OS container (running as the 'reflected' copy of the invoking user), using `systemd-run`, passing any arguments arguments given. Sets an appropriate environment so that the invoked application can use the host's `pulseaudio` server, and X11 display. Example:

    ```console
    pi@raspberrypi:~ $ ds64-run /usr/bin/xeyes -fg red
    ```

* <a id="ds64-runner"></a>`ds64-runner` `path-or-file` `<args>`: as for `ds64-run`, but performs a `which`-style lookup of the given `path-or-file` on the guest, and also fails gracefully if the specified executable cannot be found. Should normally be used in preference to `ds64-run`. Example:

    ```console
    pi@raspberrypi:~ $ ds64-runner firefox https://www.raspberrypi.org
    ```

* <a id="ds64-running"></a>`ds64-running`: exits with status 0 if the `debian-stretch-64` container is up, and non-zero status otherwise. Example:

    ```console
    pi@raspberrypi:~ $ ds64-running && echo "The 64-bit container is up" \
      || "The 64-bit container is down"
    ```

* <a id="ds64-shell"></a>`ds64-shell`: opens a shell for (the reflected copy of) the current user inside the 64-bit guest OS container. You can `sudo` from here without password. Uses `machinectl shell` internally. Note that you *can* run graphical apps from this shell (and they will appear on the host's desktop), but such apps will close when the shell is closed; better to use `ds64-run` or `ds64-runner` from a *host* shell, instead (or alternatively, <kbd>System Tools</kbd>&rarr;<kbd>Run 64-bit Program...</kbd>).  
Example (installing a new aarch64 Debian package the guest):

    ```console
    pi@raspberrypi:~ $ ds64-shell
    Connected to machine debian-stretch-64. Press ^] three times within 1s to exit session.
    pi@debian-stretch-64:~ $ sudo apt-get update && sudo apt-get install -y mesa-utils
    [sudo] password for pi: <enter password>
    <...>
    <ctrl><d>
    pi@raspberrypi:~ $ 
    ```

* <a id="ds64-start"></a>`ds64-start`: boots up the `debian-stretch-64` container if it is not already running. Usually not necessary to call this (since it is automatically brought up for you at boot time, by the enabled `systemd-nspawn@debian-stretch-64.service` unit), unless you have manually taken down the container so as e.g. to back it up. Example:

    ```console
    pi@raspberrypi:~ $ ds64-running || ds64-start # make sure container is up
    ```

* <a id="ds64-stop"></a>`ds64-stop`: shuts down the `debian-stretch-64` container if it is running. This will kill any apps running within it, so take care. Does *not* prevent the container being automatically being brought up again on next boot. One reason to take the container down might be to safely backup its filesystem (located at `/var/lib/machines/debian-stretch-64` on the host). Example:

    ```console
    pi@raspberrypi:~ $ ds64-stop && cp -ax /var/lib/machines/debian-stretch-64{,.bak} && sync && ds64-start
    ```

* <a id="reflect-apps"></a>`reflect-apps`: triggered by a (host) [`path` unit](https://github.com/sakaki-/raspbian-nspawn-64/tree/master/etc-systemd-system#reflect-apps-path) watching for changes to `/usr/share/applications` within the container. When triggered, copies all `.desktop` files across to the host, prefixing their names to ensure unique, and also modifying their `Exec=` stanzas (with `ds64-runner` or `ds64-shell -c`, as appropriate) to allow direct invocation from a 32-bit context. Desktop files without `Type=Application` are ignored, and any prior desktop files at the target location in the host, which have `NoDisplay=true` set, will not be overwritten. Also copies contents of `/usr/share/{icons,pixmaps}` from the guest into the host (at `/usr/share/gdm/{icons,pixmaps}`), so (most) referenced icons will resolve, and reloads the (host's) main menu, so these changes are picked up.
  
  The net effect of this script is that when a new 64-bit application is installed in the guest, a menu entry to launch it (so it can play audio, display on the desktop etc.) should auto-magically get added to the guest's main menu, complete with icon. Such items will also be automatically removed should the package subsequently be uninstalled. Please note that the script will wait for all `apt-get`, `apt` and `dpkg` processes to complete before making modifications.

* <a id="reflect-passwd"></a>`reflect-passwd`: triggered by a (host) [`path` unit](https://github.com/sakaki-/raspbian-nspawn-64/tree/master/etc-systemd-system#reflect-passwd-path) watching for changes to `/etc/{passwd,shadow,group,gshadow)` within the host. When triggered, reflects user data (including hashed passwords) in the 1000 <= id < 1100 range into the container, ensuring that the primary group is also present. Removes clashing users or groups from the guest, and ensures that reflected users are members of groups cited in `$USE_GROUP` (see the script for details), iff such groups are present on the guest.
  
  The net effect of this script is that if you change password or create a new user on the host, it should auto-magically be carried over into the guest as well. No equivalent propagation of changes from guest to host is provided.
