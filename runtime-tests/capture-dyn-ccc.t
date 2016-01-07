(test
  (p (trace
    (catch
      (let f (on-err (fn (c)
                       (say (list 'a (details c)))
                       (throw))
               (fn ()
                 (capture-dyn (fn ()
                                (err 'foo)))))
        (on-err (fn (c)
                  (say (list 'b (details c)))
                  (throw))
          (fn ()
            (f)))))))
  '((a "foo")))
