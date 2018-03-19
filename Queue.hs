module Queue where

data Queue a = Queue [a] [a] deriving (Show)

emptyQueue = Queue [] []

enqueue :: Queue a -> a -> Queue a -- Optional type signature
enqueue (Queue ins outs) elem = Queue (elem:ins) outs

-- inferred type signature : dequeue :: Queue a ->  (Queue a, a)
dequeue (Queue ins (o:os)) = (Queue ins os, o)
dequeue (Queue ins []) = dequeue (Queue [] (reverse ins))

-- Heavy copy when reversing [O(N)], but is amortized O(1)
-- ... is there a problem with this implementation?
