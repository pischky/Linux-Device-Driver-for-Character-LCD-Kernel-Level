#
#  Makefile to build external module "klcd" on Raspberry Pi.
#  It should be named 'Makefile'.
#

ifneq ($(KERNELRELEASE),)

# kbuild part of makefile -----------------------------

include Kbuild

else

# normal makefile -------------------------------------

KDIR ?= /lib/modules/`uname -r`/build
PWD := `pwd`

#
# Forward targets to KBuild
#

default:
	$(MAKE) -C $(KDIR) M=$$PWD

modules:
	$(MAKE) -C $(KDIR) M=$$PWD modules

modules_install:
	$(MAKE) -C $(KDIR) M=$$PWD modules_install

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean

help:
	$(MAKE) -C $(KDIR) M=$$PWD help

#
# Module specific targets
#

install: modules
	@echo "-- copy 'klcd.ko' to '/lib/modules/`uname -r`/extra/' and run depmod --"
	sudo -E make modules_install

insmod: install
	@echo "-- load module with 'insmod klcd.ko' --"
	sudo insmod klcd.ko
	sudo chmod a+w /dev/klcd

rmmod: install
	@echo "-- unload module with 'rmmod klcd.ko' --"
	sudo rmmod klcd.ko

.PHONY: clean help install insmod rmmod

# -----------------------------------------------------

endif
