(def expand-implicit (e)
  (if (caris e '$assign--xVrP8JItk2Ot)
       `($assign--xVrP8JItk2Ot ,(e 1) ,(expand-implicit (e 2)))
      (caris e '$begin--xVrP8JItk2Ot)
       `($begin--xVrP8JItk2Ot ,@(map expand-implicit (cdr e)))
      (caris e '$fn--xVrP8JItk2Ot)
       (let (_fn args . body) e
         `($fn--xVrP8JItk2Ot ,(cons '$dyn--xVrP8JItk2Ot args)
            ,@(map expand-implicit body)))
      (caris e '$quote--xVrP8JItk2Ot)
       e
      (caris e '$if--xVrP8JItk2Ot)
       `($if--xVrP8JItk2Ot ,@(map expand-implicit (cdr e)))
      (acons e)
       `(,(expand-implicit (car e))
         $dyn--xVrP8JItk2Ot
         ,@(map expand-implicit (cdr e)))
      e))

(def expand-implicit-call ((_fn . args))
  `(,(expand-implicit _fn) $dyn--xVrP8JItk2Ot ,@(map expand-implicit args)))

(def expand-implicit-assign ((_assign . args))
  `(,_assign ,@(map expand-implicit args)))

(def expand-implicit-fn ((_fn args . body))
  `(,_fn ,(cons '$dyn--xVrP8JItk2Ot args)
     ,@(map expand-implicit body)))

(def expand-implicit-if ((_if . exprs))
  `(,_if ,@(map expand-implicit exprs)))
