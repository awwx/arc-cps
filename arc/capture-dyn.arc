(def capture-dyn (f)
  (let cf (prim-ccc (fn (throw)
                      (let cr (prim-ccc throw)
                        (cr (f)))))
    (fn ()
      (prim-ccc cf))))
