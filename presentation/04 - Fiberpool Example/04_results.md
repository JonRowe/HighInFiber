!SLIDE bullets incremental
# The result?
### For comparison lets look at it conventionally first ###
 
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