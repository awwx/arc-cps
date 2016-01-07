(mac trace body
  (w/uniq gacc
    `(,withs (,gacc nil
              say (,fn (x) (,assign ,gacc (,cons x ,gacc))))
       ,@body
       (,rev ,gacc))))
