# Typeset exercises

In these exercises, you will be asked to generate a set matching some conditions. For example, you might be presented with:

```tla
--- MODULE example ----
EXTENDS Integers

Typeset == {} \* all integers between 1 and 10
====
```

In this example, one solution would be `Typeset == 1..10`. Solutions to each exercise can be found in the `_solutions` folder.

Additional rules:

- Each exercise is runnable with `SPECIFICATION Spec` as the `.cfg`. Exercises will test that some representative items are in the set, and optionally some items that *should not* be in the set. Tests are *not* comprehensive.
- You may need to use set map and filter to make the sets.


<!--Todo: one exercise for each basic set type-->

Tips:

- Each exercise comes with two lines you can comment for diagnostic information. The first, `PrintT(Typeset)`, will print your set in condensed form. The second, `PrintT(TLCEval(Typeset))`, will try to print every element in your set. Just be careful, it can freeze the checker if your set is too big!

### Purpose

It's good practice to write a `TypeInvariant` for all of your specs that constrains the values of your variables:

```
TypeInvariant ==
    /\ msg \in MessageType
    \* etc
```

The "type" of `msg` is `MessageType`, as it's the set of values that `msg` can have. It's useful to practice defining sets for this reason. It's also helpful for making nondeterministic selections of values. 
