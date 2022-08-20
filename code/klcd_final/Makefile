#
#  Makefile to build external module "klcd" on Raspberry Pi.
#  It should be named 'Makefile'.
#

ifneq ($(KERNELRELEASE),)

# kbuild part of makefile -------------------------------------------------------------------------

include Kbuild

else

# normal makefile ---------------------------------------------------------------------------------

KDIR ?= /lib/modules/`uname -r`/build
PWD := `pwd`
KERNELRELEASE ?= $(shell uname -r)
TEMP_FILE := $(shell mktemp -u)

#
# Forward targets to KBuild (run 'make help' for more information)
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

install:
	@if [ ! -r klcd.ko ]; then \
	  echo "'klcd.ko' missing. Run 'make' first!" 2>&1; exit 1; \
	fi
	@if [ "$(shell id -u)" != "0" ]; then \
	  echo "You are not root, run this target as root please!" 2>&1; exit 1; \
	fi
	@echo "-- copy 'klcd.ko' to '/lib/modules/`uname -r`/extra/' and run depmod --"
	make modules_install 2>&1 | tee $(TEMP_FILE)
	@if grep "Warning: modules_install: missing 'System.map' file. Skipping depmod." $(TEMP_FILE); \
	then \
	  echo "-- 'System.map' missing. Running depmod manually using 'Module.symvers'. --"; \
	  cd /usr/src/linux-headers-`uname -r`; \
	  /sbin/depmod -ae -E $(KDIR)/Module.symvers $(KERNELRELEASE); \
	fi
	@if [ -f $(TEMP_FILE) ]; then rm $(TEMP_FILE); fi
	@echo "-- copy 'klcd.conf' to '/etc/modules-load.d/' --"
	cp klcd.conf /etc/modules-load.d/
	chmod u+rw,g+r,o+r /etc/modules-load.d/klcd.conf
	@echo "-- copy 'klcd.rules' to '/etc/udev/rules.d/' --"
	cp klcd.rules /etc/udev/rules.d/
	chmod u+rw,g+r,o+r /etc/udev/rules.d/klcd.rules

uninstall:
	@if [ "$(shell id -u)" != "0" ]; then \
	  echo "You are not root, run this target as root please!" 2>&1; exit 1; \
	fi
	@if [ -r /lib/modules/`uname -r`/extra/klcd.ko ]; then \
	  echo "-- delete 'klcd.ko' from '/lib/modules/`uname -r`/extra/' --"; \
	  rm /lib/modules/`uname -r`/extra/klcd.ko; \
	fi
	@if [ -r /lib/modules/`uname -r`/extra/klcd.ko.gz ]; then \
	  echo "-- delete 'klcd.ko.gz' from '/lib/modules/`uname -r`/extra/' --"; \
	  rm /lib/modules/`uname -r`/extra/klcd.ko.gz; \
	fi
	@if [ -r /lib/modules/`uname -r`/extra/klcd.ko.xz ]; then \
	  echo "-- delete 'klcd.ko.xz' from '/lib/modules/`uname -r`/extra/' --"; \
	  rm /lib/modules/`uname -r`/extra/klcd.ko.xz; \
	fi
	@if [ -r /lib/modules/`uname -r`/extra/klcd.ko.zst ]; then \
	  echo "-- delete 'klcd.ko.zst' from '/lib/modules/`uname -r`/extra/' --"; \
	  rm /lib/modules/`uname -r`/extra/klcd.ko.zst; \
	fi
	@echo "-- Running depmod using 'Module.symvers'. --"
	@cd /usr/src/linux-headers-`uname -r`; \
	/sbin/depmod -ae -E $(KDIR)/Module.symvers $(KERNELRELEASE)
	@echo "-- delete 'klcd.conf' from '/etc/modules-load.d/' --"
	@if [ -f /etc/modules-load.d/klcd.conf ]; then \
	  rm /etc/modules-load.d/klcd.conf; \
	fi
	@echo "-- delete 'klcd.rules' from '/etc/udev/rules.d/' --"
	@if [ -f /etc/udev/rules.d/klcd.rules ]; then \
	  rm /etc/udev/rules.d/klcd.rules; \
	fi

insmod:
	@if [ "$(shell id -u)" != "0" ]; then \
	  echo "You are not root, run this target as root please!" 2>&1; exit 1; \
	fi
	@if [ -r klcd.ko.zst ]; then \
	  echo "-- load module with 'insmod klcd.ko.zst' --"; \
	  insmod klcd.ko.zst; \
	elif [ -r klcd.ko.gz ]; then \
	  echo "-- load module with 'insmod klcd.ko.gz' --"; \
	  insmod klcd.ko.gz; \
	elif [ -r klcd.ko.xz ]; then \
	  echo "-- load module with 'insmod klcd.ko.xz' --"; \
	  insmod klcd.ko.xz; \
	else \
	  echo "-- load module with 'insmod klcd.ko' --"; \
	  insmod klcd.ko; \
	fi
	@echo "-- change access --"
	chmod a+w /dev/klcd

rmmod:
	@if [ "$(shell id -u)" != "0" ]; then \
	  echo "You are not root, run this target as root please!" 2>&1; exit 1; \
	fi
	@echo "-- unload module with 'rmmod klcd' --"
	rmmod klcd

.PHONY: clean help install insmod rmmod

# -------------------------------------------------------------------------------------------------

endif
