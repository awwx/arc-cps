(test
  (catch (do 1
             2
             (throw 3)
             4
             5))
  3)
