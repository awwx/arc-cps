(let m (parameter)
  (let f (fn () (m))
    (parameterize m 123
      (test (f) 123))))
