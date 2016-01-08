# Arc CPS

[A Functional Implementation of Dynamic Wind](http://awwx.github.io/functional-implementation-of-dynamic-wind.html)

Runs &nbsp;e x t r e m e l y &nbsp; s l o w l y&nbsp; due to multiple
layers of unoptimized code.  This is a proof of concept of a thought
experiment...  not a useful implementation to program in :)

    racket -f run.scm

and to run the dynamic wind tests directly in Arc (thus testing
Racket's interpretation of the interaction between continuations,
dynamic-wind, and parameters):

    racket -f wind.t.scm
