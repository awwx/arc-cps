(test (some #\c "abcdef") t)
(test (some #\x "abcdef") nil)

(test (some (fn (x) (or (is x #\a) (is x #\b)))
            "def")
      nil)

(test (some (fn (x) (or (is x #\a) (is x #\b)))
            "dbf")
      t)

(test (some 2 '())        nil)
(test (some 3 '(1 2 3 4)) t)
(test (some 5 '(1 2 3 4)) nil)

(test (some no '(t t t t)) nil)
(test (some no '(nil))     t)
