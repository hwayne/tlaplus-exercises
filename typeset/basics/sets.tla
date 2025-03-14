Create the set of all subsets of Elems, including the empty set.

---- MODULE sets ----
EXTENDS Integers, TLC

Elems == {"a", "b", "c", "d"}

Typeset == {} \* Fill this in

Tests == { 
      {},
      {"a"},
      {"a", "d"},
      {"b", "c", "d"},
      Elems
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
