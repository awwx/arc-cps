(def nthcdr (n xs)
  (if (no n)
       xs
      (> n 0)
       (nthcdr (- n 1) (cdr xs))
       xs))
