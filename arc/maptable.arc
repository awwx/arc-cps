(def maptable (f table)
  (loop next (ks (keys table))
    (when ks
      (f (car ks) (table (car ks)))
      (next (cdr ks))))
  table)
