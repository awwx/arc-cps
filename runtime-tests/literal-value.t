(test (literal-value 3)              3)
(test (literal-value car)            car)
(test (literal-value "abc")          "abc")
(test (literal-value 'nil)           nil)
(test (literal-value '(quote 3))     3)
(test (literal-value (list quote 3)) 3)
