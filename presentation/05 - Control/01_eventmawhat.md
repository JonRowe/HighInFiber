!SLIDE bullets incremental
# EventMachine? #

 * Where did that come from?

!SLIDE bullets incremental
# EventMachine? #

 * Fibers are cooperatively scheduled
 * That doesn't make them instantly intelligent
 * We need something to wake them up appropriately
 
!SLIDE bullets incremental
# EventMachine? #

 * I'm using EventMachine out of convenience
 * It could be any control structure that can call `f.resume`

!SLIDE bullets incremental
# Evented IO #

 * Ideally I'd like to wake my fibers up directly upon receiving a message
 * Then I don't have to have extra overhead