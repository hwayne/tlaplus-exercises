---- MODULE cs_fail ----
EXTENDS Integers

VARIABLES pc
vars == <<pc>>

NumThreads == 2
Threads == 1..2

\* State transition action
Trans(thread, from, to) ==
  /\ pc[thread] = from
  /\ pc' = [pc EXCEPT ![thread] = to]

Init ==
  /\ pc = [t \in Threads |-> "waiting"]

EnterCriticalSection(t) ==
  /\ Trans(t, "waiting", "cs")

LeaveCriticalSection(t) ==
  /\ Trans(t, "cs", "waiting")

Next ==
  \/ \E t \in Threads:
    \/ EnterCriticalSection(t)
    \/ LeaveCriticalSection(t)

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

----


Prop == FALSE \* this should FAIL

====
