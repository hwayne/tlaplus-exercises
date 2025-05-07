---- MODULE sf_counter_pass ----
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
        SF_vars(counter = i /\ Inc)
    
Spec == Init /\ [][Next]_vars /\ Fairness

----

Prop == TRUE \* this should PASS

====