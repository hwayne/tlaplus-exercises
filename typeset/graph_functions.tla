Create the set of functions that each nodes to sets of other nodes.

This is one way to represent graphs in TLA+.

---- MODULE graph_functions ----
EXTENDS Integers, TLC

Nodes == {"a", "b", "c", "d"}

Typeset == {} \* Fill this in

Tests == { 
     [n \in Nodes |-> {}], \* Empty graph
     [n \in Nodes |-> Nodes], \* Complete graph
     [n \in Nodes |-> {"a"}], \* All nodes have edge to a
     [n \in Nodes |-> {n, "a"}] \* Edge to a + self-loop
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
