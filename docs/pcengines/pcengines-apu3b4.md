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
  console=ttyS0,115200n8 vga=off
  ```

Connect the Ethernet cable to the port closer to the serial port (that's the
first interface).

For the partitioning scheme, don't use encryption (unless you want to connect by
serial console on reboot or use cryptsetup-initramfs). Since you can extend
partitions in plinth, you can leave unused space too.

[1]: http://pcengines.ch/howto.htm#serialconsole
[2]: http://www.tldp.org/HOWTO/Remote-Serial-Console-HOWTO/index.html

# BIOS updating #

All BIOS at https://pcengines.github.io/

## From installation ##

  ```
  $ sudo apt install flashrom
  $ sudo flashrom --read apu3_old.rom --programmer internal
  $ diff <(md5sum apu3_<version>.rom) apu3_<version>.rom.md5
  $ sudo flashrom --write apu3_<version>.rom --programmer internal
  ```

## From USB/SD card ##

```
  $ sudo apt install syslinux syslinux-utils

  Remove any GPT formatting:
  $ sudo dd if=/dev/zero of=/dev/sdX bs=1M

  Format /dev/sdX with a dos mbr and a fat32 partition

  Ensure the drive is bootable:
  $ sudo dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/mbr/mbr.bin of=/dev/sdX 

  Add partition boot record and boot loaders
  $ sudo syslinux --install /dev/sdX1

  Copy TinyCore Linux to the partition. It contains a bootable kernel and flashrom
  Copy the rom to be flashed into the partition
```


# Freedombox #

## Networking ##

The first network port, the one near the serial port, is configured by
FreedomBox to be an upstream Internet link and the remaining 2 ports are
configured for local computers to connect to.
See:
http://freedomboxblog.nl/installing-lxc-dhcp-and-dns-on-my-freedombox

## Plinth ##

Fredoombox's webui is accesible at https://<host>/plinth

## Cockpit ##

Cockpit is available as always at https://<host>:9090

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
