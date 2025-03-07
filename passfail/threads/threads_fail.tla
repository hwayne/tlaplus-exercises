---- MODULE threads_fail ----
EXTENDS Integers

VARIABLES pc, counter, tmp
vars == <<pc, counter, tmp>>

NumThreads == 5
Threads == 1..5

\* State transition action
Trans(thread, from, to) ==
  /\ pc[thread] = from
  /\ pc' = [pc EXCEPT ![thread] = to]

Init ==
  /\ pc = [t \in Threads |-> "start"]
  /\ counter = 0
  /\ tmp = [t \in Threads |-> 0]

GetCounter(t) ==
  /\ tmp' = [tmp EXCEPT ![t] = counter]
  /\ UNCHANGED counter

IncCounter(t) ==
  /\ counter' = tmp[t] + 1
  /\ UNCHANGED tmp

Next ==
  \/ \E t \in Threads:
    \/ /\ Trans(t, "start", "inc")
       /\ GetCounter(t)
    \/ /\ Trans(t, "inc", "done")
       /\ IncCounter(t)

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

----


Prop == FALSE \* this should FAIL
====
