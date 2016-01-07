(= cdddr cdr:cddr)

(prim-namespace

  (= primitives '($assign $begin $dyn $fn $if $quote))

  (def cps-call-pass (x)
    (if (and (acons x)
             (no (mem [is (car x) _] primitives)))
         `(,ar-cps-call ,@(map cps-call-pass x))
        (caris x '$assign)
         `($assign ,(cadr x) ,(cps-call-pass (caddr x)) ,@(cdddr x))
        (caris x '$begin)
         `($begin ,@(map cps-call-pass (cdr x)))
        (caris x '$fn)
         `($fn ,(cadr x) ,(cps-call-pass (caddr x)))
        (caris x '$if)
         `($if ,@(map cps-call-pass (cdr x)))
         x)))
