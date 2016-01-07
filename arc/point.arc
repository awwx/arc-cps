(mac point (name . body)
  (w/uniq (g p)
    `(,ccc (,fn (,g)
              (,let ,name (,fn ((o ,p)) (,g ,p))
                 ,@body)))))

(mac catch body
  `(,point throw ,@body))
