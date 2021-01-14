#include "global.h"
#include "global_supplement.h"
#include "search_supplement.h"

// used for sending the orig block to the accelerator, used in search.c
void pre_search(const videoframe_t * const frame, lcu_t* work_tree, const int x, const int y)
{
    int depth;
    sem_wait(&acc_sem);
    if(pthread_mutex_trylock(&thread[0]) == 0)
    {
        work_tree[0].thread = 0;   
    }
    else if(pthread_mutex_trylock(&thread[1]) == 0)
    {
        work_tree[0].thread = 1;
    }
    else
    {
        fprintf(stderr,"MUTEX ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
        exit(0);
    }
    //sem_getvalue(&acc_sem,&work_tree[0].thread);
    for (depth = 1; depth <= MAX_PU_DEPTH; ++depth) {
        work_tree[depth].thread = work_tree[0].thread;
    }
#ifdef IP_DEBUG
    printf("LCU %d, thread %d\n",thread_lcu,work_tree[0].thread);
#endif
    
    //thread_id[thread] = (unsigned int)pthread_self();
    if(ioctl(ip_acc_fd,1,work_tree[0].thread) < 0)
    {
        fprintf(stderr,"IOCTL ERROR %s, %s, %d",__FILE__,__func__,__LINE__);
        exit(0);
    }
    
    write(ip_acc_fd,&frame->source->y[x + y * frame->source->stride],frame->source->stride);
}

// used for handling thread locks, not used in simulation
void post_search(lcu_t* work_tree)
{
    pthread_mutex_unlock(&thread[work_tree[0].thread]);
    sem_post(&acc_sem);
}