(mac parameterize (param val . body)
  `(ar-parameterize ,param ,val (fn () ,@body)))
