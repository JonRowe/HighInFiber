!SLIDE small
# Fiber Pool #
    @@@ ruby
    class FiberPool
      attr_accessor :fibers, :pool_size, :control_fiber
  
      def initialize
        self.pool_size      = 10
        self.fibers         = []
        self.control_fiber  = Fiber.current
      end

!SLIDE small bullets incremental
# Fiber Pool #
* `pool_size` is going to be our concurrency limit
* `fibers` is going to contain our stack of fibers
* `control_fiber` is going to be our scheduler

!SLIDE small bullets incremental
# Fiber Pool #
* `Fiber.current` gets the fiber we are currently in the execution scope of
* If not specifically declared this is the root fiber of ruby itself

!SLIDE small
# Fiber Pool #
### We need some way to add work to our pool ###
      
!SLIDE small
# Fiber Pool #
    @@@ ruby
      def add(&block)
        fiber = Fiber.new do
          f = Fiber.current
          completion_callback = proc do
            control_fiber.transfer(f)
          end
          yield completion_callback
        end
        add_to_pool(fiber)
      end

!SLIDE small bullets incremental
# Fiber Pool #
 * We create a new fiber to wrap our work item
 * The fiber defines a `completion_callback` to transfer execution control back to the control fiber
 * Which passes itself back to the `control_fiber`
 * Our fiber then calls the block with `completion_callback` to perform our work

!SLIDE small bullets incremental
# Fiber Pool #
 * Once the fiber is setup
 * We add it to the pool
 * The fiber has not yet been run

!SLIDE small
# Fiber Pool #

    @@@ ruby
    def add_to_pool(fiber)
      wait_for_free_pool_space if over_capacity?
      fibers << fiber
      fiber.resume
    end
      
!SLIDE small bullets incremental
# Fiber Pool #
 * `add_to_pool` first checks to see if the pool is `over_capacity?`
 * If it is we `wait_for_free_pool_space`
 * Otherwise we add our fiber into our pool
 * And then we execute it
 
!SLIDE small
# Fiber Pool #
    @@@ ruby
      def wait_for_free_pool_space
        dead_fiber = wait_for_next_complete_fiber
        remove_fiber_from_pool(dead_fiber)
      end

      def wait_for_next_complete_fiber
        Fiber.yield
      end

!SLIDE small bullets incremental
# Fiber Pool #

 * `wait_for_free_pool_space` does two things
 * calls `wait_for_next_complete_fiber`
 * removes the completed fiber from the pool
 * How does this work? If we look at our new fiber
 
!SLIDE small
# Fiber Pool #

    @@@ ruby
    def add(&block)
      fiber = Fiber.new do
        
        f = Fiber.current
        
        completion_callback = proc do
           control_fiber.transfer(f)
        end
        
        yield completion_callback
      end
      add_to_pool(fiber)
    end
     
!SLIDE small bullets incremental
# Fiber Pool #

  * Remember that our `completion_callback` returns our fiber
  * The idea is that when our work has finished it calls our `completion_callback`
  * Which returns control to the `control_fiber`
  * Which then pops out the completed fiber to


!SLIDE small
# Fiber Pool #

    @@@ ruby
    def wait_for_next_complete_fiber
      Fiber.yield
    end

!SLIDE small bullets incremental
# Fiber Pool #

 * Now we can add fibers to our pool
 * Now we need to tidy up some loose ends

!SLIDE small
# Fiber Pool #
    @@@ ruby
      def over_capacity?
        fibers_in_use >= pool_size
      end

      def fibers_in_use
        fibers.size
      end
      
!SLIDE small
# Fiber Pool #
    @@@ ruby

      def remove_fiber_from_pool(fiber)
        fibers.delete(fiber)
      end
      
      def fibers_left_to_process?
        fibers.size > 0
      end

!SLIDE small bullets incremental
# Fiber Pool #

 * `fibers_left_to_process?` we haven't used that anywhere?
 * In order to actually use our pool we need one more method

!SLIDE small
# Fiber Pool #
    @@@ ruby
    def drain
      wait_for_free_pool_space while fibers_left_to_process?
    end

!SLIDE small bullets incremental
# Fiber Pool #

 * Once we have finished adding work to our pool we need someway to handle the remaining finishing fibers
 * We need to tidy up after ourselves
 * We need to drain the pool
 
!SLIDE small
# Fiber Pool #
    @@@ ruby
    def drain
      wait_for_free_pool_space while fibers_left_to_process?
    end

!SLIDE small bullets incremental
# Fiber Pool #

 * All we are doing here is checking if there are fibers still ticking
 * And waiting until they are finished

!SLIDE small bullets incremental
# Fiber Pool #

  * Now we can use our fiber pool
  * But it will need some setup
  * So lets make a convenience wrapper

!SLIDE small
# Fiber Pool #
    @@@ ruby
    
      def self.start(&block)
        Fiber.new do
          pool = FiberPool.new
          yield pool
          pool.drain
          EM.stop
        end.resume
      end
    end
    
!SLIDE small bullets incremental
# Fiber Pool #

 * We create the fiber which is to be our `control_fiber`
 * We create a new pool
 * We yield that pool to whatever code we are setting up
 
 
!SLIDE small bullets incremental
# Fiber Pool #
 
 * We drain the pool
 * We cheat and call EM.stop, I'll cover that in a bit
 * We immediately execute our fiber