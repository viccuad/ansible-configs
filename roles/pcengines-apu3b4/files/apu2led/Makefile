all: $(MODULE)
	gcc -o apu2led apu2led.c

install:
	install -D apu2led /usr/bin/apu2led
	install -D apu2ledd.service /etc/systemd/system/apu2ledd.service

distclean: clean

clean:
	rm -f *.o apu2led
