(def abort (msg)
  (ar-disp (ar-string-append "error: " msg "\n") (stderr))
  (quit 1))

(def details (msg) msg)

(assign errh (parameter))

(def err args
  (let msg (format-err args)
    ((or (errh) abort) msg))
  (abort "oops, unexpected return from error handler"))

(def on-err (errf f)
  (ccc (fn (throw)
         (parameterize errh (fn (msg)
                              (throw (errf msg)))
           (f)))))

(def format-err (args)
  (on-err
    (fn (c)
      (abort (details c)))
    (fn ()
      (apply ar-string-append
             (intersperse " " (map1 [coerce _ 'string] args))))))

(ar-set-err-hook err)
