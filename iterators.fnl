(local fennel (require :fennel))
(import-macros co (: ... :gsub "(.*)%.iterators$" "%1.coroutine"))

(fn iterate [collection]
  (match (type collection)
    :function collection
    :table (co.wrap (each [_ v (ipairs collection)] (co.yield v)))))

(fn count [coll]
  (let [it (iterate coll)]
    (fn count-helper [n]
      (match (it)
        nil n
        _ (count-helper (+ 1 n))))
    (count-helper 0)))

(fn first [coll] ((iterate coll)))

(fn last [coll]
  (let [it (iterate coll)]
    (fn last-helper [prev]
      (match (it)
        nil prev
        v (last-helper v)))
    (last-helper nil)))

(fn filter [coll pred]
  (let [it (iterate coll)]
    (fn filter-helper []
      (match (it)
        nil nil
        v (if (pred v) v (filter-helper))))))

(fn map [coll f]
  (let [it (iterate coll)]
    (fn []
      (match (it)
        nil nil
        v (f v)))))

(fn reduce [coll acc f]
  (let [it (iterate coll)]
    (match (it)
      nil acc
      v (reduce it (f v acc) f))))

; TODO: rewrite using for
(fn range [from to]
  (local stop (+ to 1))
  (var n (- from 1))
  (fn [] (match n
           stop nil
           _ (do (set n (+ 1 n)) n))))

(fn gather [coll]
  (reduce coll [] (fn [v acc] (doto acc (table.insert v)))))

(fn tee [coll f]
  (let [it (iterate coll)]
    (fn [] (match (it)
             nil nil
             v (do (f v) v)))))

(fn repeat [generator] #(generator))

(fn split [coll pred] ; split when pred is true
  (fn splitter [item groups]
    (let [last-group (. groups (length groups))
          last-group-not-empty (> (length last-group) 0)]
      (if (pred item)
        (if last-group-not-empty (table.insert groups []))
        (table.insert last-group item)))
    groups)
  (let [groups (reduce coll [[]] splitter)
        last-group (. groups (length groups))]
    (if (= 0 (length last-group)) (table.remove groups (length groups)))
    groups))

(fn sum [coll] (reduce coll 0 #(+ $1 $2)))

(fn product [coll] (reduce coll 1 #(* $1 $2)))

(fn take-n [coll n]
  (let [it (iterate coll)]
    (co.wrap (for [_ 1 n] (co.yield (it))))))

(fn take-while [coll pred]
  (let [it (iterate coll)]
    (co.wrap
      (each [v it :until (not (pred v))]
        (co.yield v)))))

(fn window [coll n]
  (let [it (iterate coll)]
    (co.wrap
      (let [buffer (gather (take-n it n))]
        (co.yield buffer)
        (each [v it]
          (table.remove buffer 1)
          (table.insert buffer v)
          (co.yield buffer))))))

{: count
 : filter
 : first
 : gather
 : iterate
 : last
 : map
 : product
 : range
 : reduce
 : repeat
 : split
 : sum
 : take-n
 : take-while
 : tee
 : window}
