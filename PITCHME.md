# Introduction to functional programming

Functional programming concepts and examples in Haskell and Erlang

---
## What is functional programming (FP) ?

It is a programming paradigm where...

- **General (weak) definition**  
  Functions are first-class citizens, making higher-order functions possible.

- **(Pure) functional programming**  
  Functions behave like mathematical functions. (No side-effects or
  mutable data)

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

- Currying allows for a nicer, uncluttered syntax
- We work with functions taking only one argument
- For multiple args, we return a function that consumes the next argument
- Currying is used in Haskell but not in Erlang

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
### Pattern matching (and Sum Types)



---
### Pure functions / referential transparency

---
### Recursion instead of looping constructs

---
### Laziness (Evaluation Strategy)

---
### Type System

---
### Persistent Data structures

---
## More on Haskell

- Purely functional language
- Lazy (non-strict) evaluation strategy
- Strongly typed (Hindley-Milner type system)
- Garbage-Collected

+++
### Haskell syntax basics

+++
### Types and Typeclasses

+++
### A brief explanation of monads

---
## More on Erlang

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
