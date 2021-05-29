#include "global_supplement.h"
#include "camera_supplement.h"
#include <string.h>

static int camera_fd = -1;

// Used for opening the camera
FILE* open_camera(const char* filename)
{   
    if ((camera_fd = open("/dev/cyclone_v_camera", O_RDWR, 0)) < 0)
    {
        perror("error opening /dev/cyclone_v_camera");
        return NULL;
    }
    //Setting the continuous parameter.
    if (!strcmp(filename, "camera_high"))
    {
        fprintf(stderr,"hi");
        ioctl(camera_fd, IOCTL_VAL_SET_RESOLUTION, 1);
        ioctl(camera_fd, IOCTL_VAL_SET_CONTINUOUS, 1);
    }
    else if (!strcmp(filename, "camera_high_irq"))
    {
        fprintf(stderr,"hi_irq");
        ioctl(camera_fd, IOCTL_VAL_SET_RESOLUTION, 1);
        ioctl(camera_fd, IOCTL_VAL_SET_CONTINUOUS, 0);
    }
    else if (!strcmp(filename, "camera_low"))
    {
        fprintf(stderr,"low");
        ioctl(camera_fd, IOCTL_VAL_SET_RESOLUTION, 0);
        ioctl(camera_fd, IOCTL_VAL_SET_CONTINUOUS, 1);
    }
    else if (!strcmp(filename, "camera_low_irq"))
    {
        fprintf(stderr,"low_irq");
        ioctl(camera_fd, IOCTL_VAL_SET_RESOLUTION, 0);
        ioctl(camera_fd, IOCTL_VAL_SET_CONTINUOUS, 0);
    }
    {
        uint16_t green1 = 0x000F; //Green gain of the camera
        uint16_t blue = 0x020F; //Blue gain of the camera
        uint16_t red = 0x020E; //Red gain of the camera
        uint16_t green2 = 0x0008; //The second green gain of the camera
        uint32_t green_code; //Variable used to communicate green gains to driver
        uint32_t bluered_code; //Variable used to communicate red and blue gains to driver
        //Setting colours
        green_code = (green2 << 16 | green1);
        bluered_code = (red << 16 | blue);
        
        ioctl(camera_fd, IOCTL_VAL_SET_GREEN, green_code);
        ioctl(camera_fd, IOCTL_VAL_SET_BLUERED, bluered_code);
        ioctl(camera_fd, IOCTL_VAL_CONFIGURE_CAMERA);
    }
    return stdin;
}

void close_camera()
{
    if(camera_fd != -1)
    {
        close(camera_fd);
    }
}

int camera_read_frame(unsigned char *data, int y_size, int uv_size)
{
    if(camera_fd < 0)
    {
        return -1;
    }
    if (read(camera_fd, data, y_size+2*uv_size) < 0) return -1;
    return 1;
}