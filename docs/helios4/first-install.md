connect miniusb to usb cable for serial port
```
  $ sudo screen /dev/ttyUSB0 115200
```

Default credential for Debian image:
```
helios4 login: root
Password: 1234
```

If you wish to manually configure your IP address you can use the armbian-config
tool.

```
sudo armbian-config -> network -> ip
```

For other software you can use armbian-config which provides an easy way to
install 3rd party applications. You can also refer to our Software section to
find tutorials that will help you to setup manually your Helios4.

```
sudo armbian-config
```

