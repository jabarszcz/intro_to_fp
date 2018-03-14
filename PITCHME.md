# Introduction to functional programming

Functional programming concepts and examples in Haskell (and Erlang)

---
## What is Functional Programming (FP) ?

It is a programming paradigm where...

- **General (weak) definition**  
  Functions are first-class citizens, making higher-order functions possible.

- **(Pure) functional programming**  
  Functions behave like mathematical functions. (No side-effects or
  mutable data)

---
## Overview of Haskell

- Purely functional language
- Lazy (non-strict) evaluation strategy
- Strongly typed (Hindley-Milner type system)
- Garbage-Collected
- Version 1.0 in 1990
- Haskell 2010 is the latest standard

---
## Concepts of FP

---
### First-Class and Higher-Order Functions

Essentially:

- Functions can be passed as arguments and also as return values.
- There are generic functions that take other functions as arguments.

+++

#### First-Class and Higher-Order Function: A Haskell Example

```
> (\x -> x + 1) 2
3
> :t (\x -> x + 1)
(\x -> x + 1) :: Num a => a -> a
> filter even [1..10]
[2,4,6,8,10]
> :t filter
filter :: (a -> Bool) -> [a] -> [a]
> :t even
even :: Integral a => a -> Bool
```
@[1-4]
@[5-10]

- Other higher-order functions: `map`, `filter`, `fold`, `(.)`, `($)`,
`flip`, `curry`, `uncurry` ...

Note:
Currying of *filter* on the next slide.

---
### Currying

- In Haskell, we generally work with unary functions
- In order to handle multiple arguments, we return a function that
  consumes the next argument
- Currying allows for a nicer, uncluttered code, and eases composition

+++
#### Currying : A Haskell Example

```
> let foo arg1 arg2 = arg1 + arg2
> :t foo
foo :: Num a => a -> a -> a
> foo 1 2
3
> (foo 1) 2
3
> (uncurry foo) (1, 2)
3
> :t curry
curry :: ((a, b) -> c) -> a -> b -> c
> :t uncurry
uncurry :: (a -> b -> c) -> (a, b) -> c
> map (foo 2) [1..3]
[3,4,5]
```
@[1-7]
@[8-9]
@[10-13]
@[14-15]

---
### Sum Types

- Languages like C++ have product types with `struct`s (multiple parts
  at the same time)
- Sum types allow for alternation (one part of many) in data structure
  definitions
- Similar to C++ unions + a tag

```
> data Tree a = Empty | Branch (Tree a) a (Tree a) deriving (Show, Eq, Ord)
> let tree = Branch (Branch Empty 15 Empty) 34 Empty :: Tree Int
```

---
### Pattern matching

- Convenient syntax for conditionals

```
> :{
| let bar (Branch left elem right) = elem + bar left + bar right
|     bar Empty = 0
| :}
> :t bar
bar :: Num a => Tree a -> a
> show tree
"Branch (Branch Empty 15 Empty) 34 Empty"
> bar tree
49
```
@[1-6]
@[7-10]

---
### Pure functions / referential transparency

> An expression is said to be referentially transparent if it can be
> replaced with its corresponding value without changing the program's
> behavior. -- [[wiki]](https://en.wikipedia.org/wiki/Referential_transparency)

- Variables can only be assigned once
- Side effects are not allowed in pure functions
- Makes it easier to reason about programs

---
### Recursion instead of looping constructs

- There are no looping constructs at the language level
- Looping is done by (tail) recursion instead

```
> :{
| let countTrue (True:ls) = 1 + countTrue ls
|     countTrue (False:ls) = countTrue ls
|     countTrue [] = 0
| :}
> :t countTrue
countTrue :: Num a => [Bool] -> a
> countTrue [True, False, True, False]
2
> countTrue $ map even [1..7]
3
```

---

- Higher-order functions are often a more idiomatic alternative

```
> length . filter id $ [True, False, True, False]
2
> foldl (\x y -> x + if y then 1 else 0) 0 $ map even [1..7]
3
```

---
### Laziness (Evaluation Strategy)

- Some FP languages are "lazy"
- Evaluation of terms is done only when needed
- This makes "infinite" structures possible

```
> let list1 = [1..]
> take 10 list1
[1,2,3,4,5,6,7,8,9,10]
> take 20 list1
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
> let list2 = (1 : map (+1) list2)
> take 10 list2
[1,2,3,4,5,6,7,8,9,10]
```

---
#### Cons of laziness

- It is harder to reason about the cost of expressions
- Exceptions happen when the terms are evaluated, not necessarily
  where you expect

---
### Type System

---
### Persistent Data Structures - The Problem of Immutability

- Remember that we cannot directly mutate variables (or data
  structures for that matter)
- It seems that we have to make a deep copy of a data structure for
  every small mutation
- The solution is to use persistent data structures

+++
### Persistent Data Structures - The Solution

- Persistent data structures preserve their previous versions
- The trick is to share history
- Ex. : Singly linked lists have a persistent implementation

```
> let aList = [1,2,3]
> let modifiedList = (4 : tail aList)
> show modifiedList
"[5,2,3]"
```

```
1 -> 2 -> 3
     ^
     |
     4
```


+++
### Persistent Data Structures - List Zipper Example

- Zippers are persistent data structures that combine a container and
  a location

```
> data ListZipper a = Empty | ListZipper [a] a [a] deriving (Show)
> :{
| let next (ListZipper ps elem (n:ns)) = ListZipper (elem:ps) n ns
|     next lz = lz
|     prev (ListZipper (p:ps) elem ns) = ListZipper ps p (elem:ns)
|     prev lz = lz
|     listZipperFromList [] = Empty
|     listZipperFromList (l:ls) = ListZipper [] l ls
| :}
> let lz = listZipperFromList [1..3]
> show lz
"ListZipper [] 1 [2,3]"
> show . next $ lz
"ListZipper [1] 2 [3]"
> show . next . next $ lz
"ListZipper [2,1] 3 []"
> show . next . next . next $ lz
"ListZipper [2,1] 3 []"
> show . prev . next . next . next $ lz
"ListZipper [1] 2 [3]"
> show . prev . prev . next . next . next $ lz
"ListZipper [] 1 [2,3]"

```

+++
### Persistent Data Structures - Queue Example


---
## More on Haskell

+++
### What do we already know about Haskell?

- How to define functions and lambdas
- How to define parametric datatypes (parametric polymorphism -- one
  implementation for all types)
- ...

### What else do we need?

- Type Classes for ad-hoc polymorphism (different implementations for
  different types)
- A way to make effectful computations (IO monad)

+++
### Types and Typeclasses

+++
### Functor Class

+++
### Applicative Functor Class

+++
### Monad Class

+++
### The IO Monad

+++
### Haskell Resources

- (Hoogle)[https://www.haskell.org/hoogle/]
- (_A Gentle Introduction To Haskell_)[https://www.haskell.org/tutorial/]
- The book (_Learn You a Haskell for Great Good!_)[http://learnyouahaskell.com/]

---
## Overview of Erlang

- Not pure (stateful processes), but single assignement
- Strict evaluation strategy
- Dynamically typed
- Garbage-Collected

+++
### Erlang syntax basics

+++
### Example of a stateful process: the digraph server

+++
### Cool and advanced features of Erlang

- Built-in concurrency features like message-passing and supervision
  trees ease the writing of fault-tolerant software.
- It is possible to hot swap code!

+++
### Erlang resources

- The book [_Learn You Some Erlang for great good!_](http://learnyousomeerlang.com/)
  is a nice intro

---
## Questions ?
