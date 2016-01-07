(test (on-err (fn (c) (details c))
        (fn () (err "foo")))
  "foo")
