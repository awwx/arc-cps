(test (intersperse 'x '())      '())
(test (intersperse 'x '(1))     '(1))
(test (intersperse 'x '(1 2))   '(1 x 2))
(test (intersperse 'x '(1 2 3)) '(1 x 2 x 3))
