In this exercise, Typeset is an OPERATOR that takes a number N and returns the set of length-N tuples where all values are in S. Eg, Typeset(19) should be allthe length-19 tuples.

---- MODULE tuples ----

EXTENDS Integers, TLC

S == {1, 3, 5, 7}

Typeset(N) == {} \* Fill this in

ThreeTests == { 
      <<1, 3, 5>>,
      <<5, 5, 5>>,
      <<7, 1, 1>>
    } 

FourTests == { 
      <<1, 3, 1, 5>>,
      <<1, 3, 1, 7>>,
      <<5, 5, 5, 5>>
    } 

Eval == 
  \* /\ PrintT(Typeset(3))          \* Uncomment to print set
  \* /\ PrintT(TLCEval(Typeset(3))) \* Uncomment to print all elements in set
  /\ LET 
      invalid_three == {t \in ThreeTests: t \notin Typeset(3)} 
      invalid_four == {t \in FourTests: t \notin Typeset(4)}
     IN IF invalid_three \union invalid_four = {} 
        THEN PrintT("All Correct!")
        ELSE /\ PrintT("Incorrect. The following were not present in the 3-set:")
             /\ PrintT(invalid_three)
             /\ PrintT("And the following were not present in the 4-set:")
             /\ PrintT(invalid_four)

Spec == Eval /\ [][TRUE]_TRUE
====
