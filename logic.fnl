(local {: iterate} (require (: ... :gsub "(.*)%.logic$" "%1.iterators")))

(fn all [coll]
  (fn all-helper [it]
    (match (it)
      nil true
      v (if v (all-helper it) false)))
  (all-helper (iterate coll)))

(fn any [coll]
  (fn any-helper [it]
    (match (it)
      nil false
      v (if v true (any-helper it))))
  (any-helper (iterate coll)))

{: all
 : any}
