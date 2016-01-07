(test
  (w/compile-options (obj globals (obj))
    (macro 'foo))
  nil)

(test
  (w/compile-options (obj globals (obj foo 'hi))
    (macro 'foo))
  nil)

(let m (annotate 'mac 'hi)
  (w/compile-options (obj globals (obj foo m))
    (test (macro 'foo ) m))
  (w/compile-options (obj globals (obj))
    (test (macro m)     m)))

(test (arglist '(a b . c)) '(a b c))

(= test-do
  (annotate 'mac
    (fn args
      `(($fn--xVrP8JItk2Ot () ,@args)))))

(= test-globals (obj do test-do))

(= test-globals!global
  (annotate 'mac
    (fn (name)
      `(,test-globals ',name))))

(mac testm args
  `(do ,@(map (fn ((input expected))
                `(test (macro-expand ,input test-globals) ,expected))
              (pair args))))

(testm
  `(,+ 1 2)
  `(,+ 1 2)

  `($fn--xVrP8JItk2Ot (a) a)
  `($fn--xVrP8JItk2Ot (a) a)

  `($fn--xVrP8JItk2Ot (a) (a 3))
  `($fn--xVrP8JItk2Ot (a) (a 3))

  '(do 1 2)
  `(($fn--xVrP8JItk2Ot () 1 2))

  `(,test-do 1 2)
  `(($fn--xVrP8JItk2Ot () 1 2))

  `((do ,-) (do 2))
  `((($fn--xVrP8JItk2Ot () ,-))
    (($fn--xVrP8JItk2Ot () 2)))

  '(do (do 1) 2)
  `(($fn--xVrP8JItk2Ot () (($fn--xVrP8JItk2Ot () 1)) 2))

  '($fn--xVrP8JItk2Ot () (do 1 2))
  `($fn--xVrP8JItk2Ot () (($fn--xVrP8JItk2Ot () 1 2)))

  '($fn--xVrP8JItk2Ot (do) (do 3))
  `($fn--xVrP8JItk2Ot (do) (do 3))

  `($fn--xVrP8JItk2Ot (do) (,test-do 3))
  `($fn--xVrP8JItk2Ot (do) (($fn--xVrP8JItk2Ot () 3)))

  `($fn--xVrP8JItk2Ot (do a) (a do))
  `($fn--xVrP8JItk2Ot (do a) (a do))

  '($quote--xVrP8JItk2Ot (do a b))
  `($quote--xVrP8JItk2Ot (do a b)))
