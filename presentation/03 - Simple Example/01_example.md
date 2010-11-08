!SLIDE
# Example #

!SLIDE bullets
# Example #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end
    
!SLIDE bullets
# What does that do #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end

* Create the fiber and assign it a block to execute

!SLIDE bullets
# What does that do #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end

* In that block loop forever and double x

!SLIDE bullets
# What does that do #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end

* Except each iteration we *\*yield\** x

!SLIDE bullets incremental
# What does that do? #

 * Creating the fiber does not execute the fiber
 * To kick start the fiber we must `resume` it
 * The *first* call to resume starts the execution of the fiber's block

!SLIDE bullets incremental

# What does that do? #

 * Once executed the fiber follows normal behaviour
 * Until it reaches `Fiber.yield`
 * Upon which it "returns" the passed parameter
 * Which drops out the resume

!SLIDE bullets
# Example #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end

    f.resume => 2

!SLIDE bullets
# Example #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end

    f.resume => 2
 * The next call resuming from the yield will hit the bottom of the loop and carry on giving us

!SLIDE bullets
# Example #
    @@@ ruby

    f = Fiber.new do
     x = 1
     loop do
       Fiber.yield x+=x
     end
    end

    f.resume => 2
    f.resume => 4

!SLIDE bullets
# Example #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end

    f.resume => 2
    f.resume => 4
    f.resume => 8
  
!SLIDE bullets
# Example #
    @@@ ruby

    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end

    f.resume => 2
    f.resume => 4
    f.resume => 8
    f.resume => 16

!SLIDE
# Example #
    @@@ ruby
    
    f = Fiber.new do
      x = 1
      loop do
        Fiber.yield x+=x
      end
    end
    
    f.resume => 2
    f.resume => 4
    f.resume => 8
    f.resume => 16