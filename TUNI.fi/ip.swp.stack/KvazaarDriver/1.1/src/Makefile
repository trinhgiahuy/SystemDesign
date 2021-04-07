obj-m += ip_acc_driver.o
FLAGS = -O2
ifdef DEBUG
FLAGS += -DDEBUG
endif
ifdef TIMEOUT_ON
FLAGS += -DTIMEOUT_ON
endif

CFLAGS_memory.o := $(FLAGS)

KDIR ?= //TODO: ADD PATH TO KERNEL SOURCE

all:
	make -C $(KDIR) M=$(PWD) CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm modules

clean:
	make -C $(KDIR) M=$(PWD) CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm clean