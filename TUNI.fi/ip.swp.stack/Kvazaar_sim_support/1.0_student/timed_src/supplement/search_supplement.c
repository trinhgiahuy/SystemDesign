#include "global.h"
#include "global_supplement.h"
#include "search_supplement.h"
#include "sc_kvazaar.h"

// used for sending the orig block to the accelerator, used in search.c
void pre_search(const videoframe_t * const frame, lcu_t* work_tree, const int x, const int y)
{
#ifdef IP_DEBUG
  int thread_lcu = 0;
  static int lcu_num = -1;
  lcu_num++;
  if(lcu_num == 0x8000000)
  {
	lcu_num = 0;
  }
  thread_lcu = lcu_num;

  printf("LCU %d\n",thread_lcu);
#endif
  
  int offs;
  kvz_pixel orig[ORIG_BLOCK_SIZE];
	
  // use ioctl function to set the write location for IOCTL_LOCATION_ORIG_BLOCK
  if(ip_acc_driver->ioctl(ip_acc_fd,IOCTL_SET_LOCATION,IOCTL_LOCATION_ORIG_BLOCK) < 0)
  {
      printf("IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
      ip_acc_driver->sc_exit();
	  //exit(0);
  }
  
  // copy the write lcu from the frames luma data to temporary array
  for (offs = 0; offs < 64; ++offs)
  {
	  memcpy(&orig[offs*LCU_WIDTH],&frame->source->y[x + y * frame->source->stride + frame->source->stride*offs],LCU_WIDTH);
  }
  
  // use write function to send the orig_block (lcu) to the accelerator
  ip_acc_driver->write(ip_acc_fd,orig,ORIG_BLOCK_SIZE);
}

// used for handling thread locks, not used in simulation
void post_search(lcu_t* work_tree)
{
	static int lcus = 1;
	if(lcu_limit == lcus)
	{
		fprintf(stderr,"LCU limit %d reached, program terminated in file %s, function %s, line %d\n",lcu_limit,__FILE__,__FUNCTION__,__LINE__);
		exit(0);
	}
	else
	{
		lcus++;
	}
	return;
}