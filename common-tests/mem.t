(test (mem 'x '(a b)) nil)
(test (mem 'a '(a b)) '(a b))
(test (mem 'b '(a b)) '(b))

(test (mem no '(a nil)) '(nil))

(test (mem [isa _ 'int] '(a b 2 c d)) '(2 c d))
