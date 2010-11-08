require 'rubygems'
require 'bundler/setup'

require 'fiber'
require 'eventmachine'

class FiberPool
  attr_accessor :fibers, :pool_size, :control_fiber

  def initialize
    self.pool_size      = 10
    self.fibers         = []
    self.control_fiber  = Fiber.current
  end
  
  def add(&block)
    fiber = Fiber.new do
      f = Fiber.current
      completion_callback = proc { control_fiber.transfer(f) }
      yield completion_callback
    end
    add_to_pool(fiber)
  end

  def add_to_pool(fiber)
    wait_for_free_pool_space if over_capacity?
    fibers << fiber
    fiber.resume
  end
  
  def wait_for_free_pool_space
    dead_fiber = wait_for_next_complete_fiber
    remove_fiber_from_pool(dead_fiber)
  end

  def wait_for_next_complete_fiber
    Fiber.yield
  end

  def over_capacity?
    fibers_in_use >= pool_size
  end

  def fibers_in_use
    fibers.size
  end

  def remove_fiber_from_pool(fiber)
    fibers.delete(fiber)
  end
        
  def drain
    wait_for_free_pool_space while fibers_left_to_process?
  end
  
  def fibers_left_to_process?
    fibers.size > 0
  end

  def self.start(&block)
    Fiber.new do
      pool = FiberPool.new
      yield pool
      pool.drain
      EM.stop
    end.resume
  end
end

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
