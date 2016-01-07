(mac p1 (x)
  (w/uniq (gx)
    `(let ,gx ,x
       (write ',x)
       (disp ": ")
       (write (xhash ,gx))
       (disp #\newline)
       ,gx)))

(mac p xs
  `(do ,@(map (fn (x) `(p1 ,x)) xs)))
