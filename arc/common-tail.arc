(def common-tail (x y)
  (with (lx (len x) ly (len y))
    ((afn (x y)
       (if (is x y)
            x
            (self (cdr x) (cdr y))))
     (if (> lx ly) (nthcdr (- lx ly) x) x)
     (if (> ly lx) (nthcdr (- ly lx) y) y))))
