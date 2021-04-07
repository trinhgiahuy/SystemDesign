#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/debugfs.h>
#include <linux/slab.h>
#include <linux/gpio.h>
#include <asm/io.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/cdev.h>

#include <asm/uaccess.h>

#include <linux/jiffies.h>

#include <linux/spinlock.h>
#include <linux/semaphore.h>
#include <asm/atomic.h>

//#define SPINLOCK
#define SEMAPHORE

#if !(defined(SPINLOCK) || defined(SEMAPHORE)) || (defined(SPINLOCK) && defined(SEMAPHORE))
#error Only one lock needs to be chosen
#endif

struct Accelerator
{
    // FPGA init
    uint32_t* fpga_reg_virt;
    uint32_t* fpgaportrst_virt;
    
    // Coherent memory
    uint8_t* unfilt1_virt;
    uint8_t* unfilt2_virt;
    uint8_t* orig_virt;
    
    // SAD result
    uint32_t* sad_virt;
    // SAD result2
    uint32_t* sad_virt2;
    
    // Config pointer
    uint32_t* config_virt;
    
    // DMA pointers
    uint32_t* unfilt1_dma_virt;
    uint32_t* unfilt2_dma_virt;
    uint32_t* orig_dma_virt;
    
    // PIO pointers
    uint32_t* result_ready;
    uint32_t* lcu_loaded;
    uint32_t* lambda_loaded;
    
    // LCU config value
    uint32_t lcu_config;
    
    // LCU number
    uint32_t lcu_num;
    
    // Saved SAD result
    uint32_t sad_result;
    
    // Saved SAD result2
    uint32_t sad_result2;
    
    // Accelerator lock
#if defined(SPINLOCK)
    spinlock_t busy;
#elif defined(SEMAPHORE)
    struct semaphore busy;
#endif
    // IOCTL set location for Read/Write
    uint8_t location;
};

#define UNFILT1_DATA    0x30010000
#define UNFILT2_DATA    0x30020000
#define ORIG_BLOCK      0x30030000

#define SAD_RESULT      0x000
#define SAD_RESULT2     0x010
#define RESULT_READY    0x020
#define LCU_LOADED      0x030
#define LAMBDA_LOADED   0x040
#define UNFILT1_DMA     0x100
#define UNFILT2_DMA     0x200
#define ORIG_DMA        0x300
#define IP_CONFIG       0x400


#define POLL(val) while(ioread32((val)+3) == 0)
#define CLEAR(val) *((val)+3) = 1; //iowrite32(1,(val)+3);
#define ENABLE_IRQ(val,mask) iowrite32((mask),(val)+2);
#define INFO_PRINT(val) printk(KERN_INFO DEVICE_NAME ": %s\n",(val));

//Number of our interrupt recognized by kernel.
//Sources: Cyclone V data sheet stating 72 as the base number
//for the first interrupt controller.
#define IRQ_BASE 72

#define RESULT_READY_IRQ  0
#define LCU_LOADED_IRQ    1
#define LAMBDA_LOADED_IRQ 2

//Called when close is called for the module
static int device_release(struct inode *, struct file *);
//Called when open is called for the module
static int device_open(struct inode *, struct file *);
//Called when ioctl is called for the module
static long ioctl (struct file *, unsigned int,  unsigned long);

static ssize_t device_read(struct file *, char *, size_t, loff_t *);
static ssize_t device_write(struct file *filp, const char *buff, size_t len, loff_t * off);

static void ip_acc_configuration(struct Accelerator* ip_acc_t);

struct Accelerator* ip_acc_global;

//Map corresponding kernel space functions to system calls
struct file_operations fops =
{
	.read = device_read,
	.write = device_write,
	.open = device_open,
	.release = device_release,
	.unlocked_ioctl = ioctl
};

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Panu Sjövall");
MODULE_DESCRIPTION("Intra prediction accelerator HW interface");
MODULE_SUPPORTED_DEVICE("FPGA image with IP acc");

//Name of the device when registering it to kernel
#define DEVICE_NAME "kvazaar_ip_acc"

//Register used to enable access to FPGA from HPS
#define FPGA_REG         0xff800000
//Base address for accessing FPGA via LWH2F channel
#define LWH2F_BASE       0xff200000
//Base address for accessing FPGA via H2F channel
#define H2F_BASE         0xc0000000
//Used to enable FPGA access to HPS sdram, aka HPS DDR
#define FPGAPORTRST      0xffc25080

//Virtual addresses of the above memory locations. Will be assigned runtime.

//major number assigned to the module
static int major;
static int minor;

struct cdev* cdev;
//Class of the accelerator devices initialized in this module
static struct class *device_class = NULL;
//Device number
dev_t devno;

//1 = open. Only one may open this module at time!
static int device_Open = 0;

irqreturn_t fpga_interrupt(int irq, void *dev_id)
{
    //Must check that it indeed is the correct interrupt!
    if (irq == IRQ_BASE + RESULT_READY_IRQ)
    {
	uint32_t result_id = ioread32(ip_acc_global->result_ready+3);
	if(result_id == 1)
        {
            ip_acc_global->sad_result = *ip_acc_global->sad_virt;
        }
        if(result_id == 2)
        {
            ip_acc_global->sad_result2 = *ip_acc_global->sad_virt2;
        }
        CLEAR(ip_acc_global->result_ready);
#if defined(SPINLOCK)
        spin_unlock(&ip_acc_global->busy);
#elif defined(SEMAPHORE)
	up(&ip_acc_global->busy);
#endif
    }
    else if (irq == IRQ_BASE + LCU_LOADED_IRQ)
    {
	CLEAR(ip_acc_global->lcu_loaded);
#if defined(SPINLOCK)
        spin_unlock(&ip_acc_global->busy);
#elif defined(SEMAPHORE)
	up(&ip_acc_global->busy);
#endif
    }
    else if (irq == IRQ_BASE + LAMBDA_LOADED_IRQ)
    {
        CLEAR(ip_acc_global->lambda_loaded);
#if defined(SPINLOCK)
        spin_unlock(&ip_acc_global->busy);
#elif defined(SEMAPHORE)
	up(&ip_acc_global->busy);
#endif
    }
    else
    {
        return IRQ_NONE;
    }
    
    return IRQ_HANDLED;
}

static int create_device(void)
{

    //Variable used in some initialization calls.
    dev_t dev = 0;
    //Used the index device under initialization

    struct device *device = NULL;
    //Device number
    //Return value of some calls. Also return value of this function, if fails!
    int ret;

    cdev = cdev_alloc();

    ret = alloc_chrdev_region(&dev, 0, 1, DEVICE_NAME);

    major = MAJOR(dev);
    minor = MINOR(dev);

    if ( ret < 0 )
    {
        printk(KERN_ALERT DEVICE_NAME ": Registering device region failed\n");
        return ret;
    }

    printk(KERN_INFO DEVICE_NAME ": Loading module %s with major %d.\n",DEVICE_NAME, major);

    //Create device class for the accelerators
    device_class= class_create(THIS_MODULE, DEVICE_NAME);

    if ( IS_ERR(device_class) )
    {
        printk(KERN_ALERT DEVICE_NAME ": Creating device class failed\n");
        return PTR_ERR(device_class);
    }
    
    devno = MKDEV(major, minor);

    //Initialize cdev. Every instance gets the same file operations
    cdev_init(cdev, &fops);
    cdev->owner = THIS_MODULE;
	
    ret = cdev_add(cdev, devno, 1);

    if ( ret )
    {
        printk(KERN_ALERT DEVICE_NAME " %d: could not add cdev!\n", minor );
        return ret;
    }
	
    //Create and register the device to filesystem
    device = device_create(device_class, NULL, devno, NULL, DEVICE_NAME);

    if ( IS_ERR( device ) )
    {
        ret = PTR_ERR(device);
        printk(KERN_ALERT DEVICE_NAME ": could not create device!\n");
        cdev_del(cdev);
        return ret;
    }

    printk(KERN_INFO DEVICE_NAME ": Done init\n");
	
    return 0;
}

static void ip_acc_configuration(struct Accelerator* ip_acc_t)
{
    // Set memory addresses for DMAs
	ip_acc_t->unfilt1_dma_virt[2] = UNFILT1_DATA;
	ip_acc_t->unfilt2_dma_virt[2] = UNFILT2_DATA;
	ip_acc_t->orig_dma_virt[2] = ORIG_BLOCK;
    // Orig DMA read size always 4096
	((uint16_t*)ip_acc_t->orig_dma_virt)[7] = 4096;
	
#if defined(SPINLOCK)
	spin_lock_init(&ip_acc_t->busy);
#elif defined(SEMAPHORE)
	sema_init(&ip_acc_global->busy, 1);
#endif

    // Enable IRQ in altera PIOs
	ENABLE_IRQ(ip_acc_t->result_ready,0x3);
	ENABLE_IRQ(ip_acc_t->lcu_loaded,0x1);
	ENABLE_IRQ(ip_acc_t->lambda_loaded,0x1);
}

static int __init memory_init_module(void)
{
	struct Accelerator* ip_acc = (struct Accelerator*)kzalloc(sizeof(struct Accelerator), GFP_KERNEL);
	ip_acc_global = ip_acc;
	ip_acc->location = 0;
	
	create_device();
	
	printk(KERN_INFO "%s: Loading module with major %d.\n", DEVICE_NAME, major);
	
	//remap regions needed to configure FPGA access
	ip_acc->fpga_reg_virt 	 = (uint32_t*)ioremap_nocache(FPGA_REG,4);
	ip_acc->fpgaportrst_virt = (uint32_t*)ioremap_nocache(FPGAPORTRST,4);
	
	ip_acc->unfilt1_virt 	 = (uint8_t*)ioremap_nocache(UNFILT1_DATA,72);
	ip_acc->unfilt2_virt 	 = (uint8_t*)ioremap_nocache(UNFILT2_DATA,72);
	ip_acc->orig_virt     	 = (uint8_t*)ioremap_nocache(ORIG_BLOCK,4096);

	ip_acc->sad_virt    	 = (uint32_t*)ioremap_nocache(H2F_BASE + SAD_RESULT,16);
	ip_acc->sad_virt2    	 = (uint32_t*)ioremap_nocache(H2F_BASE + SAD_RESULT2,16);
	
	ip_acc->config_virt      = (uint32_t*)ioremap_nocache(H2F_BASE + IP_CONFIG,16);
	ip_acc->unfilt1_dma_virt = (uint32_t*)ioremap_nocache(H2F_BASE + UNFILT1_DMA,255);
	ip_acc->unfilt2_dma_virt = (uint32_t*)ioremap_nocache(H2F_BASE + UNFILT2_DMA,255);
	ip_acc->orig_dma_virt    = (uint32_t*)ioremap_nocache(H2F_BASE + ORIG_DMA,255);
	
	ip_acc->result_ready 	 = (uint32_t*)ioremap_nocache(H2F_BASE + RESULT_READY,16);
	ip_acc->lcu_loaded 	 	 = (uint32_t*)ioremap_nocache(H2F_BASE + LCU_LOADED,16);
	ip_acc->lambda_loaded 	 = (uint32_t*)ioremap_nocache(H2F_BASE + LAMBDA_LOADED,16);

	//return value from interrupt request
	
	printk(KERN_INFO DEVICE_NAME ": Enabling interrupt.\n");
	
	//request the interrupt for our use.	
	if (request_irq(IRQ_BASE + RESULT_READY_IRQ, fpga_interrupt,IRQF_TRIGGER_RISING , "result_ready_irq", NULL) < 0)
	{
		printk(KERN_ALERT DEVICE_NAME ": Failure requesting irq %i\n", IRQ_BASE + RESULT_READY_IRQ);
	}
	
	//request the interrupt for our use.	
	if (request_irq(IRQ_BASE + LCU_LOADED_IRQ, fpga_interrupt, IRQF_TRIGGER_RISING, "lcu_loaded_irq", NULL) < 0)
	{
		printk(KERN_ALERT DEVICE_NAME ": Failure requesting irq %i\n", IRQ_BASE + LCU_LOADED_IRQ);
	}
	
	//request the interrupt for our use.	
	if (request_irq(IRQ_BASE + LAMBDA_LOADED_IRQ, fpga_interrupt, IRQF_TRIGGER_RISING, "lambda_loaded_irq", NULL) < 0)
	{
		printk(KERN_ALERT DEVICE_NAME ": Failure requesting irq %i\n", IRQ_BASE + LAMBDA_LOADED_IRQ);
	}
	
	//f2f & lwh2f enable
	iowrite32(0x18, ip_acc->fpga_reg_virt);
	//f2sdram enable
	iowrite32(0x3fff, ip_acc->fpgaportrst_virt);

	return 0;
}

static void __exit memory_exit_module(void)
{
	//Unmap all regions mapped when module was loaded.
	iounmap(ip_acc_global->fpga_reg_virt);
	iounmap(ip_acc_global->fpgaportrst_virt);
	iounmap(ip_acc_global->unfilt1_virt);
	iounmap(ip_acc_global->unfilt2_virt);
	iounmap(ip_acc_global->orig_virt);
	iounmap(ip_acc_global->config_virt);
	iounmap(ip_acc_global->orig_dma_virt);
	
	iounmap(ip_acc_global->result_ready);
	iounmap(ip_acc_global->lcu_loaded);
	iounmap(ip_acc_global->lambda_loaded);

	free_irq(IRQ_BASE + RESULT_READY_IRQ,NULL);
	free_irq(IRQ_BASE + LCU_LOADED_IRQ,NULL);
	free_irq(IRQ_BASE + LAMBDA_LOADED_IRQ,NULL);
	
	kfree(ip_acc_global);

	cdev_del(cdev);
	
	device_destroy(device_class,devno);
	class_destroy(device_class);
	
	//Unregister the device, so it may be loaded again if needed.
	unregister_chrdev_region(major,1);

	printk(KERN_INFO "%s: Done uninitialization\n",DEVICE_NAME);
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

	//Open mutex if it was left locked
#if defined(SPINLOCK)
	spin_unlock(&ip_acc_global->busy);
#elif defined(SEMAPHORE)
	sema_init(&ip_acc_global->busy, 1);
#endif

	ip_acc_configuration(ip_acc_global);

	file->private_data = (void*)ip_acc_global;

	return 0;
}

static int device_release(struct inode *inode, struct file *file)
{
	//Mark us not open, and thus available.
	device_Open--;
	module_put(THIS_MODULE);
	
	return 0;
}

static long ioctl (struct file *file, unsigned int cmd,  unsigned long arg)
{
	//Branch depending on which command is issued, if unknown, return error.
	struct Accelerator* ip_acc_local = (struct Accelerator*)file->private_data;
	int ret = 0;
#if defined(SPINLOCK)
	spin_lock(&ip_acc_local->busy);
#elif defined(SEMAPHORE)
	if ( down_interruptible(&ip_acc_local->busy) != 0 )
	{
	    printk(KERN_ALERT DEVICE_NAME ": IOCTL semaphore interrupted by user!\n");
	    return -1;
	}
#endif

	switch( cmd )
	{
	case 0:
	{
	    ip_acc_local->location = arg;
	    break;
	}
	case 1:
	{
	    ip_acc_local->location = 2;
	    
	    // Set lcu_config data
	    
	    // Which LCU table is updated on IP ACC
	    ip_acc_local->lcu_config = arg<<28;
	    // MBS up to indicate IP ACC for LCU load
	    ip_acc_local->lcu_config |= 0x80000000;
	    // Set LCU num
	    ip_acc_local->lcu_config += ip_acc_local->lcu_num;
	    ip_acc_local->lcu_num++;
	    if(ip_acc_local->lcu_num == 0x8000000)
	    {
		ip_acc_local->lcu_num = 0;
	    }
	    break;
	}
	default:
	    return -1;
	}
	return ret;
}

static ssize_t device_read(struct file *filp, char *buffer, size_t length, loff_t * offset)
{	
	uint32_t* values;
	struct Accelerator* ip_acc_local = (struct Accelerator*)filp->private_data;

#if defined(SPINLOCK)
	spin_lock(&ip_acc_local->busy);
#elif defined(SEMAPHORE)
	if ( down_interruptible(&ip_acc_local->busy) != 0 )
	{
	    printk(KERN_ALERT DEVICE_NAME ": READ semaphore interrupted by user!\n");
	    return -1;
	}
#endif

	values = (uint32_t*)buffer;

	// check which result to return
	if(*offset == 0)
	{
	    //mode
	    values[0] = ip_acc_local->sad_result >> 24;
	    //cost 
	    values[1] = ip_acc_local->sad_result & 0xffffff;
	}
	else if(*offset == 1)
	{
	    //mode
	    values[0] = ip_acc_local->sad_result2 >> 24;
	    //cost 
	    values[1] = ip_acc_local->sad_result2 & 0xffffff;
	}
#if defined(SPINLOCK)
	spin_unlock(&ip_acc_local->busy);
#elif defined(SEMAPHORE)
	up(&ip_acc_global->busy);
#endif

	return length;
}
static ssize_t device_write(struct file *filp, const char *buff, size_t len, loff_t * off)
{
	uint8_t* values = (uint8_t*)buff;
	uint32_t y = 0;
	struct Accelerator* ip_acc_local = (struct Accelerator*)filp->private_data;
	
	if(ip_acc_local->location == 0)
	{
		memcpy(ip_acc_local->unfilt1_virt,values,len);
		((uint16_t*)ip_acc_local->unfilt1_dma_virt)[7] = len;
		ip_acc_local->unfilt1_dma_virt[0] = 2;
		ip_acc_local->location = 1;
	}
	else if(ip_acc_local->location == 1)
	{
		memcpy(ip_acc_local->unfilt2_virt,values,len);
		// Set length for DMA to read
		((uint16_t*)ip_acc_local->unfilt2_dma_virt)[7] = len;
		
		// Start DMAs
		ip_acc_local->unfilt2_dma_virt[0] = 2;
		
		ip_acc_local->location = 3;
	}
	else if(ip_acc_local->location == 2)
	{
		for (y = 0; y < 64; ++y)
		{
		    memcpy(&ip_acc_local->orig_virt[y*64],&values[y*len],64);
		}

		// Start DMA
		ip_acc_local->orig_dma_virt[0] = 2;

		// Configure IP ACC to receive orig
		*ip_acc_local->config_virt = ip_acc_local->lcu_config;
	}
	else if(ip_acc_local->location == 3)
	{
		int x = 0;
		uint32_t* configs = (uint32_t*)buff;

		for(x = 0; x < len/4;x++)
		{
		    *ip_acc_local->config_virt = configs[x];
		}
	}
	else if(ip_acc_local->location == 4)
	{
		int x = 0;
		uint32_t* configs = (uint32_t*)buff;

		// second MSB to indicate Lambda send
		configs[x] |= 0x40000000;
		*ip_acc_local->config_virt = configs[x];
				
		ip_acc_local->lcu_num = 0;
	}
	else
	{
		len = 0;
	}
	return len;
}

module_init(memory_init_module);
module_exit(memory_exit_module);
