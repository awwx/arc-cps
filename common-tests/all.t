(test (all #\a "")     t)
(test (all #\a "aaaa") t)
(test (all #\a "aaba") nil)

(test (all (fn (c) (in c #\a #\b)) "")      t)
(test (all (fn (c) (in c #\a #\b)) "aabba") t)
(test (all (fn (c) (in c #\a #\b)) "aabca") nil)

(test (all 'a '(a a a))       t)
(test (all 'a '(a b a))       nil)

(test (all no '())            t)
(test (all no '(a))           nil)
(test (all no '(nil))         t)
(test (all no '(nil nil nil)) t)
