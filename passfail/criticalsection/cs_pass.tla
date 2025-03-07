---- MODULE cs_pass ----
EXTENDS Integers

VARIABLES pc, lock
vars == <<pc, lock>>

NumThreads == 2
Threads == 1..2

\* State transition action
Trans(thread, from, to) ==
  /\ pc[thread] = from
  /\ pc' = [pc EXCEPT ![thread] = to]

Init ==
  /\ pc = [t \in Threads |-> "waiting"]
  /\ lock = 0

EnterCriticalSection(t) ==
  /\ lock = 0
  /\ lock' = t
  /\ Trans(t, "waiting", "cs")

LeaveCriticalSection(t) ==
  /\ lock = t
  /\ lock' = 0
  /\ Trans(t, "cs", "waiting")

Next ==
  \/ \E t \in Threads:
    \/ EnterCriticalSection(t)
    \/ LeaveCriticalSection(t)

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

----


Prop == TRUE \* this should PASS

====
