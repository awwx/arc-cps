(def protect (during after)
  (dynamic-wind (fn ()) during after))
