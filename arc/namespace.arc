(mac as (type expr)
  `(coerce ,expr ',type))

(mac ret (var val . body)
  `(let ,var ,val ,@body ,var))

(def namespace-mapping (suffix syms)
  (ret m (table)
    (each s syms
      (= m.s (as sym (+ (as string s) "--" suffix))))))

(def replace-tree (x mapping)
  (aif (mapping x)
        it
       (acons x)
        (cons (replace-tree (car x) mapping)
              (replace-tree (cdr x) mapping))
        x))

(mac namespace ((suffix . syms) . body)
  `(do ,@(replace-tree body (namespace-mapping suffix syms))))
