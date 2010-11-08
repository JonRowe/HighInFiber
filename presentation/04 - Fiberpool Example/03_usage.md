!SLIDE
# Fiber Pool #
### Lets use the pool ###
     
!SLIDE small
# Fiber Pool #
    @@@ ruby
    EventMachine.run do
      FiberPool.start do |fiber_pool|
        30.times do
          fiber_pool.add do |callback|
            a = proc { sleep 5 }
            b = proc { callback.call }
            EM.defer(a,b)
          end
        end
      end
    end

!SLIDE bullets incremental
# Caveat #
 * The `EventMachine.run` block is why we need the `EM.stop` command
 * We eventually want to drop out of EventMachine
 * I'm using EventMachine for notifying my fiber pool when my blocking command finishes
 * We could use something else

!SLIDE small
# Fiber Pool #
    @@@ ruby
    EventMachine.run do
      FiberPool.start do |fiber_pool|
        30.times do
          fiber_pool.add do |callback|
            a = proc { sleep 5 }
            b = proc { callback.call }
            EM.defer(a,b)
          end
        end
      end
    end
   
!SLIDE bullets incremental
# Fiber Pool #

 * We use our convenience method to start our fiber pool
 * We take our created pool and we're going to add 30 tasks
 * Each task is going to be simulating blocking operation by sleeping for 5 seconds
 * When the blocking operation is complete we are going to call the `completion_callback`