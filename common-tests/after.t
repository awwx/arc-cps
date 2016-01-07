(test
  (let x 1
    (after (= x 2) (= x 3))
    x)
  3)
