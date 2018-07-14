# First install #

Connect by serial console and a *null-modem cable* as said in [1] ([2] is also a
good read):

  ```
  $ sudo screen /dev/ttyUSB0 115200
  ```
or
  ```
  $ sudo minicom -b 115200 -D /dev/ttyUSB0
  ```

Use gnome-terminal and disable preferences-> Enable the menu accelerator key
(F10 by default) to be able to press F10…

On the debian installer, put the cursor on "Install", press tab
and add the following options:

  ```
  console=ttyS0,115200u8 vga=off
  ```

Connect the Ethernet cable to the port closer to the serial port (that's the
first interface).

For the partitioning scheme, don't use encryption (unless you want to connect by
serial console on reboot). Since you can extend partitions in plinth, you can
leave unused space too.

[1]: http://pcengines.ch/howto.htm#serialconsole
[2]: http://www.tldp.org/HOWTO/Remote-Serial-Console-HOWTO/index.html


# Freedombox #

## Networking ##

The first network port, the one near the serial port, is configured by
FreedomBox to be an upstream Internet link and the remaining 2 ports are
configured for local computers to connect to.
See:
http://freedomboxblog.nl/installing-lxc-dhcp-and-dns-on-my-freedombox