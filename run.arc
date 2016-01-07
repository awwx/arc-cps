(def uniq ((o name))
  (if name
       (coerce (+ (coerce name 'string) "--" (rand-string 12)) 'sym)
       (coerce (rand-string 12) 'sym)))

(def assert (x)
  (if x
       (prn "assertion ok")
       (do (prn "assertion fail")
           (quit 1))))

(wipe xhash-globals)

(= print-mapping
  (obj $assign--xVrP8JItk2Ot '$assign
       $begin--xVrP8JItk2Ot  '$begin
       $dyn--xVrP8JItk2Ot    '$dyn
       $fn--xVrP8JItk2Ot     '$fn
       $if--xVrP8JItk2Ot     '$if
       $quote--xVrP8JItk2Ot  '$quote))

(def xhash (x)
  (aif (and xhash-globals (is x xhash-globals))
        '$globals
       (isa x 'table)
        '<<table>>
       (print-mapping x)
        it
       (acons x)
        (cons (xhash (car x))
              (xhash (cdr x)))
        x))

(= source-dirs '("arc" "runtime-tests" "common-tests"))

(def default-arc-extension (file)
  (let file (coerce file 'string)
    (if (find #\. file)
         file
         (+ file ".arc"))))

(def sourcepath (name)
  (let name (string name)
    (aif (dir-exists name)
          (map [+ name "/" _] (dir name))
         (file-exists (default-arc-extension name))
          (list it)
         (some [file-exists (+ _ "/" (default-arc-extension name))]
               source-dirs)
          (list it)
          (err "source file not found:" name))))

(def loadf0 (f filename)
  (w/infile in filename
    (w/uniq eof
      (whiler x (read in eof) eof
        (f x)))))

(def loadf (f . files)
  (each file (flat (map sourcepath (flat files)))
    (prn file)
    (loadf0 f file)))

(def xload files
  (apply loadf eval files))

(mac trace body
  `(accum say ,@body))

(xload 'extend-def
       'iso-table
       'iso-tagged
       'test2
       'p-pretty.arc
       'parameterize0
       'common-tests

       'more-tests/tablist.t

       'trace.t
       'capture-dyn-using-catch
       'capture-dyn.t

       'namespace
       'prim-namespace

       'ssyntax
       'ssyntax.t
       'macro
       'macro.t

       'implicit

       'literal0
       'cps
       'cps-runtime
       'cps.t)

(= ar-cps-call cps-call)

(xload 'cps-call)

(= xhash-globals cr)

(def size (x)
  (if (no x)
       0
      (acons x)
       (+ (size (car x)) (size (cdr x)))
       1))

(test (size 'a) 1)
(test (size '(a ((b (c)) d) (e) f)) 6)

(wipe verbose-size)
(wipe verbose)

(= starting-dyn
  `((,(rep cr!stdout) ,(stdout))
    (,(rep cr!stderr) ,(stderr))))

(def c-eval (x (o dyn starting-dyn))
  (when verbose-size
    (p size.x))
  (when verbose
    (disp: "x: ")
    (pwrite (xhash x)))
  (let m
       (w/compile-options (obj globals      cr
                               xcompile-cps t
                               xcompile-dyn dyn)
         (macro-expand0 x nil))
    (when verbose-size
      (p size.m))
    (when verbose
      (disp "m: ")
      (pwrite (xhash m)))
    (let i (expand-implicit m)
      (when verbose-size
        (p size.i))
      (when verbose
        (disp "i: ")
        (pwrite (xhash i)))
      (let c (T-c i halt0)
        (when verbose-size
          (p size.c))
        (when verbose
          (let xx (xhash c)
            (disp "c: ")
            (pwrite xx)))
        (let a (cps-call-pass c)
          (when verbose-size
            (p size.a))
          (when verbose
            (disp "a: ")
            (pwrite (xhash a)))
          (let e `(let $dyn--xVrP8JItk2Ot ',dyn ,(unprimitive a))
            (when verbose-size
              (p size.e))
            (when verbose
              (disp "e: ")
              (pwrite (xhash e)))
            (eval e)))))))

(test
  (accum trace
    (let cps-trace (cps-fn 'trace trace)
      (c-eval `(,cps-trace 1) nil)))
  '(1))

(do (prim-namespace
      (c-eval `(,cr!sref ,cr ($quote foo) 123) nil))
    (test cr!foo 123)
    (wipe cr!foo))

(let g (obj 500 42)
  (test (c-eval `(,g 500) nil) 42))

(prim-namespace
  (test (c-eval `((,cr ($quote cons)) 1 2) nil) '(1 . 2)))

(do (prim-namespace
      (c-eval `((,cr ($quote sref)) ,cr ($quote foo) 123) nil))
    (test cr!foo 123)
    (wipe cr!foo))

(mac c-load files
  `(apply loadf [c-eval _ starting-dyn] ',files))

(c-load global)

(do (= cr!foo 502)
    (test (c-eval `foo nil) 502)
    (wipe cr!foo))

(c-load global.a
        set-global
        set-global.a
        quote
        quote.a
        apply.a
        assign
        assign.a
        fn
        fn.a
        prim-ccc.a
        if-3-clause
        if-3-clause.a
        do
        do.a
        def.arc
        cxr
        cxr.a
        predicates
        acons.a
        list
        list.a
        if-multi-clause
        if-multi-clause.a
        map1
        pair
        pair.a
        mac
        assert1
        with
        let
        join
        and
        and.a
        or
        or.a
        iso
        iso.a
        test1
        fn-dotted.t
        join.t
        join-dotted.t
        caris
        caris.t
        alist
        alist.t
        single
        single.t
        dotted
        dotted.t
        rreduce
        rreduce.t
        isa
        literal1
        literal.t
        literal-value
        literal-value.t
        qq/qq
        qq.t
        more-qq.t
        bound-global
        bound.t
        global-check
        parameterize1
        parameter.t
        w-uniq
        withs
        withs.t
        complex-fn
        fn.a
        fn-dotted.t
        fn-complex.t
        fn-empty-body.t
        string-ref.t
        apply-string-ref.t
        p1

        mappend1
        intersperse
        intersperse.t

        afn
        afn.t

        rev
        rev.t

        pairwise
        greater-less-than
        lt.t

        nthcdr
        nthcdr.t

        common-tail
        common-tail.t

        when
        unless

        trace
        trace.t

        capture-dyn
        capture-dyn.t

        ccc
        ccc.a
        ccc.t
        ccc-dyn.t
        wind.t

        err
        on-err.t

        car-err.t

        point
        catch.t
        capture-dyn-ccc.t

        protect
        protect.t

        writec
        arc2
        after.t
        compose-string-ref.t
        test2
        car.t

        compose.t
        ssyntax-compose.t
        on-err.t
        ssyntax
        ssyntax.t
        namespace
        prim-namespace
        macro
        macro.t
        implicit
        literal1
        cps
        cps-call
        p2
        eval-cps
        load)

(test (c-eval '(eval 3))        3)
(test (c-eval '(eval '(+ 4 7))) 11)
(test (c-eval '(read "(a b)"))  '(a b))

(c-eval '(load 'arc/arc3
               'arc/iso-table
               'arc/iso-tagged
               'common-tests
               'runtime-tests
               'more-tests))
