# Passfail exercises

In this set of exercises, you will be presented with two specifications that each do the same thing. You will need to write `Prop` so that one spec **passes** the property and one spec **fails** the property. For example, you might be presented with these:


```tla
---- module example_pass ----
VARIABLE x

Init == x = TRUE
Next == x' = TRUE
Spec == Init /\ [][Next]_x
====

---- module example_fail ----
VARIABLE x

Init == x = TRUE
Next == x' \in BOOLEAN
Spec == Init /\ [][Next]_x
====
```

In this example, one solution would be `Prop == []x`. Solutions to each exercise can be found in the `solutions` folder.

Additional rules:

- You do not need to change anything about either spec *except* the definition of `Prop`. `Prop` will always be the same for both specs.
- "Fail" means either an invariant is violated or temporal properties are violated. It does not count if you trigger a parse error, a deadlock, or a runtime exception (like comparing a string and an integer).
- There may be multiple solutions to a given exercise. Try to find one that corresponds to what the spec is actually "doing", ie could be a realistic property in a realistic system.
- Each exercise has a corresponding `cfg` file. All configs will check `PROPERTY Prop` but may also have additional setup, like disabling deadlocks.
- If prop is an invariant, remember to prefix it with a `[]`. Write `Prop == []x`, not `Prop == x`.
- As of now there are no refinements or action properties- everything is an invariant or liveness.

Tips:

- Try to determine how the two specs diverge: what's a behavior in the failing spec that isn't possible in the passing spec?

