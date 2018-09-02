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
serial console on reboot or use cryptsetup-initramfs). Since you can extend
partitions in plinth, you can leave unused space too.

[1]: http://pcengines.ch/howto.htm#serialconsole
[2]: http://www.tldp.org/HOWTO/Remote-Serial-Console-HOWTO/index.html

# BIOS updating #

  ```
  $ sudo apt install flashrom
  $ sudo flashrom --read apu3_old.rom --programmer internal
  $ diff <(md5sum apu3_<version>.rom) apu3_<version>.rom.md5
  $ sudo flashrom --write apu3_<version>.rom --programmer internal
  ```


# Freedombox #

## Networking ##

The first network port, the one near the serial port, is configured by
FreedomBox to be an upstream Internet link and the remaining 2 ports are
configured for local computers to connect to.
See:
http://freedomboxblog.nl/installing-lxc-dhcp-and-dns-on-my-freedombox


## 1und1.de pppoe ##

Internet Service Provider                 Benutzerdefiniert
Login-Name                                Ihre Internetzugangskennung (z. B. 1und1/1234-567@online.de)
Passwort                                  Ihr Internetzugangspasswort
Passwort wiederholen                      Ihr Internetzugangspasswort
Einstellung zur Automatischen Trennung    Aus (nur bei Flatrate-Tarifen)
Protokoll                                 PPPoE
Encapsulation                             LLC/SNAP
VPI                                       1
VCI                                       32
