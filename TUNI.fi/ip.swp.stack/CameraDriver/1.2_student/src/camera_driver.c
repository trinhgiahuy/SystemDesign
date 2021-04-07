#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/debugfs.h>
#include <linux/slab.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/gpio.h>
#include <linux/cdev.h>

#include <asm/uaccess.h>
#include <asm/io.h>
#include <linux/semaphore.h>     
#include <linux/mm.h>
#include <linux/delay.h>

#include <linux/kdev_t.h>

// Send signal for FPGA to read and set configures
// PRECONDITION: h2f and f2sdram are enabled.
static void configure_signal(void);

// configure hw
// PRECONDITION: h2f and f2sdram are enabled.
static void configure_hw(void);
 
// ACCESSED WITH USER SPACE SYSTEM CALLS:
// Called when open is called for the module
static int device_release(struct inode *, struct file *);
// Called when close is called for the module
static int device_open(struct inode *, struct file *);
// Called when ioctl is called for the module
static long ioctl (struct file *, unsigned int,  unsigned long);
// Called when read is called for the module
static ssize_t device_read(struct file *, char *, size_t, loff_t *);

// Map corresponding kernel space functions to system calls
struct file_operations fops =
{
    .open = device_open,
    .release = device_release,
    .read = device_read,
    .unlocked_ioctl = ioctl
};

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Janne Virtanen / Panu Sjövall");
MODULE_DESCRIPTION("Used for controlling camera and reading yuv data");
MODULE_SUPPORTED_DEVICE("FPGA image with camera HW");

// Name of the device when registering it to kernel
#define DEVICE_NAME "cyclone_v_camera"

// Register used to enable access to FPGA from HPS
#define FPGA_REG         0xff800000
// Base address for accessing FPGA via LWH2F channel
#define LWH2F_BASE       0xff200000
// Base address for accessing FPGA via H2F channel
#define H2F_BASE         0xc0000000
// Used to enable FPGA access to HPS sdram, aka HPS DDR
#define FPGAPORTRST      0xffc25080

// Location of CONFIG_CAMERA is used to send configuration signal
// It is in h2f
#define CONFIG_CAMERA_PIO_LOC 0x2100
// Location of NEXT_FRAME is used to signaling whether saving the next frame
// It is in h2f
#define YUV_CTRL_PIO_LOC 0x2200
// Location of CAMERA_STATUS controller used to receive interrupts from FPGA
// It is in h2f
#define YUV_STATUS_PIO_LOC 0x2300
// Size of the both above regions
#define PIO_SIZE 16
// Location of On-chip memory used feed configures to FPGA
// It is in h2f
#define ONCHIP_LOC 0x2000
// The size of the above memory
#define ONCHIP_SIZE 128
// Location of the frame written by FPGA
// It is in HPS DDR

// Struct for YUV information
struct yuv_t
{
    uint16_t width;
    uint16_t height;
    uint32_t y_loc;
    uint32_t u_loc;
    uint32_t v_loc;
    uint32_t luma_size;
    uint32_t chroma_size;
    uint32_t image_size;
    uint8_t resolution;
};

struct yuv_t yuv_info;

// YUV DMA Location
#define YUV_DMA 0x1100

// Virtual addresses of the above memory locations. Will be assigned runtime.
// The IMAGE_LOC is exception, as it is assigned to the user space process!
uint32_t* fpga_reg_virt = NULL; // FPGA_REG
uint32_t* fpgaportrst_virt = NULL; // FPGAPORTRST
uint32_t* config_camera_virt = NULL; // CONFIG_CAMERA_PIO_LOC
uint32_t* yuv_ctrl_virt = NULL; // YUV_CTRL_PIO
uint32_t* yuv_status_virt = NULL; // YUV_STATUS_PIO_LOC
uint16_t* onchip_virt = NULL; // CAMERA_CONTROL_OC
uint8_t* frame_virt = NULL; // HPS-DDR

#define DMA_SIZE 256
uint32_t* yuv_dma_virt = NULL;

// Semaphore used wake up the ioctl call waiting for interrupt.
struct semaphore sem;

// Number of our interrupt recognized by kernel.
// Source: Some Cyclone V data sheet stating 72 as the base number for the first interrupt controller.
#define IRQ_BASE 72
// TODO: define FRAME_IRQ_OFFSET to the irq number you set in QSYS
#define FRAME_IRQ

// The interrupt routine
static irqreturn_t frame_interrupt(int irq, void *dev_id)
{
    //TODO: Check that the interrupt was ours
    
    //TODO: Acknowledge interrupt and disable frame interrupts
    
    //TODO: Up the semaphore to indicate that a frame is ready
    
    //TODO: return value
}

// major number assigned to the module
static int major;
static int minor;
struct cdev* cdev;
// Class of the accelerator devices initialized in this module
static struct class *device_class = NULL;
// Device number
dev_t devno;
// 1 = open. Only one may open this module at time!
static int device_Open = 0;


// 0, if each frame has to be ordered
static int continuous = 1;
 
static void configure_signal(void)
{
    // LSB = 1 means that configures need to be set
    iowrite32(0x01, config_camera_virt);
    // Busy-loop delay is preferred to sleep in this case, as it causes less overhead.
    ndelay(10);
    // It is a rising edge signal, so return to zero after it is received.
    iowrite32(0x00, config_camera_virt);
}

static void configure_hw(void)
{
    iowrite32(0, yuv_ctrl_virt);
        
    // Setting the default configures:
    iowrite16(0x000F,  onchip_virt); // green1 gain
    iowrite16(0x020F,  onchip_virt + 1); // blue gain
    iowrite16(0x020F,  onchip_virt + 2); // red gain
    iowrite16(0x0008,  onchip_virt + 3); // green2 gain
	
    // More information about gains at Camera Hardware.pdf at page 25
	
    iowrite16(0x01E0,  onchip_virt + 4); // start row
    iowrite16(0x0212,  onchip_virt + 5); // start column
    iowrite16(0x03BF,  onchip_virt + 6); // row size = height*skip-1
    iowrite16(0x063F,  onchip_virt + 7); // column size = width*skip-1
    iowrite16(0x0011,  onchip_virt + 8); // row mode, including bin=3 & skip=3
    iowrite16(0x0011,  onchip_virt + 9); // column mode, including bin=3 & skip=3


    // stop DMA
    iowrite32(16,yuv_dma_virt);
    
    // wait DMA to stop
    while(ioread32(yuv_dma_virt+1) == 0);

    // Set memory addresses for luma and chromas
    iowrite32(yuv_info.y_loc,yuv_dma_virt + 2);
    iowrite32(yuv_info.u_loc,yuv_dma_virt + 3);
    iowrite32(yuv_info.v_loc,yuv_dma_virt + 4);
    
    // Set luma and chroma bytes
    iowrite32(yuv_info.luma_size,yuv_dma_virt + 6);
    iowrite32(yuv_info.chroma_size,yuv_dma_virt + 7);
}

static int create_device(void)
{
    // Used the index device under initialization
    struct device *device = NULL;
    // Return value of some calls. Also return value of this function, if fails!
    int ret;

    // Register range of device numbers. One is enough, with zero as the minor.
    ret = alloc_chrdev_region(&devno, 0, 1, DEVICE_NAME);
    
    if (ret < 0)
    {
        printk(KERN_ALERT DEVICE_NAME ": Registering device region failed\n");
        return major;
    }
    
    // Now we know the major and minor.
    major = MAJOR(devno);
    minor = MINOR(devno);

    printk(KERN_INFO DEVICE_NAME ": Loading module %s with major %d minor %d.\n", DEVICE_NAME, major, minor);

    // Must create a device class for the module.
    device_class = class_create(THIS_MODULE, DEVICE_NAME);

    if (IS_ERR(device_class))
    {
        printk(KERN_ALERT DEVICE_NAME ": Creating device class failed\n");
        return PTR_ERR(device_class);
    }

    // Allocate the character device.
    cdev = cdev_alloc();
    // Initialize character device. This is also where it gets to know its file operations.
    cdev_init(cdev, &fops);
    cdev->owner = THIS_MODULE;
	
    // Then add the created character device to the system.
    ret = cdev_add(cdev, devno, 1);

    if (ret)
    {
        printk(KERN_ALERT DEVICE_NAME " %d: could not add cdev!\n", minor);
        return ret;
    }
	
    // Create and register the device to filesystem
    device = device_create(device_class, NULL, devno, NULL, DEVICE_NAME);

    if (IS_ERR( device))
    {
        ret = PTR_ERR(device);
        printk(KERN_ALERT DEVICE_NAME ": could not create device!\n");
        cdev_del(cdev);
        return ret;
    }

    printk(KERN_INFO DEVICE_NAME ": Done init\n");
	
    return 0;
}

// The default parameters of frame
#define DEFAULT_WIDTH 800
#define DEFAULT_HEIGHT 480
#define DEFAULT_SIZE DEFAULT_WIDTH*DEFAULT_HEIGHT*3/2

static int __init camera_init_module(void)
{
    // Register the device for our use, with the assigned name and file operations.
    // major number will be assigned dynamically and printed (below).
	
    create_device();

    printk(KERN_INFO "%s: Loading module with major %d.\n", DEVICE_NAME, major);

    // map memory regions for the personal use of the driver.
	
    // remap regions needed to configure FPGA access
    fpga_reg_virt = (uint32_t*)ioremap_nocache(FPGA_REG,4);
    fpgaportrst_virt = (uint32_t*)ioremap_nocache(FPGAPORTRST,4);
	
    // remap regions needed for other devices, the ones behind the FPGA access
    config_camera_virt  = (uint32_t*)ioremap_nocache(H2F_BASE+CONFIG_CAMERA_PIO_LOC,PIO_SIZE);
    yuv_ctrl_virt  = (uint32_t*)ioremap_nocache(H2F_BASE+YUV_CTRL_PIO_LOC,PIO_SIZE);
    yuv_status_virt  = (uint32_t*)ioremap_nocache(H2F_BASE+YUV_STATUS_PIO_LOC,PIO_SIZE);
    onchip_virt  = (uint16_t*)ioremap_nocache(H2F_BASE+ONCHIP_LOC,ONCHIP_SIZE);

    // remap color DMAs
    yuv_dma_virt = (uint32_t*)ioremap_nocache(H2F_BASE+YUV_DMA,DMA_SIZE);

    // Set YUV info to default resolution
    yuv_info.width = DEFAULT_WIDTH;
    yuv_info.height = DEFAULT_HEIGHT;
    yuv_info.y_loc =  0x38000000;
    yuv_info.luma_size = yuv_info.width*yuv_info.height;
    yuv_info.u_loc =  yuv_info.y_loc+yuv_info.luma_size;
    yuv_info.chroma_size = yuv_info.width*yuv_info.height/4;
    yuv_info.v_loc = yuv_info.y_loc+yuv_info.luma_size+yuv_info.chroma_size;
    yuv_info.image_size = yuv_info.luma_size+yuv_info.chroma_size*2;
    yuv_info.resolution = 0b1000;

    // remap region for the frame
    frame_virt = (uint8_t*)ioremap_nocache(yuv_info.y_loc,yuv_info.image_size);
    
    printk(KERN_INFO "%s: Enabling h2f and f2sdram communication.\n", DEVICE_NAME);
	
    // f2f & lwh2f enable
    iowrite32(0x18, fpga_reg_virt);
    // f2sdram enable
    iowrite32(0x3fff, fpgaportrst_virt);

    printk(KERN_INFO "%s: Setting default configurations.\n", DEVICE_NAME);
    configure_hw();
    // Send signal to the hardware, that configures are ready
    printk(KERN_INFO "%s: Signalling FPGA for default configurations.\n", DEVICE_NAME);
    configure_signal();
	
    {
        // return value from interrupt request
        int ret;
            
        printk(KERN_INFO "%s: Enabling interrupt.\n", DEVICE_NAME);
            
        // request the interrupt for our use.
        ret = request_irq(IRQ_BASE + FRAME_IRQ, frame_interrupt, 0, "camera_frame_irq", NULL);
        
        if (ret < 0)
        {
            printk(KERN_ALERT "%s: Failure requesting irq %i\n", DEVICE_NAME, IRQ_BASE + FRAME_IRQ);
        }
    }
	
    printk(KERN_INFO "%s: Done initialization\n", DEVICE_NAME);

    return 0;
}

static void __exit camera_exit_module(void)
{
    // Disable interrupts in PIO
    iowrite32(0, yuv_status_virt+2);

     // Acknowledge interrupt if any
    iowrite32(1, yuv_status_virt+3);

    // Unmap all regions mapped when module was loaded.
    iounmap(fpga_reg_virt);
    iounmap(fpgaportrst_virt);
    iounmap(config_camera_virt);
    iounmap(yuv_ctrl_virt);
    iounmap(onchip_virt);

    iounmap(yuv_dma_virt);
       
    iounmap(frame_virt);

    iounmap(yuv_status_virt);

    // Free the interrupt
    free_irq(IRQ_BASE + FRAME_IRQ, NULL);

    // Free the device and class stuff.
    cdev_del(cdev);

    device_destroy(device_class,devno);
    class_destroy(device_class);
    
    // Unregister the device, so it may be loaded again if needed.
    unregister_chrdev_region(major,1);
	
    printk(KERN_INFO "%s: Done uninitialization\n", DEVICE_NAME);
}

static int device_open(struct inode *inode, struct file *file)
{
    // Already open -> unavailable.
    if (device_Open)
        return -EBUSY;
		
    // Reserve the module. Exit if cant.
    if ( try_module_get(THIS_MODULE)  == 0 )
        return -EBUSY;

    // Mark us open, and thus unavailable.
    device_Open++;
	
    printk(KERN_INFO "%s: Opened camera driver\n", DEVICE_NAME);

    printk(KERN_INFO "%s: Setting default configurations.\n", DEVICE_NAME);
    configure_hw();
    // Send signal to the hardware, that configures are ready
    printk(KERN_INFO "%s: Signalling FPGA for default configurations.\n", DEVICE_NAME);
    configure_signal();

    return 0;
}

static int device_release(struct inode *inode, struct file *file)
{
    // Mark us not open, and thus available.
    iowrite32(0, yuv_ctrl_virt);
    device_Open--;
    module_put(THIS_MODULE);
    printk(KERN_INFO "%s: Closed camera driver\n", DEVICE_NAME);

    return 0;
}

static ssize_t device_read(struct file *filp, char *buffer, size_t length, loff_t* offset)
{
    // Not enough buffer? Return error, as we won't chop frames to smaller pieces.
    if (length < yuv_info.image_size)
    {
        return -EINVAL;
    }

    if (continuous == 0)
    {
        // We wait for the interrupt indicating that the frame is ready.
        if (down_interruptible(&sem) != 0)
        {
            printk(KERN_ALERT "%s: Polling for frame interrupted by user!\n", DEVICE_NAME);
            return -1;
        }
    }
    
    {
        // Used as an intermediate buffer for data.
        //static int kernel_buf[DEFAULT_SIZE];
    
        // To check if copy went ok.
        int copy_ok;
        
        // Copy frame to kernel space.
        //memcpy_fromio(kernel_buf, frame_virt, yuv_info.image_size);
        
        // Copy frame from kernel to user space.
        //copy_ok = copy_to_user(buffer, kernel_buf, yuv_info.image_size);
        
        // Copy directly from memory to user space.
        // WARNING: Is not recommended, but is ok on this platform.
        // Also notice that the frame_virt is within HPS DDR, not in peripheral.
        copy_ok = copy_to_user(buffer, frame_virt, yuv_info.image_size);
        
        // Warn if did not succeed.
        if (copy_ok != 0)
        {
            printk(KERN_ALERT "%s: Copy to user space did not succeed!\n", DEVICE_NAME);
        }
    }
    
    if(continuous == 0)
    {
        // What shall be written to the control register.
        uint32_t control_val = 0;
        
        // TODO: enable frame interrupts
    }
    
    return length;
}

// Identifiers of commands issued in IOCTL.
#define IOCTL_VAL_SET_CONTINUOUS 8
#define IOCTL_VAL_SET_GREEN 9
#define IOCTL_VAL_SET_BLUERED 11
#define IOCTL_VAL_CONFIGURE_CAMERA 12
#define IOCTL_VAL_SET_RESOLUTION 13

static long ioctl (struct file *file, unsigned int cmd,  unsigned long arg)
{
    // Branch depending on which command is issued, if unknown, return error.
    switch( cmd )
    {
        case  IOCTL_VAL_SET_RESOLUTION:
        {
            // Update YUV info
            yuv_info.width = arg?800:400;
            yuv_info.height = arg?480:240;
            yuv_info.y_loc =  0x38000000;
            yuv_info.luma_size = yuv_info.width*yuv_info.height;
            yuv_info.u_loc =  yuv_info.y_loc+yuv_info.luma_size;
            yuv_info.chroma_size = yuv_info.width*yuv_info.height/4;
            yuv_info.v_loc = yuv_info.y_loc+yuv_info.luma_size+yuv_info.chroma_size;
            yuv_info.image_size = yuv_info.luma_size+yuv_info.chroma_size*2;
            yuv_info.resolution = arg?0b1000:0b0000;

            // unmap frame_virt if not null
            if(frame_virt != NULL)
            {
                iounmap(frame_virt);
                frame_virt = NULL;
            }
            
            // remap frame_virt
            frame_virt = (uint8_t*)ioremap_nocache(yuv_info.y_loc,yuv_info.image_size);

            // stop DMA
            iowrite32(16,yuv_dma_virt);

            // wait DMA to stop
            while(ioread32(yuv_dma_virt+1) == 0);

            // Update DMA settings
            // Luma and Chroma addresses
            iowrite32(yuv_info.y_loc,yuv_dma_virt + 2);
            iowrite32(yuv_info.u_loc,yuv_dma_virt + 3);
            iowrite32(yuv_info.v_loc,yuv_dma_virt + 4);
            
            // Luma and Chroma bytes
            iowrite32(yuv_info.luma_size,yuv_dma_virt + 6);
            iowrite32(yuv_info.chroma_size,yuv_dma_virt + 7);

            // Make DMA to write indefinitely
            iowrite32(8,yuv_dma_virt);
            break;
        }
        case  IOCTL_VAL_SET_CONTINUOUS:
        {
            
            continuous = arg;

            if(continuous == 0)
            {
                //TODO: Enable PIO interrupts
            
                //TODO: Enable frame interrupts and set resolution
                
                // Initalize the semaphore needed with the interrupt
                sema_init(&sem, 0);
            }
            else if(continuous == 1)
            {
                // What shall be written to the control register.
                uint32_t control_val = 0;
            
                // Disable interrupts in PIO
                iowrite32(0, yuv_status_virt+2);
                
                // Acknowledge interrupt if any
                iowrite32(1, yuv_status_virt+3);

                control_val = 2 | 0b100 | yuv_info.resolution;
                
                iowrite32(control_val, yuv_ctrl_virt);
            }

            // Make DMA to write indefinitely
            if(ioread32(yuv_dma_virt) != 8)
            {
                iowrite32(8, yuv_dma_virt);
            }

            break;
        }
        case  IOCTL_VAL_SET_GREEN:
        {
            // Feed the new green gains to their corresponding memory locations
            iowrite16((uint16_t)arg, onchip_virt );
            iowrite16((uint16_t)(arg >> 16), onchip_virt + 3);
                    
            printk(KERN_INFO "%s: Green gains set.\n", DEVICE_NAME);
                
            break;
        }
        case  IOCTL_VAL_SET_BLUERED:
        {
            // Feed the new blue and red gains to their corresponding memory locations
            iowrite16((uint16_t)arg,  onchip_virt + 1);
            iowrite16((uint16_t)(arg >> 16), onchip_virt + 2);
                
            printk(KERN_INFO "%s: Blue and red gains set.\n", DEVICE_NAME);
                
            break;
        }
        case IOCTL_VAL_CONFIGURE_CAMERA:
            // Configurations have changed: Signal about it.
            configure_signal();
            break;
        default:
            return -EINVAL;
    }

    return 0;
}

module_init(camera_init_module);
module_exit(camera_exit_module);
