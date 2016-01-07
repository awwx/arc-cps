(test (find 3 '(1 2 3 4)) 3)
(test (find 5 '(1 2 3 4)) nil)
(test (find [isa _ 'int] '(a b 2 c)) 2)
(test (find #\b "abcd") #\b)
