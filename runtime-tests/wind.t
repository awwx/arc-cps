; An abort continuation

(test
  (trace
    (say 'start)
    (dynamic-wind
      (fn ()
        (say 'in))
      (fn ()
        (say 'one)
        (ccc (fn (c)
                (say 'two)
                (c nil)
                (say 'not-reached))))
      (fn ()
        (say 'out)))
    (say 'done))
  '(start in one two out done))

; The next three tests are from
; https://web.archive.org/web/20151229143803/http://mosh-scheme.googlecode.com/svn/trunk/dynamic-wind-test.scm

(test
  (trace
    (let captured nil
      (dynamic-wind
        (fn () (say 'before))
        (fn ()
          (if (ccc (fn (c)
                     (assign captured c)))
              nil
              (assign captured nil)))
        (fn () (say 'after)))
      (if captured
          (captured nil)
          (say 'done))))
  '(before after before after done))

(test
  (trace
    (let captured nil
      (dynamic-wind
        (fn () (say 'before1))
        (fn ()
          (say 'thunk1)
          (unless (ccc (fn (c)
                         (assign captured c)))
            (assign captured nil)))
        (fn () (say 'after1)))
      (dynamic-wind
        (fn () (say 'before2))
        (fn ()
          (say 'thunk2)
          (if captured
               (captured nil)
               (say 'done)))
        (fn () (say 'after2)))))
  '(before1 thunk1 after1 before2 thunk2 after2
    before1 after1 before2 thunk2 done after2))

(test
  (trace
    (let captured nil
      (dynamic-wind
        (fn () (say 'before1))
        (fn ()
          (say 'thunk1)
          (dynamic-wind
            (fn () (say 'before1-1))
            (fn ()
              (say 'thunk1-1)
              (unless (ccc (fn (c)
                             (assign captured c)))
                (assign captured nil)))
            (fn () (say 'after1-1))))
        (fn () (say 'after1)))
      (dynamic-wind
        (fn () (say 'before2))
        (fn ()
          (say 'thunk2)
          (if captured
               (captured nil)
               (say 'done)))
        (fn () (say 'after2)))))
  '(before1 thunk1 before1-1 thunk1-1 after1-1 after1
    before2 thunk2 after2 before1 before1-1 after1-1
    after1 before2 thunk2 done after2))


; Nested dynamic-wind

(test
  (trace
    (let captured nil
      (dynamic-wind
        (fn ()
          (say 'before1)
          (dynamic-wind
            (fn ()
              (say 'before2))
            (fn ()
              (say 'thunk2)
              (unless (ccc (fn (c)
                             (assign captured c)))
                (assign captured nil)))
            (fn ()
              (say 'after2))))
          (fn ()
            (say 'thunk1)
            (if captured
                 (do (say 'invoke)
                     (captured nil)
                     (say 'not-reached))
                 (say 'done1)))
          (fn ()
            (say 'after1)))))
  '(before1 before2 thunk2 after2 thunk1 invoke
    after1 before2 after2 thunk1 done1 after1))


; Recursively invoked dynamic-wind

(test
  (trace
    ((afn (n)
       (dynamic-wind
         (fn ()
           (say `(before ,n)))
         (fn ()
           (say `(enter ,n))
           (when (< n 2)
             (self (+ n 1)))
           (say `(exit ,n)))
         (fn ()
           (say `(after ,n)))))
     0))
  '((before 0) (enter 0) (before 1) (enter 1) (before 2) (enter 2)
    (exit 2) (after 2) (exit 1) (after 1) (exit 0) (after 0)))

(test
  (trace
    (let captured nil
      ((afn (n)
         (dynamic-wind
           (fn ()
             (say `(before ,n)))
           (fn ()
             (say `(enter ,n))
             (if (< n 2)
                  (self (+ n 1))
                  (unless (ccc (fn (c)
                                 (assign captured c)))
                    (assign captured nil)))
             (say `(exit ,n)))
           (fn ()
             (say `(after ,n)))))
       0)
      (when captured
        (captured nil))))
  '((before 0) (enter 0) (before 1) (enter 1) (before 2) (enter 2)
    (exit 2) (after 2) (exit 1) (after 1) (exit 0) (after 0)
    (before 0) (before 1) (before 2)
    (exit 2) (after 2) (exit 1) (after 1) (exit 0) (after 0)))

(test
  (trace
    (with (captured nil a (parameter))
      (parameterize a 1
        (dynamic-wind
          (fn ()
            (say `(before ,(a))))
          (fn ()
            (parameterize a 2
              (unless (ccc (fn (c)
                             (assign captured c)))
                (assign captured nil))
              (say `(body ,(a)))))
          (fn ()
            (say `(after ,(a)))))
        (if captured
             (parameterize a 3
               (captured nil))
             (say 'done)))))
  '((before 1) (body 2) (after 1)
    (before 1) (body 2) (after 1)
    done))
