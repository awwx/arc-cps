(prim-namespace
  (test (cps-aexpr 123) 123)

  (def cps (f)
      (fn (k . args)
        (k (apply f args))))

  (def halt0 (x)
    x)

  (def ueval (x)
    (eval (unprimitive x)))

  (test ((ueval:cps-aexpr '($fn () 123))
         halt0)
    123)

  (test ((ueval:cps-aexpr '($fn () ($begin 123)))
         halt0)
    123)

  (test ((ueval:cps-aexpr '($fn () ($begin 123 456)))
         halt0)
    456)

  (test (ueval (T-c `($quote (a b c)) halt0)) '(a b c))

  (test (ueval (T-c `(,cps.- 42)   halt0)) -42)
  (test (ueval (T-c `(,cps.+ 10 5) halt0)) 15)

  (test (ueval `(let foo nil
                  ,(T-c `($assign foo 123) halt0)
                  foo))
    123)

  (test (ueval `(with (v1 nil v2 nil)
                  ,(T-c `($begin ($assign v1 123)
                                 ($assign v2 456))
                        halt0)
                  (list v1 v2)))
    '(123 456))

  (test (ueval (T-c `($if 1 2 3) halt0)) 2)

  (test (ueval (T-c `($if ($quote t)   (,cps.+ 1 2) 42) halt0)) 3)
  (test (ueval (T-c `($if ($quote nil) (,cps.+ 1 2) 42) halt0)) 42)

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `($begin (,tr 1)
                            (,tr 2))
                   halt0))))
   '(1 2))

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `($begin ($if 1 (,tr 2) (,tr 3)))
                   halt0))))
   '(2))

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `($begin ($if nil (,tr 2) (,tr 3)))
                   halt0))))
   '(3))

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `($begin ($if 1 (,tr 2) (,tr 3))
                            ($if 4 (,tr 5) (,tr 6)))
                   halt0))))
   '(2 5))

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `($if (,cps.no (,cps.odd 3))
                         (,tr 1)
                         (,tr 2))
                   halt0))))
   '(2))

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `(,tr (($if 1 ,cps.+ ,cps.-) 4 3))
                   halt0))))
   '(7))

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `(,tr ($if ($if nil nil 1) 2 3))
                   halt0))))
   '(2))

  (test
   (accum trace
     (let tr (cps trace)
       (ueval (T-c `(,tr ($if ($if 1 nil 2) 3 4))
                   halt0))))
   '(4)))
