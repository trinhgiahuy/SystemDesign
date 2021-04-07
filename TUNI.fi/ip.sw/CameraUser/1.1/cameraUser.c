#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/mman.h>
#include <time.h>

//Width of a frame in pixels.
#define MAX_WIDTH 800
//Height of a frame in pixels.
#define MAX_HEIGHT 480

#define MAX_LUMA_SIZE MAX_WIDTH*MAX_HEIGHT
#define MAX_CHROMA_SIZE MAX_LUMA_SIZE/4
#define MAX_IMAGE_SIZE MAX_LUMA_SIZE+MAX_CHROMA_SIZE+MAX_CHROMA_SIZE

//Width of a frame in pixels.
#define MIN_WIDTH 400
//Height of a frame in pixels.
#define MIN_HEIGHT 240

#define MIN_LUMA_SIZE MIN_WIDTH*MIN_HEIGHT
#define MIN_CHROMA_SIZE MIN_LUMA_SIZE/4
#define MIN_IMAGE_SIZE MIN_LUMA_SIZE+MIN_CHROMA_SIZE+MIN_CHROMA_SIZE

//Default frames per second
#define DEFAULT_FPS 10
//Conversions
#define NANOS_IN_SECOND 1000000000
#define NANOS_IN_MILLI 1000000
#define NANOS_IN_MICRO 1000
#define MICROS_IN_MILLI 1000

static uint8_t data[MAX_IMAGE_SIZE];

//Identifiers of commands issued in IOCTL.
#define IOCTL_VAL_ORDER_NEXT_FRAME 6
#define IOCTL_VAL_WAIT_NEXT_FRAME 7
#define IOCTL_VAL_SET_CONTINUOUS 8
#define IOCTL_VAL_SET_GREEN 9
#define IOCTL_VAL_SET_BLUERED 11
#define IOCTL_VAL_CONFIGURE_CAMERA 12
#define IOCTL_VAL_SET_RESOLUTION 13

int main ( int argc, char **argv )
{
    //uint8_t* data = NULL; //pointer to the memory region  which will contain the frames.
    int fd = 0; //filedescriptor pointing to the device driver
    int continuous = 1; //1, if each frame has to be ordered
    int prints; //1, if some status messages are printed. Prints are directed to the error stream
    int resolution = 0; //Camera resolution: 1=800x480,0=400x240
	int frames = -1; //Number of frames to write
    //double frame_delta; //How many nanoseconds are between each frame with given fps.
    uint16_t green1 = 0x000F; //Green gain of the camera
    uint16_t blue = 0x020F; //Blue gain of the camera
    uint16_t red = 0x020E; //Red gain of the camera
    uint16_t green2 = 0x0008; //The second green gain of the camera
    uint32_t green_code; //Variable used to communicate green gains to driver
    uint32_t bluered_code; //Variable used to communicate red and blue gains to driver
    uint32_t image_size;
    
    //READ COMMAND LINE PARAMETERS
    if (argc > 1)
	{
		//That one is supposed to be continuous mode.
		continuous = atoi( argv[1] );
	
		if (argc > 2)
		{
			resolution = atoi( argv[2] );
				
			if (argc > 3)
			{
				//Number of frames
				frames = atoi( argv[3] );

				if (argc > 4)
				{
					//Prints or no
					prints = atoi( argv[4] );
				}
			}
		}
    }
    
    //Open the device driver for us to use.
    if ((fd = open("/dev/cyclone_v_camera", O_RDWR, 0)) < 0)
    {
        perror("error opening");
        return EXIT_FAILURE;
    }

    
    //Setting the continuous parameter.
    ioctl(fd, IOCTL_VAL_SET_RESOLUTION, resolution);
    
    if(ioctl(fd, IOCTL_VAL_SET_CONTINUOUS, continuous) < 0)
    {
        fprintf(stderr, "irq not supported in the ready made camera driver, using continuous mode! (IRQ => BONUS TASK!)\n");
    }
    
    //Set which resolution is used
    if(resolution)
    {
        image_size = MAX_IMAGE_SIZE;
    }
    else
    {
        image_size = MIN_IMAGE_SIZE;
    }
	
    //Setting colours
    green_code = (green2 << 16 | green1);
    bluered_code = (red << 16 | blue);
	
    ioctl(fd, IOCTL_VAL_SET_GREEN, green_code);
    ioctl(fd, IOCTL_VAL_SET_BLUERED, bluered_code);
    ioctl(fd, IOCTL_VAL_CONFIGURE_CAMERA);
  
    //Now read memory frame-by-frame until the termination
    while (frames != 0)
    {
		struct timespec t_start, t_end;
		int chroma_iterator = 0, data_iterator = 0; //Iterators used in loops copying data.
		int x_pos = 0; //x-coordinate used to iterate 2-dimensional tables
		int y_pos = 0; //y-coordinate used to iterate 2-dimensional tables
				
		//Measure how long its takes to write a frame...
		clock_gettime( CLOCK_MONOTONIC, &t_start );
	
		//Read data from driver
		if(read(fd,data,image_size) < 0)
		{
			fprintf(stderr, "read error\n");
		}
		
		//Write YUV to stdout
		fwrite(data,1,image_size,stdout);
			
		//...and the measurement is concluded
		clock_gettime( CLOCK_MONOTONIC, &t_end );
			
		//See how long it took in nanoseconds
		double diff =  (double)( t_end.tv_nsec - t_start.tv_nsec );
		diff +=  (double)( t_end.tv_sec - t_start.tv_sec ) * NANOS_IN_SECOND;
			
		if ( prints == 1 )
		{
			fprintf(stderr, "frame time %f ms\n", diff/NANOS_IN_MILLI);
		}
		if (frames > 0) 
		{
			frames--;
		}
    }
	
    if ( prints == 1 )
    {
        fprintf(stderr, "Camera User finished\n");
    }
	
    //Finally, close driver and unmap the memory, although this is never
    //reached if the loop is endless.
    close(fd);	
    	
    return 0;
}

