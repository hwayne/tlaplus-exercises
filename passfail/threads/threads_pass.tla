---- MODULE threads_pass ----
EXTENDS Integers

VARIABLES pc, counter
vars == <<pc, counter>>

NumThreads == 5
Threads == 1..5

\* State transition action
Trans(thread, from, to) ==
  /\ pc[thread] = from
  /\ pc' = [pc EXCEPT ![thread] = to]

\* Both threads start in the `start` state
Init ==
  /\ pc = [t \in Threads |-> "start"]
  /\ counter = 0

Next ==
  \/ \E t \in Threads:
     /\ Trans(t, "start", "done")
     /\ counter' = counter + 1

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

----

Prop == TRUE \* this should PASS

====
