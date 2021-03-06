(mac extend-def (name arglist test . body)
  (w/uniq args
    `(let orig ,name
       (assign ,name
         (fn ,args
           (aif (apply (fn ,arglist ,test) ,args)
                 (apply (fn ,arglist ,@body) ,args)
                 (apply orig ,args)))))))
