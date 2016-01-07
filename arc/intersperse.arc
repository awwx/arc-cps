(def intersperse (x ys)
  (and ys (cons (car ys)
                (mappend1 [list x _] (cdr ys)))))
