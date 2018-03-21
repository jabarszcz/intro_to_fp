# Introduction to functional programming

Functional programming concepts and examples in Haskell

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

Let's look at the common features found in FP languages.

The examples will be in Haskell and I will explain the syntax as we
go.

Do not hesitate to ask questions if anything is unclear.

---
### Type System

- Haskell and some other FP languages use the Hindley-Milner type
  system.

- It is able to deduce the most general type of an expression without
  explicit annotations.

- Types can be polymorphic (Ex.: `[a]` = a list of anything,
  `[String]` = a list of strings, `[Int]` = a list of ints)

- Types can be constrained (Ex.: `(Num a) => a` is any type that has
  `(+)`, `(-)`, etc.)

+++
#### Type System : Example

```
> :t "Hello"
"Hello" :: [Char]
> :t 12
12 :: Num a => a
> :t (12 :: Int)
(12 :: Int) :: Int
> data MyPair a = MakePair a a
> :t MakePair "hello" "world"
MakePair "hello" "world" :: MyPair [Char]
```
@[1-2]
@[3-6]
@[7-9]

+++
#### Type System : Typed Hole Example

```
> _what_goes_here + (5 :: Int)

<interactive>:30:1:
    Found hole ‘_what_goes_here’ with type: Int
    Relevant bindings include it :: Int (bound at <interactive>:30:1)
    In the first argument of ‘(+)’, namely ‘_what_goes_here’
    In the expression: _what_goes_here + (5 :: Int)
    In an equation for ‘it’: it = _what_goes_here + (5 :: Int)
```

---
### First-Class and Higher-Order Functions

Essentially:

- Functions are first-class values, as they can be passed as arguments
  and as return values.

- There are higher-order functions that take other functions as
  arguments.

+++
#### First-Class and Higher-Order Functions: Example

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

- In Haskell, we generally work with unary functions.

- In order to handle multiple arguments, we return a function that
  consumes the next argument.

- Currying makes composition simpler, allowing for nicer code.

+++
#### Currying : Example

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

- They complement product types (aggregation of multiple values
  together like our `MyPair`)

- With sum types, one of the values is allowed at a time, and we know
  which one is in use.

- Similar to C++ unions + a tag

+++
#### Sum Types : Example

- Haskell :

```
> data Tree a = Empty | Branch (Tree a) a (Tree a) deriving (Show)
> let tree = Branch (Branch Empty 15 Empty) 34 Empty :: Tree Int
```
- C++ equivalent :

```
enum TreeKind { Empty, Branch };

struct Tree {
    enum TreeKind kind;
    union {
        struct {
            int value;
            struct Tree *left, *right;
        };                    /* Branch */
        struct { };           /* Empty */
    };
};
```

---
### Pattern matching

- Convenient syntax for conditionals

```
> :{
| let bar (Branch left elem right) =
|             elem + bar left + bar right
|     bar Empty = 0
| :}
> :t bar
bar :: Num a => Tree a -> a
> show tree
"Branch (Branch Empty 15 Empty) 34 Empty"
> bar tree
49
```
@[1-7]
@[8-11]

---
### Pure functions / referential transparency

> An expression is said to be referentially transparent if it can be
> replaced with its corresponding value without changing the program's
> behavior. [[wiki]](https://en.wikipedia.org/wiki/Referential_transparency)

- Variables can only be assigned once.
- Side effects are not allowed in pure functions.
- Makes it easier to reason about programs.

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

+++
- Higher-order functions are often a more idiomatic alternative

```
> length . filter id $ [True, False, True, False]
2
> foldl (\x y -> x + if y then 1 else 0) 0 $ map even [1..7]
3
> :t foldl
foldl :: Foldable t => (b -> a -> b) -> b -> t a -> b
> let countTrue2 = foldl (\x y -> x + if y then 1 else 0) 0
> :t countTrue2
countTrue2 :: (Num b, Foldable t) => t Bool -> b
```

---
### Laziness (Evaluation Strategy)

- Some FP languages, like Haskell, are "lazy".
- Evaluation of terms is done only when needed.
- This makes "infinite" structures possible.

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

+++
#### Cons of laziness

- It is harder to reason about the cost of expressions.

- Exceptions happen when the terms are evaluated, not necessarily
  where you expect.

- Lazy IO can cause problems (the GC controls when the files are
  closed, so you can run out of FDs).

+++
#### Laziness and Exceptions Example

```
> undefined
*** Exception: Prelude.undefined
> :t undefined
undefined :: t
> head []
*** Exception: Prelude.head: empty list
> ["hello", undefined, head []]
["hello","*** Exception: Prelude.undefined
> take 1 $ ["hello", undefined, head []]
["hello"]
> drop 2 $ ["hello", undefined, head []]
["*** Exception: Prelude.head: empty list
```
@[1-4]
@[5-6]
@[7-8]
@[9-10]
@[11-12]

---
### Persistent Data Structures - The Problem of Immutability

- Remember that we cannot directly mutate variables (or data
  structures for that matter).

- It seems that we have to make a deep copy of a data structure for
  every small mutation.

- The solution is to use persistent data structures.

+++
### Persistent Data Structures - The Solution

- Persistent data structures preserve their previous versions.
- The trick is to share history.
- Ex. : Singly linked lists have a persistent implementation.

+++

```
> let aList = [1,2,3]
> let modifiedList = (4 : tail aList)
> show modifiedList
"[4,2,3]"
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
  a location.

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
```
+++
```
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

See example module ...

---
## More on Haskell

- Type constraints
- Monads and effectful computations

+++
### Types and Typeclasses

- We have seen parametric polymorphism with `MyPair a` (one
  implementation for all types).

- We can also do ad-hoc polymorphism with **Typeclasses** (different
  implementations for every type instance)

- (See `Typeclasses.hs`)

---
### Functors, Applicative Functors and Monads

- Those are three classes of objects that are often encountered in
  Haskell.

- A monad is always an applicative functor.

- An applicative functor is always a functor.

- They add a "context" for computation.

- [Pretty pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)
+++
### Data types that are Monads (and Applicative Functors)

- `data Maybe a = Nothing | Just a`

- `data Either a b = Left a | Right b` where `Left` is the error case
  and `Right` the normal result

- `[]`, the list type

- Also :`IO a`, `ST s a`, etc.

+++
### Functor Class

```
class  Functor f  where
    fmap        :: (a -> b) -> f a -> f b
    -- ...

    -- Functor Laws:
    --  fmap id  ==  id
    --  fmap (f . g)  ==  fmap f . fmap g
```

- [Documentation](http://hackage.haskell.org/package/base-4.11.0.0/docs/Prelude.html#t:Functor)

+++
### Applicative Functor Class

```
class Functor f => Applicative f where
    -- | Lift a value.
    pure :: a -> f a

    -- | Sequential application.
    --
    -- A few functors support an implementation of '<*>' that is more
    -- efficient than the default one.
    (<*>) :: f (a -> b) -> f a -> f b
    (<*>) = liftA2 id

    -- ...
```
+++
```
    -- Applicative Functor Laws:
    --  - identity
    --      pure id <*> v = v
    --  - composition
    --      pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
    --  - homomorphism
    --      pure f <*> pure x = pure (f x)
    --  - interchange
    --      u <*> pure y = pure ($ y) <*> u
```

+++
### Monad Class

```
class Applicative m => Monad m where
    -- | Sequentially compose two actions, passing any value produced
    -- by the first as an argument to the second.
    (>>=)       :: forall a b. m a -> (a -> m b) -> m b

    -- | Sequentially compose two actions, discarding any value produced
    -- by the first, like sequencing operators (such as the semicolon)
    -- in imperative languages.
    (>>)        :: forall a b. m a -> m b -> m b
    m >> k = m >>= \_ -> k

    -- | Inject a value into the monadic type.
    return      :: a -> m a
    return      = pure

    -- ...
```
+++

```
    -- Monad Laws
    --  return a >>= k  =  k a
    --  m >>= return  =  m
    --  m >>= (\x -> k x >>= h)  =  (m >>= k) >>= h
```

+++
### The IO Monad

- Often, monads have a way to extract the value from the context (ex.:
  pattern match or `fromJust`).

- IO values are stuck in the IO monad (unless you use
  `unsafePerformIO`)

- This makes a clear separation between pure and effectful
  computations.

---
### Haskell Resources

- [Hoogle](https://www.haskell.org/hoogle/)
- [_A Gentle Introduction To Haskell_](https://www.haskell.org/tutorial/)
- The book [_Learn You a Haskell for Great Good!_](http://learnyouahaskell.com/)

---
## Questions ?
