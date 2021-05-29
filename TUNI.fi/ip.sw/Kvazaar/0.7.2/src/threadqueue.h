#ifndef THREADQUEUE_H_
#define THREADQUEUE_H_
/*****************************************************************************
 * This file is part of Kvazaar HEVC encoder.
 *
 * Copyright (C) 2013-2015 Tampere University of Technology and others (see
 * COPYING file).
 *
 * Kvazaar is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation; either version 2.1 of the License, or (at your
 * option) any later version.
 *
 * Kvazaar is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with Kvazaar.  If not, see <http://www.gnu.org/licenses/>.
 ****************************************************************************/

#include "global.h"

#include <pthread.h>
#include "threads.h"

typedef enum {
  THREADQUEUE_JOB_STATE_QUEUED = 0,
  THREADQUEUE_JOB_STATE_RUNNING = 1,
  THREADQUEUE_JOB_STATE_DONE = 2
} threadqueue_job_state;

typedef struct threadqueue_job_t {
  pthread_mutex_t lock;
  
  threadqueue_job_state state;
  
  unsigned int ndepends; //Number of active dependencies that this job wait for
  
  struct threadqueue_job_t **rdepends; //array of pointer to jobs that depend on this one. They have to exist when the thread finishes, because they cannot be run before.
  unsigned int rdepends_count; //number of rdepends
  unsigned int rdepends_size; //allocated size of rdepends
  
  //Job function and state to use
  void (*fptr)(void *arg);
  void *arg;
  
#ifdef KVZ_DEBUG
  const char* debug_description;
  
  int debug_worker_id;
  
  CLOCK_T debug_clock_enqueue;
  CLOCK_T debug_clock_start;
  CLOCK_T debug_clock_stop;
  CLOCK_T debug_clock_dequeue;
#endif
} threadqueue_job_t;


  

typedef struct {
  pthread_mutex_t lock;
  pthread_cond_t cond;
  pthread_cond_t cb_cond;
  
  pthread_t *threads;
  int threads_count;
  int threads_running;

  int stop; //=>1: threads should stop asap
  
  int fifo;
  
  threadqueue_job_t **queue;
  unsigned int queue_start;
  unsigned int queue_count;
  unsigned int queue_size;
  unsigned int queue_waiting_execution; //Number of jobs without any dependency which could be run
  unsigned int queue_waiting_dependency; //Number of jobs waiting for a dependency to complete
  unsigned int queue_running; //Number of jobs running
  
#ifdef KVZ_DEBUG
  //Format: pointer <tab> worker id <tab> time enqueued <tab> time started <tab> time stopped <tab> time dequeued <tab> job description
  //For threads, pointer = "" and job description == "thread", time enqueued and time dequeued are equal to "-"
  //For flush, pointer = "" and job description == "FLUSH", time enqueued, time dequeued and time started are equal to "-" 
  //Each time field, except the first one in the line be expressed in a relative way, by prepending the number of seconds by +.
  //Dependencies: pointer -> pointer

  FILE *debug_log;
  
  CLOCK_T *debug_clock_thread_start;
  CLOCK_T *debug_clock_thread_end;
#endif
} threadqueue_queue_t;

//Init a threadqueue (if fifo, then behave as a FIFO with dependencies, otherwise as a LIFO with dependencies)
int kvz_threadqueue_init(threadqueue_queue_t * threadqueue, int thread_count, int fifo);

//Add a job to the queue, and returs a threadqueue_job handle. If wait == 1, one has to run kvz_threadqueue_job_unwait_job in order to have it run
threadqueue_job_t * kvz_threadqueue_submit(threadqueue_queue_t * threadqueue, void (*fptr)(void *arg), void *arg, int wait, const char* debug_description);

int kvz_threadqueue_job_unwait_job(threadqueue_queue_t * threadqueue, threadqueue_job_t *job);

//Add a dependency between two jobs.
int kvz_threadqueue_job_dep_add(threadqueue_job_t *job, threadqueue_job_t *depends_on);

//Blocking call until the queue is empty. Previously set threadqueue_job handles should not be used anymore
int kvz_threadqueue_flush(threadqueue_queue_t * threadqueue);

//Blocking call until job is executed. Job handles submitted before job should not be used any more as they are removed from the queue.
int kvz_threadqueue_waitfor(threadqueue_queue_t * threadqueue, threadqueue_job_t * job);

//Free ressources in a threadqueue
int kvz_threadqueue_finalize(threadqueue_queue_t * threadqueue);

#ifdef KVZ_DEBUG
int threadqueue_log(threadqueue_queue_t * threadqueue, const CLOCK_T *start, const CLOCK_T *stop, const char* debug_description);

// Bitmasks for PERFORMANCE_MEASURE_START and PERFORMANCE_MEASURE_END.
#define KVZ_PERF_FRAME    (1 << 0)
#define KVZ_PERF_JOB      (1 << 1)
#define KVZ_PERF_LCU      (1 << 2)
#define KVZ_PERF_SAOREC   (1 << 3)
#define KVZ_PERF_BSLEAF   (1 << 4)
#define KVZ_PERF_SEARCHCU (1 << 5)
#define KVZ_PERF_SEARCHPX (1 << 6)

#define IMPL_PERFORMANCE_MEASURE_START(mask) CLOCK_T start, stop; if ((KVZ_DEBUG) & mask) { GET_TIME(&start); }
#define IMPL_PERFORMANCE_MEASURE_END(mask, threadqueue, str, ...) { if ((KVZ_DEBUG) & mask) { GET_TIME(&stop); {char job_description[256]; sprintf(job_description, (str), __VA_ARGS__); threadqueue_log((threadqueue), &start, &stop, job_description);}} } \

#ifdef _MSC_VER
// Disable VS conditional expression warning from debug code.
# define WITHOUT_CONSTANT_EXP_WARNING(macro) \
  __pragma(warning(push)) \
  __pragma(warning(disable:4127)) \
  macro \
  __pragma(warning(pop))
# define PERFORMANCE_MEASURE_START(mask) \
    WITHOUT_CONSTANT_EXP_WARNING(IMPL_PERFORMANCE_MEASURE_START(mask))
# define PERFORMANCE_MEASURE_END(mask, threadqueue, str, ...) \
    WITHOUT_CONSTANT_EXP_WARNING(IMPL_PERFORMANCE_MEASURE_END(mask, threadqueue, str, ##__VA_ARGS__))
#else
# define PERFORMANCE_MEASURE_START(mask) \
    IMPL_PERFORMANCE_MEASURE_START(mask)
# define PERFORMANCE_MEASURE_END(mask, threadqueue, str, ...) \
    IMPL_PERFORMANCE_MEASURE_END(mask, threadqueue, str, ##__VA_ARGS__)
#endif

#else
#define PERFORMANCE_MEASURE_START(mask) 
#define PERFORMANCE_MEASURE_END(mask, threadqueue, str, ...) 
#endif

/* Constraints: 
 * 
 * - Always first lock threadqueue, than a job inside it
 * - When job A depends on job B, always lock first job B and then job A
 * - Jobs should be submitted in an order which is compatible with serial execution.
 * 
 * */

#endif //THREADQUEUE_H_
