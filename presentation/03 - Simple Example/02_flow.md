!SLIDE small
# Execution flow #

    @@@ ruby
    
    f = Fiber.new do |initial_resume_value|
      puts "Initial resume value => #{initial_resume_value}"
      
      resumed_with = Fiber.yield "initial yield value"
      puts "Then you resumed me with #{resumed_with}"
      
      resumed_with = Fiber.yield "second yield value"
      puts "Finally you resumed me with #{resumed_with}"
    end
    
!SLIDE small
# Execution flow #
    
    @@@ ruby
    
    f = Fiber.new do |initial_resume_value|
      puts "Initial resume value => #{initial_resume_value}"
      
      resumed_with = Fiber.yield "initial yield value"
      puts "Then you resumed me with #{resumed_with}"
      
      resumed_with = Fiber.yield "second yield value"
      puts "Finally you resumed me with #{resumed_with}"
    end
    
    $ puts f.resume "Cows"
    Initial resume value was => Cows
    initial yield value
     => nil 
     
!SLIDE small
# Execution flow #

    @@@ ruby

    f = Fiber.new do |initial_resume_value|
      puts "Initial resume value => #{initial_resume_value}"

      resumed_with = Fiber.yield "initial yield value"
      puts "Then you resumed me with #{resumed_with}"

      resumed_with = Fiber.yield "second yield value"
      puts "Finally you resumed me with #{resumed_with}"
    end

    $ puts f.resume "Cats"
    Then you resumed me with Cats
    second yield value
     => nil
     
!SLIDE small
# Execution flow #

    @@@ ruby

    f = Fiber.new do |initial_resume_value|
      puts "Initial resume value => #{initial_resume_value}"

      resumed_with = Fiber.yield "initial yield value"
      puts "Then you resumed me with #{resumed_with}"

      resumed_with = Fiber.yield "second yield value"
      puts "Finally you resumed me with #{resumed_with}"
    end

    $ puts f.resume "Dogs"
    Finally you resumed me with Dogs
     => nil

!SLIDE small
# Execution flow #

    @@@ ruby

    f = Fiber.new do |initial_resume_value|
      puts "Initial resume value => #{initial_resume_value}"

      resumed_with = Fiber.yield "initial yield value"
      puts "Then you resumed me with #{resumed_with}"

      resumed_with = Fiber.yield "second yield value"
      puts "Finally you resumed me with #{resumed_with}"
    end

    $ puts f.resume "Zombies"
    FiberError: dead fiber called

!SLIDE 
# All Good? #
    