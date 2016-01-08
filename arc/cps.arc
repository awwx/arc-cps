; CPS conversion pass
; Derived from Matt Might's scheme-cps-convert.rkt from
; http://matt.might.net/articles/cps-conversion/

(prim-namespace
  (= caddr car:cddr)

  (def aexpr? (x)
    (or (literal x)
        (isa x 'sym)
        (caris x '$fn)))

  ; In this demo Arc 3.1 is the target runtime, and both "assign" and
  ; "if" return values which we need to capture and pass on to the
  ; continuation.  (I'm guessing this probably would be simpler in a
  ; target runtime where the primitives passed their return values on
  ; to the continuation directly).

  (def cps-convert (k prim)
    (fn (aexp)
      (w/uniq ($k $rv)
        `(($fn (,$k)
            ,(prim aexp $k))
          ($fn (,$rv)
            ,(k $rv))))))

  (def T-k (expr k)
    (if (aexpr? expr)
         (k (cps-aexpr expr))

        (and (caris expr '$begin) (no (cddr expr)))
         (T-k (cadr expr) k)

        (caris expr '$begin)
         (T-k (cadr expr)
              (fn (_)
                (T-k `($begin ,@(cddr expr)) k)))

        (caris expr '$assign)
         (let (_assign var value) expr
           (T-k value
                (cps-convert k (fn (aexp $k)
                                 `(,$k ($assign ,var ,aexp))))))

        (caris expr '$if)
         (let (_if exprc exprt exprf) expr
           (T-k exprc
                (cps-convert k (fn (aexp $k)
                                 `($if ,aexp
                                     ,(T-c exprt $k)
                                     ,(T-c exprf $k))))))

        (acons expr)
         (w/uniq rv
           (let cont `($fn (,rv) ,(k rv))
             (T-c expr cont)))

         (err "invalid cexpr" expr)))

  (def T-c (expr c)
    (unless (aexpr? c)
      (err "oops, continuation passed to T-c is not an aexpr:" c))

    (if (aexpr? expr)
         `(,c ,(cps-aexpr expr))

        (and (caris expr '$begin) (no (cddr expr)))
         (T-c (cadr expr) c)

        (caris expr '$begin)
         (T-k (cadr expr)
              (fn (_)
                (T-c `($begin ,@(cddr expr)) c)))

        (caris expr '$assign)
         (T-k (caddr expr)
              (fn (aexp)
                `(,c ($assign ,(cadr expr) ,aexp))))

        (caris expr '$if)
         (let (_if exprc exprt exprf) expr
           (w/uniq k
             `(($fn (,k)
                 ,(T-k exprc (fn (aexp)
                               `($if ,aexp
                                   ,(T-c exprt k)
                                   ,(T-c exprf k)))))
               ,c)))

        (acons expr)
         (T-k (car expr)
              (fn ($f)
                (T*-k (cdr expr)
                      (fn ($es)
                        `(,$f ,c ,@$es)))))

         (err "invalid cexpr" expr)))

  (def T*-k (exprs k)
    (if (no exprs)
         (k '())
        (acons exprs)
         (T-k (car exprs)
              (fn (hd)
                (T*-k (cdr exprs)
                      (fn (tl)
                        (k (cons hd tl))))))
         (err "T*-k: exprs not a list:" exprs)))

  (def cps-aexpr (x)
    (if (caris x '$fn)
         (cps-aexpr-fn x)
        (or (isa x 'sym) (literal x))
         x
         (err "cps-aexpr: not an aexpr:" x)))

  (def cps-aexpr-fn ((_fn parms body))
    (w/uniq k
      `($fn ,(cons k parms) ,(T-c body k)))))
