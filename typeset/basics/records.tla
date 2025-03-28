Create the set of all records where key name is in the set Name and the key id is in the set Id.

(Records are also sometimes called "structs".)

---- MODULE records ----
EXTENDS Integers, TLC

Name == {"a", "b"}
Id == 1..2

Typeset == {} \* Fill this in

Tests == { 
      [name |-> "a", id |-> 1],
      [name |-> "a", id |-> 2],
      [name |-> "b", id |-> 1],
      [name |-> "b", id |-> 2]
    } 

Eval == 
  \* /\ PrintT(Typeset)          \* Uncomment to print set
  \* /\ PrintT(TLCEval(Typeset)) \* Uncomment to print all elements in set
  /\ LET invalid == {t \in Tests:  t \notin Typeset} 
     IN IF invalid = {} 
        THEN PrintT("All Correct!")
        ELSE /\ PrintT("Incorrect. The following were not present in the set:")
             /\ PrintT(invalid)

Spec == Eval /\ [][TRUE]_TRUE

====

====
