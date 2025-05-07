Create the set of all functions that map values of S to values of T.

---- MODULE functions ----
EXTENDS TLC

S == {1, 3}
T == {"a", "b"}

Typeset == {} \* Fill this in

PositiveTests == { 
      1 :> "a" @@ 3 :> "a",
      1 :> "a" @@ 3 :> "b",
      1 :> "b" @@ 3 :> "a",
      1 :> "b" @@ 3 :> "b"
    } 

NegativeTests == {
      1 :> "a",
      1 :> "a" @@ 3 :> "c",
      1 :> "a" @@ 3 :> "b" @@ 2 :> "b"
    } 

Eval == 
  \* /\ PrintT(Typeset)          \* Uncomment to print set
  \* /\ PrintT(TLCEval(Typeset)) \* Uncomment to print all elements in set
  /\ LET 
      invalid_positive == {t \in PositiveTests: t \notin Typeset} 
      invalid_negative == {t \in NegativeTests: t \in Typeset}
     IN IF invalid_positive \union invalid_negative = {} 
        THEN PrintT("All Correct!")
        ELSE /\ PrintT("Incorrect. The following were not present in the set:")
             /\ PrintT(invalid_positive)
             /\ PrintT("And the following were present in the set but shouldn't be:")
             /\ PrintT(invalid_negative)

Spec == Eval /\ [][TRUE]_TRUE


====
