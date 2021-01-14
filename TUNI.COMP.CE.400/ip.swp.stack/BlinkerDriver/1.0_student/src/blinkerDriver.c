#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/debugfs.h>
#include <linux/slab.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/gpio.h>

#include <asm/uaccess.h>
#include <asm/io.h>
#include <linux/semaphore.h>     
#include <linux/mm.h>
#include <linux/delay.h>

//Called when the module is loaded with insmod
int init_module(void);
//Called when the module is removed with rmmod
void cleanup_module(void);
 
//ACCESSED WITH USER SPACE SYSTEM CALLS:
//Called when open is called for the module
static int device_release(struct inode *, struct file *);
//Called when close is called for the module
static int device_open(struct inode *, struct file *);
//Called when read is called for the module
static ssize_t device_read(struct file *, char *, size_t, loff_t *);
//Called when write is called for the module
static ssize_t device_write(struct file *filp, const char *buff, size_t len, loff_t * off);

//Name of the device when registering it to kernel
#define DEVICE_NAME "blinkerDriver"

//Virtual addresses of the above memory locations. Will be assigned runtime.
uint32_t* fpga_reg_virt = NULL; //FPGA_REG
uint32_t* fpgaportrst_virt = NULL; //FPGAPORTRST
uint8_t* btn_virt = NULL; //Buttons
uint8_t* led_virt = NULL; //LEDs

//major number assigned to the module
static int major = -1;	
//1 = open. Only one may open this module at time!
static int device_Open = 0;
 
int init_module(void)
{
	//Register the device for our use, with the assigned name and file operations.
	//major number will be assigned dynamically and printed (below).
	
	if ( major < 0 )
	{
		printk(KERN_ALERT DEVICE_NAME ": Registering char device failed with %d\n", major);
		return major;
	}
	
	printk(KERN_INFO DEVICE_NAME ": Loading module %s with major %d.\n", DEVICE_NAME, major);
	
	printk(KERN_INFO DEVICE_NAME ": Mapping virtual memory regions.\n");
	
	//remap regions needed to configure FPGA access
	
	//remap regions needed for other devices, the ones behind the FPGA access
	
	printk(KERN_INFO DEVICE_NAME ": Enabling h2f and f2sdram communication.\n");
	
	printk(KERN_INFO DEVICE_NAME ": Done initialization\n");

	return 0;
}

void cleanup_module(void)
{
	//Unmap all regions mapped when module was loaded.
	iounmap(fpga_reg_virt);
	iounmap(fpgaportrst_virt);
	iounmap(btn_virt);
	iounmap(led_virt);
	
	//Unregister the device, so it may be loaded again if needed.
	unregister_chrdev(major, DEVICE_NAME);
	
	printk(KERN_INFO DEVICE_NAME ": Done uninitialization\n");
}

static int device_open(struct inode *inode, struct file *file)
{
	//Already open -> unavailable.
	if (device_Open)
		return -EBUSY;
		
	//Reserve the module. Exit if cant.
	if ( try_module_get(THIS_MODULE)  == 0 )
		return -EBUSY;

	//Mark us open, and thus unavailable.
	device_Open++;
	
	printk(KERN_INFO DEVICE_NAME ": Opened driver\n");

	return 0;
}

static int device_release(struct inode *inode, struct file *file)
{
	//Mark us not open, and thus available.
	module_put(THIS_MODULE);
	device_Open--;
	
	printk(KERN_INFO DEVICE_NAME ": Closed driver\n");

	return 0;
}

static ssize_t device_read( struct file *filp, char *buffer, size_t length, loff_t * offset )
{
	return 0;
}

static ssize_t device_write(struct file *filp, const char *buff, size_t len, loff_t * off)
{
	return 0;
}