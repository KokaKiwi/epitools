#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <time.h>

struct timer
{
  clock_t clock;
  time_t time;
};

struct timer timer_start = {0, 0};
struct timer timer_end = {0, 0};
struct timer timer_diff = {0, 0};

int my_putchar(char c)
{
  write(1, &c, 1);
}

void start_timer()
{
  timer_start.clock = clock();
  timer_start.time = time(NULL);
}

void stop_timer()
{
  timer_end.clock = clock();
  timer_end.time = time(NULL);

  timer_diff.clock = timer_end.clock - timer_start.clock;
  timer_diff.time = timer_end.time - timer_start.time;
}

void show_timer()
{
  printf("/********** TIMER **********/\n");
  printf("/* Ops: %14u ops */\n", timer_diff.clock);
  printf("/* Time: %15u s */\n", timer_diff.time);
  printf("/********** TIMER **********/\n");
}
