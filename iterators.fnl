(import-macros co (: ... :gsub "(.*)%.iterators$" "%1.coroutine"))

(fn filter [it pred]
  (fn filter-helper []
    (match (it)
      nil nil
      v (if (pred v) v (filter-helper)))))

(fn for-each [it f] (each [v it] (f v)))

(fn repeat [v] (fn [] v))

(fn take-n [it n]
  (co.wrap (for [_ 1 n] (co.yield (it)))))

(fn take-while [it pred]
  (co.wrap
    (each [v it :until (not (pred v))]
      (co.yield v))))

{: filter
 : for-each
 : repeat
 : take-n
 : take-while}
