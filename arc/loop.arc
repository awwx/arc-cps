(mac loop (name withses . body)
  (let w (pair withses)
    `((,rfn ,name ,(map car w) ,@body)
      ,@(map cadr w))))
