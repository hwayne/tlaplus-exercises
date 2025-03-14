Create the set of all pairs of elements where the first element is in S and the second is in T.

---- MODULE pairs ----
EXTENDS TLC

S == {1, 3, 5}
T == {2, 4, 6}

Typeset == {} \* Fill this in

PositiveTests == { 
      <<1, 2>>,
      <<1, 4>>,
      <<3, 6>>,
      <<5, 2>>
    } 

NegativeTests == { 
      <<2, 1>>,
      <<4, 1>>,
      <<6, 3>>,
      <<2, 5>>,
      <<1, 8>>,
      <<3, 3>>
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
