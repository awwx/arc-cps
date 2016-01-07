(with (a1 (parameter)
       c1 nil
       x  0)
  (parameterize a1 123
    (ccc (fn (c)
           (assign c1 c)
           nil))
    (test (a1) 123))
  (assign x (+ x 1))
  (if (is x 1)
    (parameterize a1 456
      (c1 nil))))
