!SLIDE
# Fiber Pool #
### Ok so lets try a more complex example ###

!SLIDE
# Fiber Pool #
### Say we have a blocking operation we want to run concurrently ###
### Lets invent a pool of worker fibers to do this cooperatively ###

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
      
!SLIDE small
# Fiber Pool #
    @@@ ruby
      def add(&block)
        fiber = Fiber.new do
          f = Fiber.current
          completion_callback = proc { control_fiber.transfer(f) }
          yield completion_callback
        end
        add_to_pool(fiber)
      end

!SLIDE small
# Fiber Pool #
    @@@ ruby
      def add_to_pool(fiber)
        wait_for_free_pool_space if over_capacity?
        fibers << fiber
        fiber.resume
      end
      
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
            
      def drain
        wait_for_free_pool_space while fibers_left_to_process?
      end
      
      def fibers_left_to_process?
        fibers.size > 0
      end

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
    
!SLIDE
# The result?

!SLIDE
# The result?
    @@@ruby
    30.times { sleep 5 }
   
    $ time ruby no_fiber.rb

    real	2m30.030s
    user	0m0.217s
    sys	0m0.242s
    
!SLIDE
# The result?
    $time ruby fiber_pool.rb 

    real	0m15.980s
    user	0m0.575s
    sys	0m0.218s
    
!SLIDE
# The result?
### What should have taken 150 seconds

!SLIDE
# The result?
### What should have taken 150 seconds
### Has taken 15 seconds