!SLIDE bullets incremental
# EventMachine? #
 * Where did that come from?

!SLIDE bullets incremental
# EventMachine? #
 * Because fibers themselves do not preempt their own execution
 * Because theres no scheduler, we must schedule them

!SLIDE bullets incremental
# EventMachine #
 * Implementation of the reactor pattern in C/Ruby
 * Gives us the power of an evented architecture, in Ruby
 * Lets us leave blocking IO to the underlying architecture and carry on doing work

!SLIDE
# EventMachine #
### We could use any of the evented frameworks for scheduling our fiber pool, I choose EventMachine