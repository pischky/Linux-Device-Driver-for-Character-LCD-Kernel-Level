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
KERNELRELEASE ?= $(shell uname -r)
TEMP_FILE := $(shell mktemp -u)

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
	sudo -E make modules_install 2>&1 | tee $(TEMP_FILE)
	@if grep "Warning: modules_install: missing 'System.map' file. Skipping depmod." $(TEMP_FILE); \
	then \
	  echo "-- System.map missing. Running depmod manually. --"; \
	  echo "/sbin/depmod -ae -E /lib/modules/$(KERNELRELEASE)/build/Module.symvers $(KERNELRELEASE)"; \
	  sudo /sbin/depmod -ae -E /lib/modules/$(KERNELRELEASE)/build/Module.symvers $(KERNELRELEASE); \
	fi
	@if [ -f $(TEMP_FILE) ]; then sudo rm $(TEMP_FILE); fi 
	# TODO: copy autorun file for systemd

insmod: install
	@echo "-- load module with 'insmod klcd.ko' and change access --"
	sudo insmod klcd.ko
	sudo chmod a+w /dev/klcd

rmmod: install
	@echo "-- unload module with 'rmmod klcd.ko' --"
	sudo rmmod klcd.ko

.PHONY: clean help install insmod rmmod

# -----------------------------------------------------

endif
