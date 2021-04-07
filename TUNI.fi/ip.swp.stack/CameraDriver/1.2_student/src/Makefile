obj-m += camera_driver.o
FLAGS = -O2
ifdef DEBUG
FLAGS += -DDEBUG
endif
ifdef TIMEOUT_ON
FLAGS += -DTIMEOUT_ON
endif

CFLAGS_cameraMap.o := $(FLAGS)

KDIR ?=/home/system_design/linux-socfpga
all:
	make -C $(KDIR) M=$(PWD) CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm modules

clean:
	make -C $(KDIR) M=$(PWD) CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm clean
