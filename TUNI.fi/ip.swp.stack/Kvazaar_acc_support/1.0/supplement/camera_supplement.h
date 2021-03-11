#ifndef CAMERA_SUPPLEMENT_H_
#define CAMERA_SUPPLEMENT_H_
#include <stdio.h>

#define IOCTL_VAL_SET_CONTINUOUS 8
#define IOCTL_VAL_SET_GREEN 9
#define IOCTL_VAL_SET_BLUERED 11
#define IOCTL_VAL_CONFIGURE_CAMERA 12
#define IOCTL_VAL_SET_RESOLUTION 13

// Used for opening the camera, not used for simulation
extern FILE* open_camera(const char* filename);
extern void close_camera();
extern int camera_read_frame(unsigned char *data, int y_size, int uv_size);

#endif // CAMERA_SUPPLEMENT_H_