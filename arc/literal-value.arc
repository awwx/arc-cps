(def literal-value (x)
  (if (or (isa x 'sym) (isa x 'cons))
       (if (is x 'nil)
            nil
           (or (caris x quote) (caris x 'quote) (caris x '$quote--xVrP8JItk2Ot))
            (cadr x)
           (err "not a literal value" x))
       x))
