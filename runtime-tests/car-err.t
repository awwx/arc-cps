(on-err
  (fn (c)
    (test (details c) "Can't take car of 3"))
  (fn ()
    (car 3)))

(test
  (on-err
    (fn (c)
      (list 'err (details c)))
    (fn ()
      (car 3)))
  '(err "Can't take car of 3"))
