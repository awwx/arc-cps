(mac named-fn (name parms . body)
  `(,namefn ',name (fn ,parms ,@body)))

(def cps-apply (f args)
  (if (isa f 'fn)
       (apply f args)
      (isa f 'param)
       (let (k dyn) args
         (k (alref dyn (rep f))))
       (let (k dyn . rest) args
         (k (apply f rest)))))

(def cps-call (f . args)
  (cps-apply f args))

(def list* args
  (if (no args)
       nil
      (no (cdr args))
       (car args)
       (cons (car args) (apply list* (cdr args)))))

(test (list*)            nil)
(test (list* 1 2)        '(1 . 2))
(test (list* 1 2 '(3 4)) '(1 2 3 4))

(= cr (table))

(= cr!apply
  (named-fn cps-apply (k dyn f . args)
    (cps-apply f (cons k (cons dyn (apply list* args))))))

(= cr!prim-ccc
  (named-fn cps-ccc (k1 dyn1 f)
    (f k1 dyn1 (fn (k2 dyn2 x)
                 (k1 x)))))

(= cr!sref
  (named-fn cps-sref (k dyn x key val)
    (k (sref x val key))))

(def err-hook (k dyn msg)
  (disp (+ "runtime abort: " msg "\n") (stderr))
  (quit 1))

(= cr!ar-set-err-hook
  (named-fn cps-ar-set-err-hook (k dyn hook)
    (= err-hook hook)
    (k nil)))

(def cps-fn (name f)
  (namefn (as sym (+ "cps-" (as string name)))
    (fn (k dyn . args)
      (catch
        (let r (on-err
                 (fn (c)
                   (err-hook 'not-called dyn (details c))
                   (throw))
                 (fn ()
                   (apply f args)))
          (k r))))))

(each s '(annotate assert car cdr close coerce cons dir dir-exists
          details err infile instring is is-ssyntax len mod namefn
          newstring
          outfile outstring quit rep scar scdr sread ssyntax table tagged
          type
          uniq xhash + - * /)
  (= cr.s
     (let f (eval s)
       (namefn (as sym (+ "cps-" (as string s)))
         (cps-fn s f)))))

(def cps (f)
  (fn (k . args)
    (k (apply f args))))

(= cr!ar-<2     (cps-fn 'ar-<2 <))
(= cr!ar->2     (cps-fn 'ar->2 >))
(= cr!ar-disp   (cps-fn 'ar-disp disp))
(= cr!ar-write  (cps-fn 'ar-write write))
(= cr!ar-writec (cps-fn 'ar-writec writec))

(= cr!getdyn
  (named-fn cps-get-dyn (k dyn)
    (k dyn)))

; bogus has
(= cr!has
  (cps-fn 'has (fn (g k)
                 (isnt (g k) nil))))

; bogus atomic-invoke
(= cr!atomic-invoke
  (fn (k dyn f)
    (f k dyn)))

(def cr-parameter ((o name))
  (annotate 'param (uniq name)))

(= cr!parameter (cps-fn 'parameter cr-parameter))

(= cr!ar-string-append (cps-fn 'ar-string-append +))

(= cr!ar-parameterize
  (named-fn cps-ar-parameterize (k dyn param val thunk)
    (unless (isa param 'param)
      (err "not a parameter:" param))
    (thunk k (cons (list (rep param) val) dyn))))

(= cr!stdout (cr-parameter 'stdout))
(= cr!stderr (cr-parameter 'stderr))

; ; todo not tail call
; (= cr!protect
;   (fn (k dyn during after)
;     (k (protect (fn ()
;                   (during idfn dyn))
;                 (fn ()
;                   (after idfn dyn))))))

(= cr!ar-halt0 idfn)

(= cr!ar-eval
  (named-fn cps-ar-eval (k dyn x)
    (k (eval `(let $dyn--xVrP8JItk2Ot ',dyn ,(unprimitive x))))))

(= cr!t 't)

(= cr!ar-cps-call cps-call)

; todo tail call (maybe define in Arc?)
(= cr!maptable
  (named-fn cps-maptable (k dyn f table)
    (maptable (fn (key val)
                (f idfn dyn key val))
              table)))
