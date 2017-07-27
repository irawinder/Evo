# Evo
Environment for testing natural selection processes on some digital "bugs"

## Key Parameters:

    W, width of canvas [pixels]
    H, height of canvas [pixels]

    D_f, diameter of food [pixels]
    P_f, period of food generation [ticks]

    D_b, diameter of bug [pixels]
    V_b, maximum velocity of a "bug" [pixels/frame]
    S_b, number of bugs "spawned" when food eaten [bugs]
    H_b, number of ticks a bug can go without food before death [ticks]

  ## Key Behaviors

    - Bug acceleration is "random" in 2D space but velocity never exceeds V_b
    - Upon encountering food, a bug will eat it.  The polygon representing the bug and the food must intersect.
    - If a bug goes length of time H_b without eating food it will disappear from simulation
    - Upon eating food, the bug will become completely "full,"  and will instantly generate offspring of amount S_b
    - Every amount of time P_f, a unit of food is placed randomly on the canvas
