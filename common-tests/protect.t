(test
  (trace
    (say
      (catch
        (protect
          (fn ()
            (say 'during)
            (throw 3))
          (fn ()
            (say 'after))))))
  '(during after 3))
