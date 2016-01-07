(mac unless (test . body)
  `(,if (,no ,test) (,do ,@body)))
