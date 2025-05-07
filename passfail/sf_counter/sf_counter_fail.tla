---- MODULE sf_counter_fail ----
EXTENDS Integers

VARIABLES counter
vars == <<counter>>

Max == 5

Init == 
    counter = 0

Inc ==
    /\ counter < Max
    /\ counter' = counter + 1

Reset == counter' = 0

Next == Inc \/ Reset

Fairness ==
    /\ WF_vars(Next)
    /\ \A i \in 0..(Max-1):
        WF_vars(counter = i /\ Inc)

Spec == Init /\ [][Next]_vars /\ Fairness

----

Prop == FALSE \* this should FAIL

====