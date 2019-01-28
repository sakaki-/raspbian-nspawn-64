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
   
* <a id="ds64-run"></a>`ds64-run` `path` `<args>`: invokes the (fully-qualified) `path` executable within the 64-bit Debian Stretch (`ds64`) guest OS container (running as the `pi` user), using `systemd-run`, passing any arguments arguments given. Sets an appropriate environment so that the invoked application can use the host's `pulseaudio` server, and X11 display. Example:

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

* <a id="ds64-shell"></a>`ds64-shell`: opens a shell for user `pi` inside the 64-bit guest OS container. You can `sudo` from here: remember that the initial password for `pi` is `raspberry` (and this is *distinct* from any password set for the "parallel universe" `pi` in the host Raspbian OS). Uses `machinectl shell` internally. Note that you *can* run graphical apps from this shell (and they will appear on the host's desktop), but such apps will close when the shell is closed; better to use `ds64-run` or `ds64-runner` from a *host* shell, instead (or alternatively, <kbd>System Tools</kbd>&rarr;<kbd>Run 64-bit Program...</kbd>).  
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

