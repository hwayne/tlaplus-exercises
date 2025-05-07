---- MODULE wf_counter_pass ----
EXTENDS Integers

VARIABLES counter
vars == <<counter>>

Max == 5

Init == 
    counter = 0

Inc ==
    /\ counter < Max
    /\ counter' = counter + 1

Next == Inc

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

----

Prop == TRUE \* this should PASS

====

