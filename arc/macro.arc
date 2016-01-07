(= compile-options (parameter))

(def compile (option-name)
  ((compile-options) option-name))

(mac w/compile-options (opt . body)
  `(parameterize ,compile-options ,opt ,@body))

(w/compile-options (obj foo 12 bar 45)
  (test compile!foo 12))

(def amacro (x)
  (and (isa x 'mac) x))

(def macro (x)
  (or (amacro x)
      (and (isa x 'sym)
           (amacro (compile!globals x)))))

(def is-lexical (v env)
  (and (isa v 'sym) (mem v env)))

(def macro-expand (e globals)
  (w/compile-options (obj globals globals)
    (macro-expand0 e nil)))

(prim-namespace

(def macro-expand0 (e env)
  (aif (is e 'nil)
        `($quote nil)
       (and (isa e 'sym) (is-ssyntax e))
        (macro-expand0 (expand-ssyntax e) env)
       (isa e 'sym)
        (macro-expand-var e env)
       (caris e '$assign)
        (macro-expand-assign e env)
       (caris e '$begin)
         `($begin ,@(map [macro-expand0 _ env] (cdr e)))
       (caris e '$fn)
        (macro-expand-fn e env)
       (caris e '$if)
        (macro-expand-if e env)
       (caris e '$quote)
        e
       (and (acons e)
            (~is-lexical (car e) env)
            (macro (car e)))
        (expand-macro it (cdr e) env)
       (acons e)
        (macro-expand-call e env)
        e))

(def macro-expand-call (e env)
  (macro-expand-each e env))

(def macro-expand-each (es env)
  (map [macro-expand0 _ env] es))

(def macro-expand-var (var env)
  (if (is-lexical var env)
       var
       (macro-expand-global-var var env)))

(def macro-expand-global-var (var env)
  (if (is var 'globals)
       compile!globals
       (let global-macro (compile!globals 'global)
         (unless global-macro
           (err "no `global` macro defined for global variable reference:" var))
         (macro-expand0 `(,global-macro ,var) env))))

(def expand-macro (m args env)
  (if compile!xcompile-implicit
       (macro-expand0 (apply (rep m) compile!xcompile-dyn args) env)
      compile!xcompile-cps
       (macro-expand0 (apply (rep m) idfn compile!xcompile-dyn args) env)
       (macro-expand0 (apply (rep m) args) env)))

(def macro-expand-assign ((_assign var value) env)
  (if (is-lexical var env)
       `($assign ,var ,(macro-expand0 value env))
       (let set-global (compile!globals 'set-global)
         (unless set-global
           (err "no `set-global` macro defined for setting global variable:" var))
         (macro-expand0 `(,set-global ,var ,value) env))))

(def arglist (args)
  (if (no args)
       nil
      (isa args 'sym)
       (list args)
      (and (cdr args) (isa (cdr args) 'sym))
       (list (car args) (cdr args))
       (cons (car args) (arglist (cdr args)))))

(def macro-expand-fn ((_fn args . body) env)
  `($fn ,args
     ,@(macro-expand-each body (join (arglist args) env))))

(def macro-expand-if ((_if . body) env)
  `($if ,@(macro-expand-each body env)))

(def unprimitive (x)
  (if (no (acons x))
       x
      (caris x '$quote)
       `(quote ,(cadr x))
      (caris x '$assign)
       `(assign ,(x 1) ,(unprimitive (x 2)))
      (caris x '$fn)
       `(fn ,(cadr x) ,@(map unprimitive (cddr x)))
      (caris x '$if)
        `(if ,@(map unprimitive (cdr x)))
        (map unprimitive x)))

)
