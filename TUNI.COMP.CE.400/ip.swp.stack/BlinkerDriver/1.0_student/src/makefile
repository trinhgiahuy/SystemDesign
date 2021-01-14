obj-m += blinkerDriver.o
KDIR ?= $(SOC_FPGA_LINUX_SRC_TREE_PATH)
CFLAGS_cameraMapp.o += -O2

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean
