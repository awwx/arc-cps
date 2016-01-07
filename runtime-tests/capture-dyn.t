; Without capturing the dynamic environment, the function runs in
; dynamic environment of its caller.

(test
  (trace
    (let a (parameter)
      (let f (parameterize a 1
               (fn ()
                 (say (a))
                 'return-val))
        (parameterize a 2
          (say (f))))))
  '(2 return-val))

; By capturing the dynamic environment, the function instead runs in
; the captured dynamic environment.

(test
  (trace
    (let a (parameter)
      (let f (parameterize a 1
               (capture-dyn (fn ()
                              (say (a))
                              'return-val)))
        (parameterize a 2
          (say (f))))))
  '(1 return-val))
