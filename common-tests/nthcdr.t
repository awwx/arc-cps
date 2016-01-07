(test (nthcdr 0 '(a b c d)) '(a b c d))
(test (nthcdr 2 '(a b c d)) '(c d))
(test (nthcdr 4 '(a b c d)) '())
(test (nthcdr 5 '(a b c d)) '())
