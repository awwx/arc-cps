; Argument destructuring and optional arguments.

(def fn-complex-args? (args)
  (if (no args)
       nil
      (isa args 'sym)
       nil
      (and (acons args) (isa (car args) 'sym))
       (fn-complex-args? (cdr args))
       t))

(def fn-complex-opt (var expr ra)
  `((,var (if (acons ,ra)
               (car ,ra)
               ,expr))))

(def fn-complex-args (args ra)
  (if (no args)
       nil
      (isa args 'sym)
       `((,args ,ra))
      (acons args)
       (let x (if (and (acons (car args)) (is (caar args) 'o))
                   (fn-complex-opt (cadar args)
                                   (if (acons (cddar args)) (caddar args) nil)
                                   ra)
                   (fn-complex-args (car args) `(,car ,ra)))
         (join x (fn-complex-args (cdr args) `(,cdr ,ra))))
       (err "Can't understand fn arg list" args)))

(def fn-complex-fn (args body)
  (w/uniq ra
    (let z (apply join (fn-complex-args args ra))
      `($fn--xVrP8JItk2Ot ,ra
         (,withs ,z ,@body)))))

(def fn-body (body)
  (if (no body)
       '(nil)
      (no (cdr body))
       body
       `(($begin--xVrP8JItk2Ot ,@body))))

(mac fn (args . body)
  (if (fn-complex-args? args)
       (fn-complex-fn args body)
       `($fn--xVrP8JItk2Ot ,args ,@(fn-body body))))
